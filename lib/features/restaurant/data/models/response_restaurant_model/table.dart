import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table.g.dart';

@JsonSerializable()
class Table extends Equatable {
  final int? id;
  @JsonKey(name: 'restaurant_id')
  final int? restaurantId;
  final String? status;
  final int? capacity;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const Table({
    this.id,
    this.restaurantId,
    this.status,
    this.capacity,
    this.createdAt,
    this.updatedAt,
  });

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  Map<String, dynamic> toJson() => _$TableToJson(this);

  Table copyWith({
    int? id,
    int? restaurantId,
    String? status,
    int? capacity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Table(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      status: status ?? this.status,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props {
    return [id, restaurantId, status, capacity, createdAt, updatedAt];
  }
}
