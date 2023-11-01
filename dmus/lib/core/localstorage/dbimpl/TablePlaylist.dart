
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
  /// Inserts all the songs into the database
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

    var db = await DatabaseController.database;

    var playlistId = await db.insert(name, { titleCol: title });

    TablePlaylistSong.addSongsToPlaylist(playlistId, songs);

    return playlistId;
  }


  /// Gets a Iterable<Song> for all the songs of the given playlistId
  ///
  /// Throws DatabaseException
  static Future<Iterable<Song>> selectPlaylistSongs(int playlistId) async {

    var db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TablePlaylistSong.name}"
        " JOIN ${TableSong.name} ON ${TablePlaylistSong.name}.${TablePlaylistSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TablePlaylistSong.name}.${TablePlaylistSong.playlistIdCol} = ?";
    ;

    var result = await db.rawQuery(sql, [playlistId]);

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
}