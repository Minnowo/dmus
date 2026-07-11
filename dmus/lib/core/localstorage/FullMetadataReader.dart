import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

/// Common cross-format tags that are useful enough to keep in their own
/// database columns, but which the package's unified [AudioMetadata] drops
class CommonExtraMetadata {
  /// Beats per minute, when tagged
  final int? bpm;

  /// The composer, distinct from the performing artist (most relevant for
  /// classical music, but tagged for other genres too)
  final String? composer;

  /// The ISRC (International Standard Recording Code), a stable id for the
  /// exact recording independent of how the file itself is tagged
  final String? isrc;

  /// The performing artist of this specific track
  ///
  /// For formats where the file only tags one "artist" (Vorbis comments
  /// merge ARTIST/ALBUMARTIST into the same field, MP4/RIFF/AIFF only have
  /// one artist field at all), this is the same value as [albumArtist]
  final String? trackArtist;

  /// The artist credited for the album as a whole (relevant for
  /// compilations/various-artist albums, where this differs from the
  /// individual track's artist)
  final String? albumArtist;

  const CommonExtraMetadata({this.bpm, this.composer, this.isrc, this.trackArtist, this.albumArtist});
}

/// MusicBrainz (and AcoustID) identifiers embedded by taggers such as
/// MusicBrainz Picard
///
/// These identify the same underlying artist/release/recording by a stable
/// id, regardless of how the corresponding text tag (artist name, album
/// title, ...) happens to be spelled
class MusicBrainzIds {
  /// The MusicBrainz Recording id (historically tagged as "track id")
  ///
  /// Only reliably available for Vorbis comments (FLAC/OGG) and APEv2. MP3
  /// files store this in the ID3v2 UFID frame, which this package does not
  /// currently parse
  final String? recordingId;

  /// The MusicBrainz Release id (historically tagged as "album id")
  final String? releaseId;

  /// The MusicBrainz Release Group id - stable across different editions
  ////reissues of the same album
  final String? releaseGroupId;

  /// The MusicBrainz Release Track id
  final String? releaseTrackId;

  /// The MusicBrainz Artist id of the (primary) track artist
  final String? artistId;

  /// The MusicBrainz Artist id of the album artist
  final String? albumArtistId;

  /// The MusicBrainz Work id
  final String? workId;

  /// The AcoustID, assigned from audio fingerprinting rather than tags
  final String? acoustId;

  const MusicBrainzIds({
    this.recordingId,
    this.releaseId,
    this.releaseGroupId,
    this.releaseTrackId,
    this.artistId,
    this.albumArtistId,
    this.workId,
    this.acoustId,
  });

  bool get isEmpty =>
      recordingId == null &&
      releaseId == null &&
      releaseGroupId == null &&
      releaseTrackId == null &&
      artistId == null &&
      albumArtistId == null &&
      workId == null &&
      acoustId == null;
}

/// The full result of reading a song file: the unified metadata dmus has
/// always stored, plus the additional common tags and MusicBrainz/AcoustID
/// ids that require reading the format-specific tag data to reach
class FullSongMetadata {
  final AudioMetadata metadata;
  final CommonExtraMetadata extra;
  final MusicBrainzIds musicBrainzIds;

  const FullSongMetadata({required this.metadata, required this.extra, required this.musicBrainzIds});
}

/// Reads every tag dmus cares about from [file] in a single pass
///
/// Uses [readAllMetadata] instead of the package's [readMetadata] so that
/// format-specific tags (BPM, composer, ISRC, MusicBrainz/AcoustID ids, ...)
/// that the unified reader drops are still reachable. The unified
/// [AudioMetadata] is rebuilt here the same way the package's own
/// `readMetadata()` does it, so existing callers see no change there
FullSongMetadata readFullMetadata(File file, {bool getImage = true}) {
  final tag = readAllMetadata(file, getImage: getImage);

  return switch (tag) {
    Mp3Metadata m => _fromMp3(file, m),
    VorbisMetadata m => _fromVorbis(file, m),
    Mp4Metadata m => _fromMp4(file, m),
    RiffMetadata m => _fromRiff(file, m),
    ApeMetadata m => _fromApe(file, m),
  };
}

FullSongMetadata _fromMp3(File file, Mp3Metadata m) {
  final metadata = AudioMetadata(
    file: file,
    album: m.album,
    artist: m.bandOrOrchestra ?? m.leadPerformer ?? m.originalArtist,
    bitrate: m.bitrate,
    duration: m.duration,
    language: m.languages,
    lyrics: m.lyric,
    sampleRate: m.samplerate,
    title: m.songName,
    totalDisc: m.totalDics,
    trackNumber: m.trackNumber,
    trackTotal: m.trackTotal,
    year: DateTime(m.originalReleaseYear ?? m.year ?? 0),
    discNumber: m.discNumber,
  );

  metadata.pictures = m.pictures;
  metadata.genres = m.genres;

  final guestArtistFrame = m.customMetadata["GUEST ARTIST"];

  if (guestArtistFrame != null) {
    metadata.performers.addAll(guestArtistFrame.split("/"));
  }

  return FullSongMetadata(
    metadata: metadata,
    // TPE1 (leadPerformer) is the track artist, TPE2 (bandOrOrchestra) is
    // conventionally used as the album artist by taggers like Picard
    extra: CommonExtraMetadata(
      bpm: _parseBpm(m.bpm),
      composer: m.composer,
      isrc: m.isrc,
      trackArtist: m.leadPerformer,
      albumArtist: m.bandOrOrchestra ?? m.leadPerformer,
    ),
    musicBrainzIds: _mbIdsFromMap(m.customMetadata),
  );
}

FullSongMetadata _fromVorbis(File file, VorbisMetadata m) {
  final metadata = AudioMetadata(
    file: file,
    album: m.album.firstOrNull,
    artist: m.artist.firstOrNull,
    bitrate: m.bitrate,
    discNumber: m.discNumber,
    duration: m.duration,
    language: m.language.firstOrNull,
    lyrics: m.lyric,
    sampleRate: m.sampleRate,
    title: m.title.firstOrNull,
    totalDisc: m.discTotal,
    trackNumber: m.trackNumber.firstOrNull,
    trackTotal: m.trackTotal,
    year: m.date.firstOrNull,
  );

  metadata.genres = m.genres;
  metadata.pictures = m.pictures;
  metadata.performers.addAll(m.performer);

  return FullSongMetadata(
    metadata: metadata,
    // The Vorbis comment parser folds ALBUMARTIST into the same ARTIST list
    // it reads ARTIST from, so there is no way to recover a distinct album
    // artist for FLAC/OGG/Opus with this package - both are the same value
    extra: CommonExtraMetadata(
      bpm: _parseBpm(_lookupCaseInsensitive(m.unknowns, const ["BPM", "TEMPO"])),
      composer: m.composer.firstOrNull,
      isrc: m.isrc.firstOrNull,
      trackArtist: m.artist.firstOrNull,
      albumArtist: m.artist.firstOrNull,
    ),
    musicBrainzIds: _mbIdsFromMap(m.unknowns),
  );
}

FullSongMetadata _fromMp4(File file, Mp4Metadata m) {
  final metadata = AudioMetadata(
    file: file,
    album: m.album,
    artist: m.artist,
    bitrate: m.bitrate,
    discNumber: m.discNumber,
    duration: m.duration,
    language: null,
    lyrics: m.lyrics,
    sampleRate: m.sampleRate,
    title: m.title,
    totalDisc: m.totalDiscs,
    trackNumber: m.trackNumber,
    trackTotal: m.totalTracks,
    year: m.year,
  );

  if (m.picture != null) {
    metadata.pictures.add(m.picture!);
  }

  if (m.genre != null) {
    metadata.genres.add(m.genre!);
  }

  metadata.chapters = List.of(m.chapters);

  // MP4/M4A: this package doesn't expose the 'aART' (album artist) atom or
  // freeform '----:com.apple.iTunes:...' atoms (where Picard writes
  // MusicBrainz ids), so neither a distinct album artist nor any
  // MusicBrainz/AcoustID id is reachable for this format
  return FullSongMetadata(
    metadata: metadata,
    extra: CommonExtraMetadata(trackArtist: m.artist, albumArtist: m.artist),
    musicBrainzIds: const MusicBrainzIds(),
  );
}

FullSongMetadata _fromRiff(File file, RiffMetadata m) {
  final metadata = AudioMetadata(
    file: file,
    album: m.album,
    artist: m.artist,
    bitrate: m.bitrate,
    duration: m.duration,
    language: null,
    lyrics: null,
    sampleRate: m.samplerate,
    title: m.title,
    totalDisc: null,
    trackNumber: m.trackNumber,
    trackTotal: null,
    year: m.year,
    discNumber: null,
  );

  metadata.pictures = m.pictures;
  metadata.genres = (m.genre != null) ? [m.genre!] : [];

  // WAV/AIFF: no custom-tag map is exposed by this package, so no
  // MusicBrainz/AcoustID ids are reachable for these formats
  return FullSongMetadata(
    metadata: metadata,
    extra: CommonExtraMetadata(trackArtist: m.artist, albumArtist: m.artist),
    musicBrainzIds: const MusicBrainzIds(),
  );
}

FullSongMetadata _fromApe(File file, ApeMetadata m) {
  final metadata = AudioMetadata(
    file: file,
    album: m.album,
    artist: m.artist,
    bitrate: m.bitrate,
    discNumber: m.discNumber,
    duration: m.duration,
    language: m.language.firstOrNull,
    lyrics: m.lyric,
    sampleRate: m.sampleRate,
    title: m.title,
    totalDisc: m.discTotal,
    trackNumber: m.trackNumber,
    trackTotal: m.trackTotal,
    year: m.date,
  );

  metadata.genres = m.genres;
  metadata.pictures = m.pictures;
  metadata.performers.addAll(m.performer);

  return FullSongMetadata(
    metadata: metadata,
    extra: CommonExtraMetadata(
      bpm: _parseBpm(_lookupCaseInsensitive(m.unknowns, const ["BPM", "TEMPO"])),
      composer: m.composer,
      isrc: _lookupCaseInsensitive(m.unknowns, const ["ISRC"]),
      trackArtist: m.artist,
      albumArtist: m.albumArtist ?? m.artist,
    ),
    musicBrainzIds: _mbIdsFromMap(m.unknowns),
  );
}

/// Reads MusicBrainz/AcoustID ids out of a format's free-form tag map
///
/// [raw] is either an MP3's ID3v2 TXXX map (keys like "MusicBrainz Artist
/// Id") or a Vorbis/APE unknown-comment map (keys like
/// "MUSICBRAINZ_ARTISTID") - candidate keys below cover both spellings
MusicBrainzIds _mbIdsFromMap(Map<String, String> raw) {
  return MusicBrainzIds(
    recordingId: _lookupCaseInsensitive(raw, const ["MusicBrainz Track Id", "MUSICBRAINZ_TRACKID"]),
    releaseId: _lookupCaseInsensitive(raw, const ["MusicBrainz Album Id", "MUSICBRAINZ_ALBUMID"]),
    releaseGroupId:
        _lookupCaseInsensitive(raw, const ["MusicBrainz Release Group Id", "MUSICBRAINZ_RELEASEGROUPID"]),
    releaseTrackId:
        _lookupCaseInsensitive(raw, const ["MusicBrainz Release Track Id", "MUSICBRAINZ_RELEASETRACKID"]),
    artistId: _lookupCaseInsensitive(raw, const ["MusicBrainz Artist Id", "MUSICBRAINZ_ARTISTID"]),
    albumArtistId: _lookupCaseInsensitive(raw, const ["MusicBrainz Album Artist Id", "MUSICBRAINZ_ALBUMARTISTID"]),
    workId: _lookupCaseInsensitive(raw, const ["MusicBrainz Work Id", "MUSICBRAINZ_WORKID"]),
    acoustId: _lookupCaseInsensitive(raw, const ["Acoustid Id", "ACOUSTID_ID"]),
  );
}

/// Looks up any of [keys] in [map], case-insensitively
///
/// Returns null if none of the keys are present or the matched value is
/// blank
String? _lookupCaseInsensitive(Map<String, String> map, List<String> keys) {
  final upperKeys = keys.map((e) => e.toUpperCase()).toSet();

  for (final entry in map.entries) {
    if (upperKeys.contains(entry.key.toUpperCase())) {
      final v = entry.value.trim();

      if (v.isNotEmpty) return v;
    }
  }

  return null;
}

/// Parses a BPM tag value, e.g. "128" or "128.00", into a whole number
int? _parseBpm(String? raw) {
  if (raw == null) return null;

  final match = RegExp(r'\d+').firstMatch(raw);

  if (match == null) return null;

  return int.tryParse(match.group(0)!);
}
