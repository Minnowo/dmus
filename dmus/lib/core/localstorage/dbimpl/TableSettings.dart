
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import '../../data/MyDataEntityCache.dart';
import 'TableFMetadata.dart';



/// Represents tbl_album in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableSettings {

  TableSettings.privateConstructor();

  static const String name = "tbl_settings";
  static const String keyCol = "settings_key";
  static const String valueCol = "settings_value";
  
  static Future<Map<String, String?>> selectAll() async {
    
    final db = await DatabaseController.database;
    
    final r = await db.query(name);

    return Map.fromEntries(
        r.map((map) => MapEntry(map[keyCol] as String, map[valueCol] as String?)));
  }

  static Future<void> save(Map<String, String?> settings) async {

    final db = await DatabaseController.database;

    final batch = db.batch();

    batch.delete(name);

    settings.entries
        .map((e) => { keyCol : e.key, valueCol : e.value})
        .forEach((d) => batch.insert(name, d));

    await batch.commit();
  }


  static Future<void> persist(String key, String value) async {

    final db = await DatabaseController.database;

    await db.delete(name, where: "$keyCol = ?", whereArgs: [key]);
    await db.insert(name, { keyCol : key, valueCol : value });
  }
}
