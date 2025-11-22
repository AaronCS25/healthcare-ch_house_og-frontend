import 'package:shared_preferences/shared_preferences.dart';
import 'package:rimac_app/features/shared/shared.dart';

class DictStorageServiceImpl implements DictStorageService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool> delete(String key) async {
    final prefs = await getSharedPreferences();
    return await prefs.remove(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    final prefs = await getSharedPreferences();

    if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == String) {
      return prefs.getString(key) as T?;
    } else {
      throw UnsupportedError('Type $T is not supported for retrieval');
    }
  }

  @override
  Future<void> save<T>(String key, T value) async {
    final prefs = await getSharedPreferences();

    switch (value) {
      case int value:
        prefs.setInt(key, value);
        break;

      case String value:
        prefs.setString(key, value);
        break;

      default:
        throw UnsupportedError('Type $T is not supported for saving');
    }
  }
}
