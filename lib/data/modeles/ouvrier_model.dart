import 'package:equatable/equatable.dart';

class OuvrierModel extends Equatable {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String ville;
  final String categorie;
  final String genre;
  final String langue;
  final String disponibilite;
  final bool accepteEnfants;
  final String niveauEtude;
  final String nationalite;
  final double prixJournalier;
  final double prixMensuel;
  final String? photoUrl;
  final double noteMoyenne;
  final int nombreAvis;
  final int tachesTerminees;
  final bool estDisponible;

  const OuvrierModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.ville,
    required this.categorie,
    required this.genre,
    required this.langue,
    required this.disponibilite,
    required this.accepteEnfants,
    required this.niveauEtude,
    required this.nationalite,
    required this.prixJournalier,
    required this.prixMensuel,
    this.photoUrl,
    this.noteMoyenne = 0.0,
    this.nombreAvis = 0,
    this.tachesTerminees = 0,
    this.estDisponible = true,
  });

  // ===== HELPERS =====
  bool get isAvailable => estDisponible;
  String get nomComplet => '$nom $prenom';
  String get prixDisplay => prixJournalier > 0
      ? '$prixJournalier MRU/jour'
      : '$prixMensuel MRU/mois';

  factory OuvrierModel.fromJson(Map<String, dynamic> json) {
    return OuvrierModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      ville: json['ville'] ?? '',
      categorie: json['categorie'] ?? '',
      genre: json['genre'] ?? '',
      langue: json['langue'] ?? '',
      disponibilite: json['disponibilite'] ?? '',
      accepteEnfants: json['accepteEnfants'] ?? false,
      niveauEtude: json['niveauEtude'] ?? '',
      nationalite: json['nationalite'] ?? '',
      prixJournalier: (json['prixJournalier'] as num?)?.toDouble() ?? 0.0,
      prixMensuel: (json['prixMensuel'] as num?)?.toDouble() ?? 0.0,
      photoUrl: json['photoUrl'],
      noteMoyenne: (json['noteMoyenne'] as num?)?.toDouble() ?? 0.0,
      nombreAvis: (json['nombreAvis'] as num?)?.toInt() ?? 0,
      tachesTerminees: (json['tachesTerminees'] as num?)?.toInt() ?? 0,
      estDisponible: json['estDisponible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'ville': ville,
    'categorie': categorie,
    'genre': genre,
    'langue': langue,
    'disponibilite': disponibilite,
    'accepteEnfants': accepteEnfants,
    'niveauEtude': niveauEtude,
    'nationalite': nationalite,
    'prixJournalier': prixJournalier,
    'prixMensuel': prixMensuel,
    'photoUrl': photoUrl,
    'noteMoyenne': noteMoyenne,
    'nombreAvis': nombreAvis,
    'tachesTerminees': tachesTerminees,
    'estDisponible': estDisponible,
  };

  OuvrierModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? ville,
    String? categorie,
    String? genre,
    String? langue,
    String? disponibilite,
    bool? accepteEnfants,
    String? niveauEtude,
    String? nationalite,
    double? prixJournalier,
    double? prixMensuel,
    String? photoUrl,
    double? noteMoyenne,
    int? nombreAvis,
    int? tachesTerminees,
    bool? estDisponible,
  }) {
    return OuvrierModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      ville: ville ?? this.ville,
      categorie: categorie ?? this.categorie,
      genre: genre ?? this.genre,
      langue: langue ?? this.langue,
      disponibilite: disponibilite ?? this.disponibilite,
      accepteEnfants: accepteEnfants ?? this.accepteEnfants,
      niveauEtude: niveauEtude ?? this.niveauEtude,
      nationalite: nationalite ?? this.nationalite,
      prixJournalier: prixJournalier ?? this.prixJournalier,
      prixMensuel: prixMensuel ?? this.prixMensuel,
      photoUrl: photoUrl ?? this.photoUrl,
      noteMoyenne: noteMoyenne ?? this.noteMoyenne,
      nombreAvis: nombreAvis ?? this.nombreAvis,
      tachesTerminees: tachesTerminees ?? this.tachesTerminees,
      estDisponible: estDisponible ?? this.estDisponible,
    );
  }

  @override
  List<Object?> get props => [
    id, nom, prenom, telephone, ville, categorie, genre,
    langue, disponibilite, accepteEnfants, niveauEtude,
    nationalite, prixJournalier, prixMensuel, photoUrl,
    noteMoyenne, nombreAvis, tachesTerminees, estDisponible,
  ];
}