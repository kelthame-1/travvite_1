import 'package:equatable/equatable.dart';

// ===== ENUM STATUT =====
enum StatutReservation {
  EN_ATTENTE,
  ACCEPTE,
  EN_COURS,
  TERMINE,
  REFUSE,
  ANNULE;

  static StatutReservation fromString(String value) {
    return StatutReservation.values.firstWhere(
          (e) => e.name == value,
      orElse: () => StatutReservation.EN_ATTENTE,
    );
  }
}

// ===== RESERVATION MODEL =====
class ReservationModel extends Equatable {
  final int id;
  final int clientId;
  final String clientNom;
  final int ouvrierId;
  final String ouvrierNom;
  final String description;
  final DateTime dateService;
  final String heureService;
  final int nbHeures;
  final String adresse;
  final double prixTotal;
  final StatutReservation statut;
  final DateTime createdAt;

  const ReservationModel({
    required this.id,
    required this.clientId,
    required this.clientNom,
    required this.ouvrierId,
    required this.ouvrierNom,
    required this.description,
    required this.dateService,
    required this.heureService,
    required this.nbHeures,
    required this.adresse,
    required this.prixTotal,
    required this.statut,
    required this.createdAt,
  });

  // ===== HELPERS =====
  bool get isPending => statut == StatutReservation.EN_ATTENTE;
  bool get isAccepted => statut == StatutReservation.ACCEPTE;
  bool get isInProgress => statut == StatutReservation.EN_COURS;
  bool get isFinished => statut == StatutReservation.TERMINE;
  bool get isRefused => statut == StatutReservation.REFUSE;
  bool get isCancelled => statut == StatutReservation.ANNULE;

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      clientId: (json['client']?['id'] as num?)?.toInt() ?? 0,
      clientNom: json['client']?['nom'] ?? '',
      ouvrierId: (json['ouvrier']?['id'] as num?)?.toInt() ?? 0,
      ouvrierNom: json['ouvrier']?['nom'] ?? '',
      description: json['description'] ?? '',
      dateService: DateTime.parse(json['dateService']),
      heureService: json['heureService'] ?? '',
      nbHeures: (json['nbHeures'] as num?)?.toInt() ?? 0,
      adresse: json['adresse'] ?? '',
      prixTotal: (json['prixTotal'] as num?)?.toDouble() ?? 0.0,
      statut: StatutReservation.fromString(json['statut'] ?? 'EN_ATTENTE'),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientId': clientId,
    'ouvrierId': ouvrierId,
    'description': description,
    'dateService': dateService.toIso8601String().split('T')[0],
    'heureService': heureService,
    'nbHeures': nbHeures,
    'adresse': adresse,
    'prixTotal': prixTotal,
    'statut': statut.name,
    'createdAt': createdAt.toIso8601String(),
  };

  ReservationModel copyWith({
    int? id,
    int? clientId,
    String? clientNom,
    int? ouvrierId,
    String? ouvrierNom,
    String? description,
    DateTime? dateService,
    String? heureService,
    int? nbHeures,
    String? adresse,
    double? prixTotal,
    StatutReservation? statut,
    DateTime? createdAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientNom: clientNom ?? this.clientNom,
      ouvrierId: ouvrierId ?? this.ouvrierId,
      ouvrierNom: ouvrierNom ?? this.ouvrierNom,
      description: description ?? this.description,
      dateService: dateService ?? this.dateService,
      heureService: heureService ?? this.heureService,
      nbHeures: nbHeures ?? this.nbHeures,
      adresse: adresse ?? this.adresse,
      prixTotal: prixTotal ?? this.prixTotal,
      statut: statut ?? this.statut,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, clientId, clientNom, ouvrierId, ouvrierNom,
    description, dateService, heureService, nbHeures,
    adresse, prixTotal, statut, createdAt,
  ];
}