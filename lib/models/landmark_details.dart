import 'package:json_annotation/json_annotation.dart';

part 'landmark_details.g.dart';

@JsonSerializable()
class LandmarkDetails {
  String contentUrl;
  String detailedDescription;
  String name;
  String description;
  List<dynamic> type;

  LandmarkDetails(this.contentUrl, this.detailedDescription, this.name,
      this.description, this.type);


  @override
  String toString() {
    return 'LandmarkDetails{name: $name, description: $description, '
        'detailedDescription: $detailedDescription, contentUrl: $contentUrl, '
        'type: $type}';
  }

  factory LandmarkDetails.fromJson(Map<String, dynamic> json) => _$LandmarkDetailsFromJson(json);
}


