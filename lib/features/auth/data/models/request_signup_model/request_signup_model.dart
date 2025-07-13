import 'package:json_annotation/json_annotation.dart';

part 'request_signup_model.g.dart';

@JsonSerializable()
class RequestSignupModel {
  final String name;
  final String email;
  final String password;
  final String phone;

  const RequestSignupModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory RequestSignupModel.fromJson(Map<String, dynamic> json) =>
      _$RequestSignupModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSignupModelToJson(this);
}
