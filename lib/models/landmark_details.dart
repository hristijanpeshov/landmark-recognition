import 'package:json_annotation/json_annotation.dart';

part 'landmark_details.g.dart';

@JsonSerializable()
class LandmarkDetails {
  // String id;
  String detailedDescription;
  String name;
  String description;


  LandmarkDetails(
      // this.id,
      this.detailedDescription,
      this.name, this.description);


  @override
  String toString() {
    return 'LandmarkDetails{name: $name, description: $description, detailedDescription: $detailedDescription}';
  }

  factory LandmarkDetails.fromJson(Map<String, dynamic> json) => _$LandmarkDetailsFromJson(json);
}


