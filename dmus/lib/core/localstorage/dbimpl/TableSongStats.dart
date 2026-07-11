import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

/// A song's local playback behaviour statistics
class SongStats {
  final int playCount;
  final int skipCount;
  final DateTime? lastPlayedAt;

  const SongStats({required this.playCount, required this.skipCount, this.lastPlayedAt});
}

/// Represents tbl_song_stats in the database
///
/// Tracks local playback behaviour per song (play count, skip count, last
/// played). Kept separate from tbl_fmetadata since this is behavioural data
/// that changes on every play/skip, rather than metadata read once from a
/// file's tags
final class TableSongStats {
  TableSongStats.privateConstructor();

  static const String name = "tbl_song_stats";
  static const String idCol = "song_id";
  static const String playCountCol = "play_count";
  static const String skipCountCol = "skip_count";
  static const String lastPlayedAtCol = "last_played_at";

  /// Records that the song started playing: increments playCount and sets lastPlayedAt to now
  static Future<void> recordPlayStarted(DatabaseExecutor db, int songId) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final rowsAffected = await db.rawUpdate(
        "UPDATE $name SET $playCountCol = $playCountCol + 1, $lastPlayedAtCol = ? WHERE $idCol = ?", [now, songId]);

    if (rowsAffected == 0) {
      await db.insert(name, {idCol: songId, playCountCol: 1, skipCountCol: 0, lastPlayedAtCol: now});
    }

    logging.finest("Recorded play for song $songId");
  }

  /// Records that the song was skipped: increments skipCount only
  ///
  /// Used both for a song abandoned early during playback and for an
  /// upcoming (not yet played) song removed from the queue
  static Future<void> recordSkipped(DatabaseExecutor db, int songId) async {
    final rowsAffected =
        await db.rawUpdate("UPDATE $name SET $skipCountCol = $skipCountCol + 1 WHERE $idCol = ?", [songId]);

    if (rowsAffected == 0) {
      await db.insert(name, {idCol: songId, playCountCol: 0, skipCountCol: 1, lastPlayedAtCol: null});
    }

    logging.finest("Recorded skip for song $songId");
  }

  /// Selects stats for the given songIds in one query
  ///
  /// Songs with no row (never played or skipped) are simply absent from the result
  static Future<Map<int, SongStats>> selectStatsForSongIds(DatabaseExecutor db, List<int> songIds) async {
    if (songIds.isEmpty) return {};

    final result =
        await db.query(name, where: "$idCol IN (${songIds.map((e) => "?").join(",")})", whereArgs: songIds);

    return {for (final row in result) row[idCol] as int: fromMap(row)};
  }

  /// Selects stats for a single songId
  ///
  /// Returns null if the song has never been played or skipped
  static Future<SongStats?> selectStatsForSongId(DatabaseExecutor db, int songId) async {
    final result = await db.query(name, where: "$idCol = ?", whereArgs: [songId]);

    final row = result.firstOrNull;

    if (row == null) return null;

    return fromMap(row);
  }

  /// Returns a SongStats object from a map of column names to their datatype
  static SongStats fromMap(Map<String, Object?> e) {
    final lastPlayedMs = e[lastPlayedAtCol] as int?;

    return SongStats(
      playCount: e[playCountCol] as int? ?? 0,
      skipCount: e[skipCountCol] as int? ?? 0,
      lastPlayedAt: lastPlayedMs == null ? null : DateTime.fromMillisecondsSinceEpoch(lastPlayedMs),
    );
  }
}
