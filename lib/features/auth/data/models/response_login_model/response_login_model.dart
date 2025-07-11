import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_login_model.g.dart';

@JsonSerializable()
class ResponseLoginModel extends Equatable {
  final String? token;

  const ResponseLoginModel({this.token});

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) {
    return _$ResponseLoginModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseLoginModelToJson(this);

  ResponseLoginModel copyWith({String? token}) {
    return ResponseLoginModel(token: token ?? this.token);
  }

  @override
  List<Object?> get props => [token];
}
