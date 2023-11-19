
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import 'TableFMetadata.dart';



/// Represents tbl_playlist in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TablePlaylist {

  final int id;
  final String title;

  TablePlaylist.privateConstructor({required this.id, required this.title});

  static const String name = "tbl_playlist";
  static const String idCol = "id";
  static const String titleCol = "title";

  
  /// Inserts a new playlist into the database
  ///
  /// Assumes all the songs exist in the database
  ///
  /// Returns null if the title is empty
  ///
  /// Returns the playlistId of the inserted playlist
  ///
  /// Throws DatabaseException
  static Future<int?> insertPlaylist(String title, List<Song> songs) async {

    if(title.isEmpty) {
      logging.warning("Cannot insert playlist with title $title because it is empty");
      return null;
    }

    logging.finest("Creating playlist with title: $title and songs $songs");

    final db = await DatabaseController.database;

    final playlistId = await db.insert(name, { titleCol: title });

    TablePlaylistSong.setSongsInPlaylist(playlistId, songs);

    return playlistId;
  }


  /// Updates a playlist
  ///
  /// Assumes all the songs are in the database
  ///
  /// Returns null if the title is empty
  ///
  /// Returns null if the playlist id does not exist
  ///
  /// Returns the playlistId of the inserted playlist
  ///
  /// Throws DatabaseException
  static Future<int?> updatePlaylist(int playlistId, String title, List<Song> songs) async {

    if(title.isEmpty) {
      logging.warning("Cannot update playlist with empty title");
      return null;
    }

    logging.finest("Updating playlist with id: $playlistId title: $title and songs $songs");

    final db = await DatabaseController.database;

    final exists = await db.query(name, where: '$idCol = ?', whereArgs: [playlistId]);

    if(exists.firstOrNull == null) {
      logging.warning("Cannot update playlist which does not exist");
      return null;
    }

    await db.update(name,
      where: '$idCol = ?',
      whereArgs: [playlistId],
      {
        titleCol: title
      },
    );

    TablePlaylistSong.setSongsInPlaylist(playlistId, songs);

    return playlistId;
  }


  /// Gets a Iterable<Song> for all the songs of the given playlistId
  ///
  /// Throws DatabaseException
  static Future<Iterable<Song>> selectPlaylistSongs(int playlistId) async {

    final db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TablePlaylistSong.name}"
        " JOIN ${TableSong.name} ON ${TablePlaylistSong.name}.${TablePlaylistSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TablePlaylistSong.name}.${TablePlaylistSong.playlistIdCol} = ?"
        " ORDER BY ${TablePlaylistSong.songIndexCol}"
    ;

    final result = await db.rawQuery(sql, [playlistId]);

    return result.map((e) => TableSong.fromMappedObjects(e));
  }


  /// Gets all playlists from the database
  ///
  /// Throws DatabaseException
  static Future<List<Playlist>> selectAll() async {

    var db = await DatabaseController.database;

    var playlistsResult = await db.query(TablePlaylist.name);

    List<Playlist> playlists = [];

    for(var e in playlistsResult) {

      int id = e[TablePlaylist.idCol] as int;

      Playlist p = Playlist(id: id, title: e[TablePlaylist.titleCol] as String);

      p.songs.addAll(await selectPlaylistSongs(id));

      p.updateDuration();

      playlists.add(p);
    }

    return playlists;
  }

  /// Deletes a playlist from the database
  ///
  /// Returns true if the deletion is successful, false otherwise
  ///
  /// Throws DatabaseException
  static Future<bool> deletePlaylist(int playlistId) async {
    try {
      final db = await DatabaseController.database;

      // Check if the playlist exists
      final exists = await db.query(name, where: '$idCol = ?', whereArgs: [playlistId]);
      if (exists.isEmpty) {
        logging.finest("Cannot delete playlist with id $playlistId because it does not exist");
        return false;
      }

      // Delete the playlist and associated songs
      await db.transaction((txn) async {
        await txn.delete(TablePlaylistSong.name,
            where: '${TablePlaylistSong.playlistIdCol} = ?', whereArgs: [playlistId]);
        await txn.delete(name, where: '$idCol = ?', whereArgs: [playlistId]);
      });

      logging.finest("Playlist with id $playlistId deleted successfully");
      return true;
    } catch (e) {
      logging.warning("Error deleting playlist: $e");
      return false;
    }
  }
}
