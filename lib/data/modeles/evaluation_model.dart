import 'package:equatable/equatable.dart';

class EvaluationModel extends Equatable {
  final int id;
  final int reservationId;
  final int clientId;
  final String clientNom;
  final int ouvrierId;
  final int note;
  final String? tags;
  final String? commentaire;
  final DateTime createdAt;

  const EvaluationModel({
    required this.id,
    required this.reservationId,
    required this.clientId,
    required this.clientNom,
    required this.ouvrierId,
    required this.note,
    this.tags,
    this.commentaire,
    required this.createdAt,
  });

  // ===== HELPERS =====
  bool get isPositive => note >= 4;
  bool get isNegative => note <= 2;
  List<String> get tagsList =>
      tags != null && tags!.isNotEmpty ? tags!.split(',') : [];

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      reservationId: (json['reservation']?['id'] as num?)?.toInt() ?? 0,
      clientId: (json['client']?['id'] as num?)?.toInt() ?? 0,
      clientNom: json['client']?['nom'] ?? '',
      ouvrierId: (json['ouvrier']?['id'] as num?)?.toInt() ?? 0,
      note: (json['note'] as num?)?.toInt() ?? 0,
      tags: json['tags'],
      commentaire: json['commentaire'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'reservationId': reservationId,
    'clientId': clientId,
    'ouvrierId': ouvrierId,
    'note': note,
    'tags': tags,
    'commentaire': commentaire,
    'createdAt': createdAt.toIso8601String(),
  };

  EvaluationModel copyWith({
    int? id,
    int? reservationId,
    int? clientId,
    String? clientNom,
    int? ouvrierId,
    int? note,
    String? tags,
    String? commentaire,
    DateTime? createdAt,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      clientId: clientId ?? this.clientId,
      clientNom: clientNom ?? this.clientNom,
      ouvrierId: ouvrierId ?? this.ouvrierId,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      commentaire: commentaire ?? this.commentaire,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id, reservationId, clientId, clientNom,
    ouvrierId, note, tags, commentaire, createdAt,
  ];
}