abstract class DictStorageService {
  Future<bool> delete(String key);

  Future<T?> get<T>(String key);

  Future<void> save<T>(String key, T value);
}
