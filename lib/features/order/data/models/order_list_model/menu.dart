import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu extends Equatable {
  final int? id;
  final String? name;
  final int? price;

  const Menu({this.id, this.name, this.price});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  Menu copyWith({int? id, String? name, int? price}) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
