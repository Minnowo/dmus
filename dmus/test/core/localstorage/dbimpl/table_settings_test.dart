import 'package:dmus/core/localstorage/dbimpl/TableSettings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  group('TableSettings.selectAll', () {
    test('returns an empty map when nothing has been saved', () async {
      expect(await TableSettings.selectAll(), isEmpty);
    });

    test('returns everything previously persisted', () async {
      await TableSettings.persist('theme', 'dark');
      await TableSettings.persist('shuffle', 'true');

      final result = await TableSettings.selectAll();

      expect(result, {'theme': 'dark', 'shuffle': 'true'});
    });
  });

  group('TableSettings.persist', () {
    test('inserts a new key/value pair', () async {
      await TableSettings.persist('theme', 'dark');

      expect(await TableSettings.selectAll(), {'theme': 'dark'});
    });

    test('overwrites an existing key rather than duplicating it', () async {
      await TableSettings.persist('theme', 'dark');
      await TableSettings.persist('theme', 'light');

      expect(await TableSettings.selectAll(), {'theme': 'light'});
    });
  });

  group('TableSettings.save', () {
    test('persists every entry in the given map', () async {
      await TableSettings.save({'theme': 'dark', 'shuffle': 'true'});

      expect(await TableSettings.selectAll(), {'theme': 'dark', 'shuffle': 'true'});
    });

    test('replaces the entire settings table rather than merging', () async {
      await TableSettings.save({'theme': 'dark'});
      await TableSettings.save({'shuffle': 'true'});

      expect(await TableSettings.selectAll(), {'shuffle': 'true'});
    });

    test('supports a null value for a key', () async {
      await TableSettings.save({'theme': null});

      expect(await TableSettings.selectAll(), {'theme': null});
    });

    test('clears existing settings when given an empty map', () async {
      await TableSettings.persist('theme', 'dark');

      await TableSettings.save({});

      expect(await TableSettings.selectAll(), isEmpty);
    });
  });
}
