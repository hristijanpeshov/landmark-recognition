import 'package:json_annotation/json_annotation.dart';
import 'landmark_screen_location.dart';
import 'location.dart';
part 'landmark.g.dart';

@JsonSerializable()
class Landmark {
  String mid;
  String description;
  double score;
  LandmarkScreenLocation boundingPoly;
  List<Location> locations;

  Landmark(this.mid, this.description, this.score, this.boundingPoly,
      this.locations);

  factory Landmark.fromJson(Map<String, dynamic> json) => _$LandmarkFromJson(json);
}
