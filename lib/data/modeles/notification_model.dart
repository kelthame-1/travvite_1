import 'package:equatable/equatable.dart';

enum TypeNotification {
  NOUVELLE_COMMANDE,
  COMMANDE_ACCEPTEE,
  SERVICE_TERMINE;

  static TypeNotification fromString(String value) {
    return TypeNotification.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TypeNotification.NOUVELLE_COMMANDE,
    );
  }
}

class NotificationModel extends Equatable {
  final int id;
  final int userId;
  final String titre;
  final String corps;
  final TypeNotification type;
  final bool lu;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.titre,
    required this.corps,
    required this.type,
    required this.lu,
    required this.createdAt,
  });

  // ===== HELPERS =====
  bool get isUnread => !lu;
  bool get isNewCommande => type == TypeNotification.NOUVELLE_COMMANDE;
  bool get isAccepted => type == TypeNotification.COMMANDE_ACCEPTEE;
  bool get isFinished => type == TypeNotification.SERVICE_TERMINE;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user']?['id'] as num?)?.toInt() ?? 0,
      titre: json['titre'] ?? '',
      corps: json['corps'] ?? '',
      type: TypeNotification.fromString(json['type'] ?? ''),
      lu: json['lu'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'titre': titre,
    'corps': corps,
    'type': type.name,
    'lu': lu,
    'createdAt': createdAt.toIso8601String(),
  };

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? titre,
    String? corps,
    TypeNotification? type,
    bool? lu,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      titre: titre ?? this.titre,
      corps: corps ?? this.corps,
      type: type ?? this.type,
      lu: lu ?? this.lu,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, titre, corps, type, lu, createdAt];
}