// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandmarkDetails _$LandmarkDetailsFromJson(Map<String, dynamic> json) =>
    LandmarkDetails(
      // json['id'] as String,
      json['detailedDescription']['articleBody'] as String,
      json['name'] as String,
      json['description'] as String,
    );

Map<String, dynamic> _$LandmarkDetailsToJson(LandmarkDetails instance) =>
    <String, dynamic>{
      // 'id': instance.id,
      'detailedDescription': instance.detailedDescription,
      'name': instance.name,
      'description': instance.description,
    };
