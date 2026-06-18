import '../modeles/evaluation_model.dart';
import '../services/evaluation_service.dart';

class EvaluationRepository {

  // ===== CREER EVALUATION =====
  Future<EvaluationModel> creerEvaluation({
    required int reservationId,
    required int ouvrierId,
    required int note,
    String? commentaire,
    String? tags,
  }) async {
    try {
      return await EvaluationService.creerEvaluation(
        reservationId: reservationId,
        ouvrierId: ouvrierId,
        note: note,
        commentaire: commentaire,
        tags: tags,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ===== GET BY OUVRIER =====
  Future<List<EvaluationModel>> getByOuvrier(int ouvrierId) async {
    try {
      return await EvaluationService.getByOuvrier(ouvrierId);
    } catch (e) {
      rethrow;
    }
  }

  // ===== GET BY CLIENT =====
  Future<List<EvaluationModel>> getByClient(int clientId) async {
    try {
      return await EvaluationService.getByClient(clientId);
    } catch (e) {
      rethrow;
    }
  }

  // ===== GET BY RESERVATION =====
  Future<EvaluationModel?> getByReservation(int reservationId) async {
    try {
      return await EvaluationService.getByReservation(reservationId);
    } catch (e) {
      rethrow;
    }
  }

  // ===== DEJA EVALUE =====
  Future<bool> dejaEvalue(int reservationId) async {
    try {
      return await EvaluationService.dejaEvalue(reservationId);
    } catch (e) {
      rethrow;
    }
  }
}