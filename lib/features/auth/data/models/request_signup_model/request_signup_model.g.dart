// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_signup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestSignupModel _$RequestSignupModelFromJson(Map<String, dynamic> json) =>
    RequestSignupModel(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$RequestSignupModelToJson(RequestSignupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
    };
