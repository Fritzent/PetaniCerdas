import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  Future<String> getUserData() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? value = await secureStorage.read(key: 'login_user');
    return value ?? '';
  }
}
