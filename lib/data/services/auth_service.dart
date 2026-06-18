import 'package:firebase_messaging/firebase_messaging.dart';
import '../modeles/user_model.dart';
import '../../core/constantes/api_constantes.dart';
import '../../core/errors/exceptions.dart';
import 'api_service.dart';
import 'session_manager.dart';

class AuthService {

  // ===== HANDLE ERROR =====
  static Exception _handleError(dynamic e) {
    if (e is SessionException) return e;
    if (e is NetworkException) return e;
    if (e is NetworkTimeoutException) return e;
    if (e is ServerException) return e;
    return ServerException(e.toString());
  }

  // ===== GET FCM TOKEN =====
  static Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  // ===== BASE REQUEST HANDLER =====
  static Future<UserModel> _handleAuthRequest(
      Future<Map<String, dynamic>> Function() request,
      ) async {
    try {
      final response = await request();

      final token = response['token'];
      if (token == null || token is! String || token.isEmpty) {
        throw const ServerException('Token invalide');
      }

      final user = UserModel.fromJson(response);
      await SessionManager.sauvegarder(user, token);

      // 🆕 حفظ FCM token
      final fcmToken = await _getFcmToken();
      if (fcmToken != null) {
        await SessionManager.saveFcmToken(fcmToken);
        await _sendFcmToken(fcmToken, token);
      }

      return user;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== SEND FCM TOKEN TO BACKEND =====
  static Future<void> _sendFcmToken(String fcmToken, String authToken) async {
    try {
      await ApiService.post(
        '${ApiConstantes.baseUrl}/auth/fcm-token',
        {'fcmToken': fcmToken},
        token: authToken,
      );
    } catch (_) {
      // مو critical — نتجاهل الخطأ
    }
  }

  // ===== INSCRIPTION CLIENT =====
  static Future<UserModel> inscrireClient({
    required String telephone,
    required String password,
    required String nom,
    required String prenom,
    required String ville,
  }) async {
    return _handleAuthRequest(() async {
      return await ApiService.post(
        ApiConstantes.inscriptionClient,
        {
          'telephone': telephone,
          'password': password,
          'nom': nom,
          'prenom': prenom,
          'ville': ville,
        },
      );
    });
  }

  // ===== INSCRIPTION OUVRIER ETAPE 1 =====
  static Future<UserModel> inscrireOuvrierEtape1({
    required String telephone,
    required String password,
    required String nom,
    required String prenom,
    required String ville,
  }) async {
    return _handleAuthRequest(() async {
      return await ApiService.post(
        ApiConstantes.inscriptionOuvrierEtape1,
        {
          'telephone': telephone,
          'password': password,
          'nom': nom,
          'prenom': prenom,
          'ville': ville,
        },
      );
    });
  }

  // ===== INSCRIPTION OUVRIER ETAPE 2 =====
  static Future<void> inscrireOuvrierEtape2({
    required int id,
    required String categorie,
    required String genre,
    required String langue,
    required String disponibilite,
    required bool accepteEnfants,
    required String niveauEtude,
    required String nationalite,
    required double prixJournalier,
    required double prixMensuel,
  }) async {
    try {
      final token = await SessionManager.getToken();
      if (token == null || token.isEmpty) {
        throw const SessionException('Session expirée');
      }

      await ApiService.put(
        ApiConstantes.inscriptionOuvrierEtape2,
        {
          'id': id,
          'categorie': categorie,
          'genre': genre,
          'langue': langue,
          'disponibilite': disponibilite,
          'accepteEnfants': accepteEnfants,
          'niveauEtude': niveauEtude,
          'nationalite': nationalite,
          'prixJournalier': prixJournalier,
          'prixMensuel': prixMensuel,
        },
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== LOGIN =====
  static Future<UserModel> login({
    required String telephone,
    required String password,
  }) async {
    return _handleAuthRequest(() async {
      return await ApiService.post(
        ApiConstantes.login,
        {
          'telephone': telephone,
          'password': password,
        },
      );
    });
  }

  // ===== LOGOUT =====
  static Future<void> logout() async { // 🆕
    try {
      final token = await SessionManager.getToken();
      if (token != null) {
        await ApiService.post(
          '${ApiConstantes.baseUrl}/auth/logout',
          {},
          token: token,
        );
      }
    } catch (_) {
      // نتجاهل خطأ الـ backend
    } finally {
      await SessionManager.logout();
    }
  }
}