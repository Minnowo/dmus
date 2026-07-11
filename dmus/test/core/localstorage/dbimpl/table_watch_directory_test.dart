import 'dart:io';

import 'package:dmus/core/localstorage/dbimpl/TableWatchDirectory.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  group('TableWatchDirectory.insertDirectory', () {
    test('inserts a directory and returns its row id', () async {
      final id = await TableWatchDirectory.insertDirectory(File('/music/watched').absolute, 30, true);

      expect(id, isNotNull);

      final all = await TableWatchDirectory.selectAll();

      expect(all, hasLength(1));
      expect(all.single.directoryPath, File('/music/watched').absolute.path);
      expect(all.single.checkInterval, 30);
      expect(all.single.isRecursive, isTrue);
    });

    test('stores isRecursive: false correctly', () async {
      await TableWatchDirectory.insertDirectory(File('/music/watched').absolute, 30, false);

      final all = await TableWatchDirectory.selectAll();

      expect(all.single.isRecursive, isFalse);
    });

    test('stores the absolute path even if given a relative File', () async {
      await TableWatchDirectory.insertDirectory(File('relative/dir'), 60, false);

      final all = await TableWatchDirectory.selectAll();

      expect(all.single.directoryPath, File('relative/dir').absolute.path);
    });

    test('returns null instead of throwing when the directory is already watched', () async {
      final dir = File('/music/watched').absolute;

      final firstId = await TableWatchDirectory.insertDirectory(dir, 30, true);
      final secondId = await TableWatchDirectory.insertDirectory(dir, 60, false);

      expect(firstId, isNotNull);
      expect(secondId, isNull);

      final all = await TableWatchDirectory.selectAll();

      expect(all, hasLength(1));
      expect(all.single.checkInterval, 30);
    });
  });

  group('TableWatchDirectory.selectAll', () {
    test('returns an empty list when no directories are watched', () async {
      expect(await TableWatchDirectory.selectAll(), isEmpty);
    });

    test('returns every watched directory', () async {
      await TableWatchDirectory.insertDirectory(File('/music/a').absolute, 30, true);
      await TableWatchDirectory.insertDirectory(File('/music/b').absolute, 60, false);

      final all = await TableWatchDirectory.selectAll();

      expect(all, hasLength(2));
      expect(all.map((e) => e.directoryPath),
          containsAll([File('/music/a').absolute.path, File('/music/b').absolute.path]));
    });
  });

  group('TableWatchDirectory.removeDirectory', () {
    test('removes a watched directory and reports 1 row removed', () async {
      final dir = File('/music/watched').absolute;
      await TableWatchDirectory.insertDirectory(dir, 30, true);

      final removed = await TableWatchDirectory.removeDirectory(dir);

      expect(removed, 1);
      expect(await TableWatchDirectory.selectAll(), isEmpty);
    });

    test('reports 0 rows removed for a directory that was never watched', () async {
      final removed = await TableWatchDirectory.removeDirectory(File('/music/never-watched').absolute);

      expect(removed, 0);
    });
  });
}
