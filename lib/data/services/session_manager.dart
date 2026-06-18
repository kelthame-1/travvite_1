import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../modeles/user_model.dart';
import 'storage_keys.dart';

class SessionManager {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ===== CACHE =====
  static UserModel? _cachedUser;
  static String? _cachedToken;

  // ===== SAUVEGARDER =====
  static Future<void> sauvegarder(UserModel user, String token) async {
    try {
      final data = {
        StorageKeys.token: token,
        StorageKeys.role: user.role,
        StorageKeys.id: user.id.toString(),
        StorageKeys.nom: user.nom,
        StorageKeys.prenom: user.prenom,
        StorageKeys.telephone: user.telephone,
        StorageKeys.ville: user.ville, // 🆕
      };

      await Future.wait(
        data.entries.map((e) => _storage.write(key: e.key, value: e.value)),
      );

      _cachedUser = user;
      _cachedToken = token;
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de la session');
    }
  }

  // ===== SAVE FCM TOKEN =====
  static Future<void> saveFcmToken(String fcmToken) async { // 🆕
    try {
      await _storage.write(key: StorageKeys.fcmToken, value: fcmToken);
    } catch (_) {}
  }

  // ===== GET FCM TOKEN =====
  static Future<String?> getFcmToken() async { // 🆕
    try {
      return await _storage.read(key: StorageKeys.fcmToken);
    } catch (_) {
      return null;
    }
  }

  // ===== GET TOKEN =====
  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    try {
      _cachedToken = await _storage.read(key: StorageKeys.token);
      return _cachedToken;
    } catch (_) {
      return null;
    }
  }

  // ===== GET ROLE =====
  static Future<String?> getRole() async {
    if (_cachedUser != null) return _cachedUser!.role;
    try {
      return await _storage.read(key: StorageKeys.role);
    } catch (_) {
      return null;
    }
  }

  // ===== GET ID =====
  static Future<int> getId() async {
    if (_cachedUser != null) return _cachedUser!.id;
    try {
      final id = await _storage.read(key: StorageKeys.id);
      return int.tryParse(id ?? '0') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  // ===== GET USER =====
  static Future<UserModel?> getUser() async {
    if (_cachedUser != null) return _cachedUser;
    try {
      final values = await Future.wait([
        _storage.read(key: StorageKeys.id),
        _storage.read(key: StorageKeys.nom),
        _storage.read(key: StorageKeys.prenom),
        _storage.read(key: StorageKeys.telephone),
        _storage.read(key: StorageKeys.role),
        _storage.read(key: StorageKeys.ville), // 🆕
      ]);

      if (values[0] == null) return null;

      _cachedUser = UserModel(
        id: int.tryParse(values[0]!) ?? 0,
        nom: values[1] ?? '',
        prenom: values[2] ?? '',
        telephone: values[3] ?? '',
        role: values[4] ?? '',
        ville: values[5] ?? '', // 🆕
      );

      return _cachedUser;
    } catch (_) {
      return null;
    }
  }

  // ===== EST CONNECTE =====
  static Future<bool> estConnecte() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ===== LOGOUT =====
  static Future<void> logout() async {
    try {
      await _storage.deleteAll(); // 🆕 أسرع من حذف واحد واحد
      _cachedUser = null;
      _cachedToken = null;
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion');
    }
  }

  // ===== CLEAR CACHE =====
  static void clearCache() {
    _cachedUser = null;
    _cachedToken = null;
  }
}
