import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../FullMetadataReader.dart';

/// Represents tbl_musicbrainz in the database
///
/// Holds MusicBrainz/AcoustID identifiers for a song, kept separate from
/// tbl_fmetadata since these are only present for files tagged by a
/// MusicBrainz-aware tagger (e.g. Picard) and are looked up by id rather
/// than by the usual title/artist/album text columns
final class TableMusicBrainz {
  TableMusicBrainz.privateConstructor();

  static const String name = "tbl_musicbrainz";
  static const String idCol = "song_id";
  static const String recordingIdCol = "recording_id";
  static const String releaseIdCol = "release_id";
  static const String releaseGroupIdCol = "release_group_id";
  static const String releaseTrackIdCol = "release_track_id";
  static const String artistIdCol = "artist_id";
  static const String albumArtistIdCol = "album_artist_id";
  static const String workIdCol = "work_id";
  static const String acoustIdCol = "acoustid";

  /// Sets the MusicBrainz ids for the given songId, replacing any existing row
  ///
  /// If [ids] has nothing set (the file has no MusicBrainz tags), any
  /// existing row for this song is removed instead of writing an all-null row
  static Future<void> setMusicBrainzIdsUnchecked(DatabaseExecutor db, int songId, MusicBrainzIds ids) async {
    if (ids.isEmpty) {
      await db.delete(name, where: "$idCol = ?", whereArgs: [songId]);
      return;
    }

    logging.info("Setting MusicBrainz ids for song $songId");

    await db.insert(
        name,
        {
          idCol: songId,
          recordingIdCol: ids.recordingId,
          releaseIdCol: ids.releaseId,
          releaseGroupIdCol: ids.releaseGroupId,
          releaseTrackIdCol: ids.releaseTrackId,
          artistIdCol: ids.artistId,
          albumArtistIdCol: ids.albumArtistId,
          workIdCol: ids.workId,
          acoustIdCol: ids.acoustId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Selects the MusicBrainz ids for the given songId
  ///
  /// Returns null if the song has no MusicBrainz tags on file
  static Future<MusicBrainzIds?> selectForSongId(DatabaseExecutor db, int songId) async {
    final result = await db.query(name, where: "$idCol = ?", whereArgs: [songId]);

    final row = result.firstOrNull;

    if (row == null) return null;

    return fromMap(row);
  }

  /// Returns a MusicBrainzIds object from a map of column names to their datatype
  static MusicBrainzIds fromMap(Map<String, Object?> e) {
    return MusicBrainzIds(
      recordingId: e[recordingIdCol] as String?,
      releaseId: e[releaseIdCol] as String?,
      releaseGroupId: e[releaseGroupIdCol] as String?,
      releaseTrackId: e[releaseTrackIdCol] as String?,
      artistId: e[artistIdCol] as String?,
      albumArtistId: e[albumArtistIdCol] as String?,
      workId: e[workIdCol] as String?,
      acoustId: e[acoustIdCol] as String?,
    );
  }
}
