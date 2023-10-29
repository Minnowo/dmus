
import 'package:crypto/crypto.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';

import '../../Util.dart';

final class TableHash {

  final int id;
  final List<int> sha256;

  TableHash.privateConstructor({required this.id, required this.sha256});

  static const String name = "tbl_hash";
  static const String idCol = "id";
  static const String sha256Col = "sha256";

  static Future<int?> insertHash(Digest hash) async {

    logging.info("Inserting hash $hash");

    var db = await DatabaseController.instance.database;

    try {

      return await db.insert(name, {
        sha256Col : hash.bytes
      });

    }
    catch(e) {

      return null;
    }
  }
  static Future<int?> insertSelectHashId(Digest hash) async {

    logging.info("Inserting hash $hash");

    var db = await DatabaseController.instance.database;

    var r = await insertHash(hash);

    if(r != null) {
      return r;
    }

    var result = (await db.query(name, columns: [idCol], where: "$sha256Col = ?", whereArgs: [hash.bytes])).firstOrNull;

    if(result == null) {
      return null;
    }

    return (result[idCol] as int);
  }

  static Future<List<TableHash>> selectAll() async {

    var db = await DatabaseController.instance.database;

    var result = await db.query(name);

    return result.map((e) => TableHash.privateConstructor(id: e[idCol] as int, sha256: e[sha256Col] as List<int>)).toList();
  }

}
