import 'dart:io';
import 'dart:ui';

import 'package:dmus/core/data/MyDataEntityCache.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:dmus/generated/l10n.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Stands in for the real path_provider platform channel, which doesn't
/// exist under `flutter test`. Only the paths dmus actually reads
/// (temporary/application-documents) are implemented; anything else throws
/// via [Fake]'s noSuchMethod if it's ever called.
class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final String path;

  FakePathProviderPlatform(this.path);

  @override
  Future<String?> getTemporaryPath() async => path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;

  @override
  Future<String?> getApplicationSupportPath() async => path;
}

/// Stands in for the real permission_handler platform channel. Always
/// reports permissions as granted - ImageCacheController's cover-art lookup
/// calls getExternalStoragePermission() unconditionally, and under
/// `flutter test` there's no real platform to grant/deny anything.
class FakePermissionHandlerPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async => PermissionStatus.granted;
}

bool _ffiInitialized = false;

/// Initializes the FFI-backed sqflite engine (once per test process),
/// points path_provider/permission_handler at fakes, and loads the S
/// localization delegate, so DatabaseController/ImageCacheController/
/// anything reading S.current (e.g. TablePlaylist.likedPlaylistName) works
/// under plain `flutter test`.
///
/// `flutter test` runs each test *file* in its own isolate/process, in
/// parallel by default. DatabaseController always opens the same fixed
/// filename ("client.db"), so every test file's sqlite databases directory
/// must be unique or concurrent files collide on the same physical db file
/// (seen as "database is locked" / "disk I/O error" / "attempt to write a
/// readonly database"). Pointing databaseFactory at this file's own temp dir
/// gives each test file an isolated db while still running in parallel.
///
/// Call this from setUpAll before touching DatabaseController.
Future<Directory> setUpDbTest() async {
  if (!_ffiInitialized) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _ffiInitialized = true;
  }

  await S.initLocale(const Locale('en'));

  final tempDir = await Directory.systemTemp.createTemp('dmus_test_');
  await databaseFactory.setDatabasesPath(tempDir.path);
  PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
  PermissionHandlerPlatform.instance = FakePermissionHandlerPlatform();

  return tempDir;
}

/// Closes and deletes the current test database, then eagerly reopens a
/// fresh one so every test starts from a clean schema. Also clears
/// MyDataEntityCache, since a fresh db restarts autoincrement ids from 1 -
/// without clearing it, a Song/Playlist/Album cached under id 1 by one test
/// would shadow a completely different row with the same reused id in the
/// next test. Also resets TableLikes.likedPlaylist, another static cache
/// that would otherwise leak the Favorites playlist across tests.
///
/// The db reopen can't be left lazy (i.e. left for whatever the next test
/// happens to call): DatabaseController's onOpen hook repopulates
/// TableBlacklist's static in-memory cache, and a test that only exercises
/// synchronous cache-reading methods (e.g. TableBlacklist.selectAll) would
/// never trigger that reload itself, leaving it stale from the previous
/// test.
Future<void> resetTestDatabase() async {
  final db = await DatabaseController.database;

  if (db.isOpen) {
    await db.close();
  }

  final dbPath = path.join(await getDatabasesPath(), DatabaseController.databaseFilename);

  await deleteDatabase(dbPath);

  MyDataEntityCache.clearForTesting();
  TableLikes.likedPlaylist = null;

  await DatabaseController.database;
}

/// Creates a throwaway "song" file fixture. TableFMetadata falls back to a
/// filename-based title when metadata can't be read, so the content doesn't
/// need to be real audio.
Future<File> createFakeSongFile(Directory dir, String name) async {
  final file = File(path.join(dir.path, name));
  await file.writeAsBytes(const [0, 1, 2, 3]);
  return file;
}
