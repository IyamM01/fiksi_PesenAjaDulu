import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table.g.dart';

@JsonSerializable()
class Table extends Equatable {
  final int? id;
  final String? number;
  final int? seats;

  const Table({this.id, this.number, this.seats});

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  Map<String, dynamic> toJson() => _$TableToJson(this);

  Table copyWith({int? id, String? number, int? seats}) {
    return Table(
      id: id ?? this.id,
      number: number ?? this.number,
      seats: seats ?? this.seats,
    );
  }

  @override
  List<Object?> get props => [id, number, seats];
}
