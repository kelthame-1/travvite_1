import '../modeles/evaluation_model.dart';
import '../../core/constantes/api_constantes.dart';
import '../../core/errors/exceptions.dart';
import 'api_service.dart';
import 'session_manager.dart';

class EvaluationService {

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

  static List<EvaluationModel> _parseList(dynamic response) {
    if (response is! List) {
      throw const ServerException('Réponse invalide du serveur');
    }
    return response.map((e) => EvaluationModel.fromJson(e)).toList();
  }

  // ===== CREER EVALUATION =====
  static Future<EvaluationModel> creerEvaluation({
    required int reservationId,
    required int ouvrierId,
    required int note,
    String? commentaire,
    String? tags,
  }) async {
    if (note < 1 || note > 5) {
      throw const ValidationException('Note doit être entre 1 et 5');
    }
    try {
      final token = await _getToken();
      final clientId = await SessionManager.getId();

      final response = await ApiService.post(
        ApiConstantes.evaluations,
        {
          'reservationId': reservationId,
          'clientId': clientId,
          'ouvrierId': ouvrierId,
          'note': note,
          if (commentaire != null) 'commentaire': commentaire,
          if (tags != null) 'tags': tags,
        },
        token: token,
      );

      return EvaluationModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== GET EVALUATIONS PAR OUVRIER =====
  static Future<List<EvaluationModel>> getByOuvrier(int ouvrierId) async {
    if (ouvrierId <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      final response = await ApiService.get(
        '${ApiConstantes.evaluations}/ouvrier/$ouvrierId',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== GET EVALUATIONS PAR CLIENT =====
  static Future<List<EvaluationModel>> getByClient(int clientId) async {
    if (clientId <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      final response = await ApiService.get(
        '${ApiConstantes.evaluations}/client/$clientId',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== GET BY RESERVATION =====
  static Future<EvaluationModel?> getByReservation(int reservationId) async {
    if (reservationId <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      final response = await ApiService.get(
        '${ApiConstantes.evaluations}/reservation/$reservationId',
        token: token,
      );

      return EvaluationModel.fromJson(response);
    } catch (e) {
      if (e is NotFoundException) return null;
      throw _handleError(e);
    }
  }

  // ===== DEJA EVALUE =====
  static Future<bool> dejaEvalue(int reservationId) async {
    final eval = await getByReservation(reservationId);
    return eval != null;
  }
}