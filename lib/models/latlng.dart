import 'package:json_annotation/json_annotation.dart';
part 'latlng.g.dart';

@JsonSerializable()
class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
}