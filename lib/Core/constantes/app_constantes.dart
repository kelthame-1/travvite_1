import 'package:flutter/material.dart';

class AppConstants {
  // ===== COULEURS =====
  static const Color primaryColor = Color(0xFF2B4C7E);
  static const Color secondaryColor = Color(0xFF1E3A5F);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color greyColor = Color(0xFF9AA5B4);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // ===== DIMENSIONS =====
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 16.0;
  static const double borderRadiusLarge = 22.0;

  // ===== API =====
  static const int timeoutSeconds = 15;
  static const int itemsPerPage = 20;

  // ===== CATEGORIES =====
  static const Map<String, String> categories = {
    'KHADIMA': 'خادمة / Femme de ménage',
    'MARBIYA': 'مربية / Garde d\'enfants',
    'TABBAKHA': 'طباخة / Cuisinière',
    'NAJJAR': 'نجار / Menuisier',
    'KAHRABAI': 'كهربائي / Électricien',
    'SABBAK': 'سباك / Plombier',
    'DAHAN': 'دهان / Peintre',
    'TANDHIF': 'تنظيف / Nettoyage',
    'HADDAD': 'حداد / Forgeron',
    'SAIQ': 'سائق / Chauffeur',
    'HARIS': 'حارس / Gardien',
  };

  // ===== GENRE =====
  static const Map<String, String> genres = {
    'HOMME': 'ذكر / Homme',
    'FEMME': 'أنثى / Femme',
  };

  // ===== LANGUE =====
  static const Map<String, String> langues = {
    'AR': 'عربي',
    'FR': 'Français',
    'AR_FR': 'عربي + Français',
  };

  // ===== DISPONIBILITE =====
  static const Map<String, String> disponibilites = {
    'TEMPS_PLEIN': 'يوم كامل / Temps plein',
    'TEMPS_PARTIEL': 'نصف يوم / Temps partiel',
  };

  // ===== NIVEAU ETUDE =====
  static const Map<String, String> niveauxEtude = {
    'SANS': 'بدون / Sans',
    'PRIMAIRE': 'ابتدائي / Primaire',
    'SECONDAIRE': 'ثانوي / Secondaire',
    'SUPERIEUR': 'جامعي / Supérieur',
  };

  // ===== NATIONALITE =====
  static const Map<String, String> nationalites = {
    'MAURITANIENNE': 'موريتاني / Mauritanien',
    'SENEGALAISE': 'سنغالي / Sénégalais',
    'MALIENNE': 'مالي / Malien',
    'AUTRE': 'أخرى / Autre',
  };

  // ===== TYPE PRIX =====
  static const Map<String, String> typesPrix = {
    'JOURNALIER': 'يومي / Par jour',
    'MENSUEL': 'شهري / Par mois',
  };

  // ===== STATUT RESERVATION =====
  static const Map<String, String> statutsReservation = {
    'EN_ATTENTE': 'بانتظار / En attente',
    'ACCEPTE': 'مقبول / Accepté',
    'EN_COURS': 'جارية / En cours',
    'TERMINE': 'منتهية / Terminé',
    'REFUSE': 'مرفوض / Refusé',
    'ANNULE': 'ملغي / Annulé',
  };

  // ===== HELPERS TRADUCTION =====
  static String traduireCategorie(String key, {bool isAr = true}) {
    final val = categories[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }

  static String traduireGenre(String key, {bool isAr = true}) {
    final val = genres[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }

  static String traduireLangue(String key, {bool isAr = true}) {
    return langues[key] ?? key;
  }

  static String traduireDisponibilite(String key, {bool isAr = true}) {
    final val = disponibilites[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }

  static String traduireNiveauEtude(String key, {bool isAr = true}) {
    final val = niveauxEtude[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }

  static String traduireNationalite(String key, {bool isAr = true}) {
    final val = nationalites[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }

  static String traduireStatutReservation(String key, {bool isAr = true}) {
    final val = statutsReservation[key];
    if (val == null) return key;
    final parts = val.split('/');
    return isAr ? parts[0].trim() : (parts.length > 1 ? parts[1].trim() : parts[0].trim());
  }
}