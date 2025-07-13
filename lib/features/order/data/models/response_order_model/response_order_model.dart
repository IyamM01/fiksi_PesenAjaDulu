import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_order_model.g.dart';

@JsonSerializable()
class ResponseOrderModel extends Equatable {
  @JsonKey(name: 'snap_url')
  final String? snapUrl;

  const ResponseOrderModel({this.snapUrl});

  factory ResponseOrderModel.fromJson(Map<String, dynamic> json) {
    return _$ResponseOrderModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseOrderModelToJson(this);

  ResponseOrderModel copyWith({String? snapUrl}) {
    return ResponseOrderModel(snapUrl: snapUrl ?? this.snapUrl);
  }

  @override
  List<Object?> get props => [snapUrl];
}
