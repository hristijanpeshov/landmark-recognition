import 'package:json_annotation/json_annotation.dart';
import 'package:landmark_recognition/models/vertex.dart';
part 'landmark_screen_location.g.dart';

@JsonSerializable()
class LandmarkScreenLocation {
  List<Vertex> vertices;

  LandmarkScreenLocation(this.vertices);
  factory LandmarkScreenLocation.fromJson(Map<String, dynamic> json) => _$LandmarkScreenLocationFromJson(json);
}
