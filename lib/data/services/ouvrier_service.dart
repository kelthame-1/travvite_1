import 'package:travvite_1/Core/errors/exceptions.dart';
import '../modeles/ouvrier_model.dart';
import '../../core/constantes/api_constantes.dart';
import '../../core/constantes/app_constantes.dart';
import 'api_service.dart';
import 'session_manager.dart';

class OuvrierService {

  // ===== HELPERS =====
  static Future<String> _getToken() async {
    final token = await SessionManager.getToken();
    if (token == null || token.isEmpty) {
      throw const SessionException('Session expirée');
    }
    return token;
  }

  static List<OuvrierModel> _parseList(dynamic response) {
    if (response is! List) {
      throw const ServerException('Réponse invalide du serveur');
    }
    return response.map((e) => OuvrierModel.fromJson(e)).toList();
  }

  static Exception _handleError(dynamic e) {
    if (e is SessionException) return e;
    if (e is NetworkException) return e;
    if (e is NetworkTimeoutException) return e;
    if (e is ServerException) return e;
    return ServerException(e.toString());
  }

  // ===== TOUS LES OUVRIERS (avec pagination) =====
  static Future<List<OuvrierModel>> getTousOuvriers({
    int page = 0,
    int size = AppConstants.itemsPerPage,
  }) async {
    try {
      final token = await _getToken();

      final uri = Uri.parse(ApiConstantes.ouvriers).replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      );

      final response = await ApiService.get(uri.toString(), token: token);

      // Backend يرجع Page object أو List
      if (response is Map && response.containsKey('content')) {
        return _parseList(response['content']);
      }
      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== PLUS NOTES =====
  static Future<List<OuvrierModel>> getPlusNotes({
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();

      final uri = Uri.parse(ApiConstantes.ouvriersPlusNotes).replace(
        queryParameters: {'limit': limit.toString()},
      );

      final response = await ApiService.get(uri.toString(), token: token);
      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== PAR ID =====
  static Future<OuvrierModel> getById(int id) async {
    if (id <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();
      final response = await ApiService.get(
        '${ApiConstantes.ouvriers}/$id',
        token: token,
      );
      return OuvrierModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== FILTRER (avec pagination) =====
  static Future<List<OuvrierModel>> filtrer({
    String? nom,
    String? categorie,
    String? genre,
    String? langue,
    String? disponibilite,
    bool? accepteEnfants,
    String? niveauEtude,
    String? nationalite,
    double? prixMin,
    double? prixMax,
    int page = 0,
    int size = AppConstants.itemsPerPage,
  }) async {
    try {
      final token = await _getToken();

      final uri = Uri.parse(ApiConstantes.ouvriersFilter).replace(
        queryParameters: <String, String>{
          'page': page.toString(),
          'size': size.toString(),
          if (nom != null) 'nom': nom,
          if (categorie != null) 'categorie': categorie,
          if (genre != null) 'genre': genre,
          if (langue != null) 'langue': langue,
          if (disponibilite != null) 'disponibilite': disponibilite,
          if (accepteEnfants != null) 'accepteEnfants': accepteEnfants.toString(),
          if (nationalite != null) 'nationalite': nationalite,
          if (niveauEtude != null) 'niveauEtude': niveauEtude,
          if (prixMin != null) 'prixMin': prixMin.toString(),
          if (prixMax != null) 'prixMax': prixMax.toString(),
        },
      );

      final response = await ApiService.get(uri.toString(), token: token);

      if (response is Map && response.containsKey('content')) {
        return _parseList(response['content']);
      }
      return _parseList(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== CHANGER DISPONIBILITE =====
  static Future<OuvrierModel> changerDisponibilite(
      int id,
      bool estDisponible,
      ) async {
    if (id <= 0) throw const ServerException('ID invalide');
    try {
      final token = await _getToken();
      final response = await ApiService.patch(
        '${ApiConstantes.ouvriers}/$id/disponibilite',
        {'estDisponible': estDisponible},
        token: token,
      );
      return OuvrierModel.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
}
