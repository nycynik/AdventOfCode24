import 'dart:collection';

class LRUCache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _cache;

  LRUCache(this.capacity) : _cache = LinkedHashMap();

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    // Move to end (most recently used)
    final value = _cache.remove(key)!;
    _cache[key] = value;
    return value;
  }

  bool has(K key) {
    return _cache.containsKey(key);
  }

  void set(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first); // Remove least recently used
    }
    _cache[key] = value;
  }
}
