import 'package:dmus/core/data/DataEntity.dart';

final class MyDataEntityCache {
  MyDataEntityCache._();

  static Map<int, DataEntity> _cache = {};

  /// Gets an item from the cache
  static DataEntity? getFromCache(int id) {
    return _cache[id];
  }

  /// Adds an item to the cache
  static void putIntoCache(DataEntity entity) {
    if (_cache.containsKey(entity.id)) {
      return;
    }

    _cache.putIfAbsent(entity.id, () => entity);
  }

  /// Adds or updates the item in the cache
  static void updateCache(DataEntity entity) {
    if (!_cache.containsKey(entity.id)) {
      putIntoCache(entity);
      return;
    }

    _cache.remove(entity.id);
    _cache.putIfAbsent(entity.id, () => entity);
  }

  /// Deletes the item from the cache
  static void deleteFromCache(int id) {
    if (_cache.containsKey(id)) {
      _cache.remove(id);
    }
  }
}
