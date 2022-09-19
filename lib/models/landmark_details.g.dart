// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandmarkDetails _$LandmarkDetailsFromJson(Map<String, dynamic> json) =>
    LandmarkDetails(
      json['image']['contentUrl'] as String,
      json['detailedDescription']['articleBody'] as String,
      json['name'] as String,
      json['description'] as String,
      json['@type'] as List<dynamic>,
    );

Map<String, dynamic> _$LandmarkDetailsToJson(LandmarkDetails instance) =>
    <String, dynamic>{
      'detailedDescription': instance.detailedDescription,
      'name': instance.name,
      'description': instance.description,
    };
