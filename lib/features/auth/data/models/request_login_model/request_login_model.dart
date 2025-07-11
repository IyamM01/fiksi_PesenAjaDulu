import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_login_model.g.dart';

@JsonSerializable()
class RequestLoginModel extends Equatable {
  final String? email;
  final String? password;

  const RequestLoginModel({this.email, this.password});

  factory RequestLoginModel.fromJson(Map<String, dynamic> json) {
    return _$RequestLoginModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RequestLoginModelToJson(this);

  RequestLoginModel copyWith({String? email, String? password}) {
    return RequestLoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}
