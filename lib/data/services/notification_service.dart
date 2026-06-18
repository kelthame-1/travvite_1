import '../modeles/notification_model.dart';
import '../../core/constantes/api_constantes.dart';
import '../../core/errors/exceptions.dart';
import 'api_service.dart';
import 'session_manager.dart';

class NotificationService {

  // ===== HELPERS =====
  static Future<String> _getToken() async {
    final token = await SessionManager.getToken();
    if (token == null || token.isEmpty) {
      throw const SessionException('Session expirée');
    }
    return token;
  }

  static Exception _handleError(dynamic e) {
    if (e is SessionException) return e;
    if (e is NetworkException) return e;
    if (e is NetworkTimeoutException) return e;
    if (e is ServerException) return e;
    return ServerException(e.toString());
  }

  static List<NotificationModel> _parseList(dynamic response) {
    if (response is! List) {
      throw const ServerException('Réponse invalide du serveur');
    }
    return response.map((e) => NotificationModel.fromJson(e)).toList();
  }

  // ===== GET MES NOTIFICATIONS =====
  static Future<List<NotificationModel>> getMesNotifications() async {
    try {
      final token = await _getToken();
      final userId = await SessionManager.getId();

      final response = await ApiService.get(
        '${ApiConstantes.notifications}/user/$userId',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== GET NON LUES =====
  static Future<List<NotificationModel>> getNonLues() async {
    try {
      final token = await _getToken();
      final userId = await SessionManager.getId();

      final response = await ApiService.get(
        '${ApiConstantes.notifications}/user/$userId/non-lues',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== COMPTER NON LUES =====
  static Future<int> compterNonLues() async {
    try {
      final notifications = await getNonLues();
      return notifications.length;
    } catch (e) {
      return 0;
    }
  }

  // ===== MARQUER COMME LUE =====
  static Future<void> marquerCommeLue(int id) async {
    if (id <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      await ApiService.patch(
        '${ApiConstantes.notifications}/$id/lue',
        {},
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== MARQUER TOUTES COMME LUES =====
  static Future<void> marquerToutesCommeLues() async {
    try {
      final token = await _getToken();
      final userId = await SessionManager.getId();

      await ApiService.patch(
        '${ApiConstantes.notifications}/user/$userId/lues',
        {},
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
}