part of hive;

/// Extend `HiveObject` to add useful methods to the objects you want to store
/// in Hive
abstract class HiveObject {
  BoxBase _box;

  /// Get the box in which this object is stored. Returns `null` if object has
  /// not been added to a box yet.
  BoxBase get box => _box;

  dynamic _key;

  /// Get the key associated with this object. Returns `null` if object has
  /// not been added to a box yet.
  dynamic get key => _key;

  void _requireInitialized() {
    if (_box == null) {
      throw HiveError('This object is currently not in a box.');
    }
  }

  /// Persists this object.
  Future<void> save() {
    _requireInitialized();
    return _box.put(_key, this);
  }

  /// Deletes this object from the box it is stored in.
  Future<void> delete() {
    _requireInitialized();
    return _box.delete(_key);
  }

  /// Returns whether this object is currently stored in a box.
  ///
  /// For lazy boxes this only checks if the key exists in the box and NOT
  /// whether this instance is actually stored in the box.
  bool get isInBox {
    if (_box != null) {
      if (_box.lazy) {
        return _box.containsKey(_key);
      } else {
        return true;
      }
    }
    return false;
  }

  @protected
  void init(dynamic key, BoxBase box) {
    if (_box != null) {
      if (_box != box) {
        throw HiveError('The same instance of an HiveObject cannot '
            'be stored in two different boxes.');
      } else if (_key != key) {
        throw HiveError('The same instance of an HiveObject cannot '
            'be stored with two different keys.');
      }
    }
    _box = box;
    _key = key;
  }

  @protected
  void unload() {
    _box = null;
    _key = null;
  }
}
