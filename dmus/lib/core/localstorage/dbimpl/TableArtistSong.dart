
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import 'TableFMetadata.dart';



final class TableArtistSong {

  final int artistId;
  final int songId;
  final int index;

  TableArtistSong.privateConstructor({required this.artistId, required this.songId, required this.index});

  static const String name = "tbl_artist_song";
  static const String artistIdCol= "artist_id";
  static const String songIdCol = "song_id";
  static const String songIndexCol = "song_index";
  static const String songAlbumCol = "song_album";

  static Future<bool> setSongsInArtist(int playlistId, List<Song> songs) async {

    var db = await DatabaseController.database;

    await db.delete(
      name,
      where: '$artistIdCol = ?',
      whereArgs: [playlistId],
    );

    const String sql = "INSERT OR IGNORE INTO $name ($artistIdCol, $songIdCol, $songIndexCol, $songAlbumCol) VALUES (?, ?, ?, ?);";

    for(int i = 0; i < songs.length; i++) {

      await db.rawInsert(sql, [playlistId, songs[i].id, i, songs[i].songAlbum()]);
    }

    return true;
  }
}
