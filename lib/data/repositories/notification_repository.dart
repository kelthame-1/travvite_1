import '../modeles/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {

  // ===== GET MES NOTIFICATIONS =====
  Future<List<NotificationModel>> getMesNotifications() async {
    try {
      return await NotificationService.getMesNotifications();
    } catch (e) {
      rethrow;
    }
  }

  // ===== GET NON LUES =====
  Future<List<NotificationModel>> getNonLues() async {
    try {
      return await NotificationService.getNonLues();
    } catch (e) {
      rethrow;
    }
  }

  // ===== COMPTER NON LUES =====
  Future<int> compterNonLues() async {
    try {
      return await NotificationService.compterNonLues();
    } catch (e) {
      return 0;
    }
  }

  // ===== MARQUER COMME LUE =====
  Future<void> marquerCommeLue(int id) async {
    try {
      await NotificationService.marquerCommeLue(id);
    } catch (e) {
      rethrow;
    }
  }

  // ===== MARQUER TOUTES COMME LUES =====
  Future<void> marquerToutesCommeLues() async {
    try {
      await NotificationService.marquerToutesCommeLues();
    } catch (e) {
      rethrow;
    }
  }
}