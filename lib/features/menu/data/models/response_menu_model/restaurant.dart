import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant extends Equatable {
  final int? id;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? description;
  final String? logo;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const Restaurant({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.description,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return _$RestaurantFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  Restaurant copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? description,
    String? logo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      address,
      phone,
      email,
      description,
      logo,
      createdAt,
      updatedAt,
    ];
  }
}
