import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'menu.dart';
import 'table.dart';

part 'response_restaurant_model.g.dart';

@JsonSerializable()
class ResponseRestaurantModel extends Equatable {
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
  final List<Menu>? menus;
  final List<Table>? tables;

  const ResponseRestaurantModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.description,
    this.logo,
    this.createdAt,
    this.updatedAt,
    this.menus,
    this.tables,
  });

  factory ResponseRestaurantModel.fromJson(Map<String, dynamic> json) {
    return _$ResponseRestaurantModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseRestaurantModelToJson(this);

  ResponseRestaurantModel copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? description,
    String? logo,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Menu>? menus,
    List<Table>? tables,
  }) {
    return ResponseRestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      menus: menus ?? this.menus,
      tables: tables ?? this.tables,
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
      menus,
      tables,
    ];
  }
}
