import '../modeles/reservation_model.dart';
import '../services/reservation_service.dart';

class ReservationRepository {

  // ===== CREER RESERVATION =====
  Future<ReservationModel> creerReservation({
    required int ouvrierId,
    required String description,
    required DateTime dateService,
    required String heureService,
    required int nbHeures,
    required String adresse,
  }) async {
    try {
      return await ReservationService.creerReservation(
        ouvrierId: ouvrierId,
        description: description,
        dateService: dateService,
        heureService: heureService,
        nbHeures: nbHeures,
        adresse: adresse,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== MES RESERVATIONS CLIENT =====
  Future<List<ReservationModel>> getMesReservationsClient() async {
    try {
      return await ReservationService.getMesReservationsClient();
    } catch (e) {
      rethrow;
    }
  }

  // ===== MES RESERVATIONS OUVRIER =====
  Future<List<ReservationModel>> getMesReservationsOuvrier() async {
    try {
      return await ReservationService.getMesReservationsOuvrier();
    } catch (e) {
      rethrow;
    }
  }

  // ===== GET BY ID =====
  Future<ReservationModel> getById(int id) async {
    try {
      return await ReservationService.getById(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== ACCEPTER =====
  Future<ReservationModel> accepter(int id) async {
    try {
      return await ReservationService.accepter(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== REFUSER =====
  Future<ReservationModel> refuser(int id) async {
    try {
      return await ReservationService.refuser(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== TERMINER =====
  Future<ReservationModel> terminer(int id) async {
    try {
      return await ReservationService.terminer(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== ANNULER =====
  Future<ReservationModel> annuler(int id) async {
    try {
      return await ReservationService.annuler(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== CHANGER STATUT =====
  Future<ReservationModel> changerStatut(
      int id,
      StatutReservation statut,
      ) async {
    try {
      return await ReservationService.changerStatut(id, statut);
    } catch (e) {
      rethrow;
    }
  }
}