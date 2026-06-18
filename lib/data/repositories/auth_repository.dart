import '../modeles/user_model.dart';
import '../services/auth_service.dart';


class AuthRepository {

  // ===== INSCRIPTION CLIENT =====
  Future<UserModel> inscrireClient({
    required String telephone,
    required String password,
    required String nom,
    required String prenom,
    required String ville,
  }) async {
    try {
      return await AuthService.inscrireClient(
        telephone: telephone,
        password: password,
        nom: nom,
        prenom: prenom,
        ville: ville,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== INSCRIPTION OUVRIER ETAPE 1 =====
  Future<UserModel> inscrireOuvrierEtape1({
    required String telephone,
    required String password,
    required String nom,
    required String prenom,
    required String ville,
  }) async {
    try {
      return await AuthService.inscrireOuvrierEtape1(
        telephone: telephone,
        password: password,
        nom: nom,
        prenom: prenom,
        ville: ville,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== INSCRIPTION OUVRIER ETAPE 2 =====
  Future<void> inscrireOuvrierEtape2({
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
      return await AuthService.inscrireOuvrierEtape2(
        id: id,
        categorie: categorie,
        genre: genre,
        langue: langue,
        disponibilite: disponibilite,
        accepteEnfants: accepteEnfants,
        niveauEtude: niveauEtude,
        nationalite: nationalite,
        prixJournalier: prixJournalier,
        prixMensuel: prixMensuel,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== LOGIN =====
  Future<UserModel> login({
    required String telephone,
    required String password,
  }) async {
    try {
      return await AuthService.login(
        telephone: telephone,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== LOGOUT =====
  Future<void> logout() async {
    try {
      await AuthService.logout();
    } catch (e) {
      rethrow;
    }
  }
}