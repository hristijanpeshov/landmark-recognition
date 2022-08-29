// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_screen_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandmarkScreenLocation _$LandmarkScreenLocationFromJson(
        Map<String, dynamic> json) =>
    LandmarkScreenLocation(
      (json['vertices'] as List<dynamic>)
          .map((e) => Vertex.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LandmarkScreenLocationToJson(
        LandmarkScreenLocation instance) =>
    <String, dynamic>{
      'vertices': instance.vertices,
    };
