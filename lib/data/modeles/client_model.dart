import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String ville;
  final String? photoUrl;

  const ClientModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.ville,
    this.photoUrl,
  });

  // ===== HELPERS =====
  String get nomComplet => '$nom $prenom';

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      ville: json['ville'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'ville': ville,
    'photoUrl': photoUrl,
  };

  ClientModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? ville,
    String? photoUrl,
  }) {
    return ClientModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      ville: ville ?? this.ville,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, nom, prenom, telephone, ville, photoUrl];
}