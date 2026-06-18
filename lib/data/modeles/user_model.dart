import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String role;
  final String ville;
  String get nomComplet => '$nom $prenom';

  const UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.role,
    required this.ville,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      role: json['role'] ?? '',
      ville: json['ville'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'role': role,
    'ville': ville,
  };

  UserModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? role,
    String? ville,
  }) {
    return UserModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      role: role ?? this.role,
      ville: ville ?? this.ville,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nom: $nom, prenom: $prenom, telephone: $telephone, role: $role, ville: $ville)';
  }

  @override
  List<Object?> get props => [id, nom, prenom, telephone, role, ville];
}