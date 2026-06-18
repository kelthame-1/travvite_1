import '../modeles/reservation_model.dart';
import '../../core/constantes/api_constantes.dart';
import '../../core/errors/exceptions.dart';
import 'api_service.dart';
import 'session_manager.dart';

class ReservationService {

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

  static List<ReservationModel> _parseList(dynamic response) {
    if (response is! List) {
      throw const ServerException('Réponse invalide du serveur');
    }
    return response.map((e) => ReservationModel.fromJson(e)).toList();
  }

  // ===== CREER RESERVATION =====
  static Future<ReservationModel> creerReservation({
    required int ouvrierId,
    required String description,
    required DateTime dateService,
    required String heureService,
    required int nbHeures,
    required String adresse,
  }) async {
    try {
      final token = await _getToken();
      final clientId = await SessionManager.getId();

      final response = await ApiService.post(
        ApiConstantes.reservations,
        {
          'clientId': clientId,
          'ouvrierId': ouvrierId,
          'description': description,
          'dateService': dateService.toIso8601String().split('T')[0],
          'heureService': heureService,
          'nbHeures': nbHeures,
          'adresse': adresse,
        },
        token: token,
      );

      return ReservationModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== MES RESERVATIONS (CLIENT) =====
  static Future<List<ReservationModel>> getMesReservationsClient() async {
    try {
      final token = await _getToken();
      final clientId = await SessionManager.getId();

      final response = await ApiService.get(
        '${ApiConstantes.reservations}/client/$clientId',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== MES RESERVATIONS (OUVRIER) =====
  static Future<List<ReservationModel>> getMesReservationsOuvrier() async {
    try {
      final token = await _getToken();
      final ouvrierId = await SessionManager.getId();

      final response = await ApiService.get(
        '${ApiConstantes.reservations}/ouvrier/$ouvrierId',
        token: token,
      );

      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== GET BY ID =====
  static Future<ReservationModel> getById(int id) async {
    if (id <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      final response = await ApiService.get(
        '${ApiConstantes.reservations}/$id',
        token: token,
      );

      return ReservationModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== CHANGER STATUT =====
  static Future<ReservationModel> changerStatut(
      int id,
      StatutReservation statut,
      ) async {
    if (id <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();

      final response = await ApiService.patch(
        '${ApiConstantes.reservations}/$id/statut',
        {'statut': statut.name},
        token: token,
      );

      return ReservationModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== ACCEPTER =====
  static Future<ReservationModel> accepter(int id) async {
    return changerStatut(id, StatutReservation.ACCEPTE);
  }

  // ===== REFUSER =====
  static Future<ReservationModel> refuser(int id) async {
    return changerStatut(id, StatutReservation.REFUSE);
  }

  // ===== TERMINER =====
  static Future<ReservationModel> terminer(int id) async {
    return changerStatut(id, StatutReservation.TERMINE);
  }

  // ===== ANNULER =====
  static Future<ReservationModel> annuler(int id) async {
    return changerStatut(id, StatutReservation.ANNULE);
  }
}