import 'package:json_annotation/json_annotation.dart';
import 'latlng.dart';
part 'location.g.dart';

@JsonSerializable()
class Location {
  LatLng latLng;

  Location(this.latLng);

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}