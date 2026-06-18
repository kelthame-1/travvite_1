import '../modeles/ouvrier_model.dart';
import '../services/ouvrier_service.dart';
import '../../core/constantes/app_constantes.dart';

class OuvrierRepository {

  // ===== TOUS LES OUVRIERS =====
  Future<List<OuvrierModel>> getTousOuvriers({
    int page = 0,
    int size = AppConstants.itemsPerPage,
  }) async {
    try {
      return await OuvrierService.getTousOuvriers(
        page: page,
        size: size,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== PLUS NOTES =====
  Future<List<OuvrierModel>> getPlusNotes({int limit = 10}) async {
    try {
      return await OuvrierService.getPlusNotes(limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  // ===== PAR ID =====
  Future<OuvrierModel> getById(int id) async {
    try {
      return await OuvrierService.getById(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== FILTRER =====
  Future<List<OuvrierModel>> filtrer({
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
      return await OuvrierService.filtrer(
        nom: nom,
        categorie: categorie,
        genre: genre,
        langue: langue,
        disponibilite: disponibilite,
        accepteEnfants: accepteEnfants,
        niveauEtude: niveauEtude,
        nationalite: nationalite,
        prixMin: prixMin,
        prixMax: prixMax,
        page: page,
        size: size,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== CHANGER DISPONIBILITE =====
  Future<OuvrierModel> changerDisponibilite(
      int id,
      bool estDisponible,
      ) async {
    try {
      return await OuvrierService.changerDisponibilite(id, estDisponible);
    } catch (e) {
      rethrow;
    }
  }
}