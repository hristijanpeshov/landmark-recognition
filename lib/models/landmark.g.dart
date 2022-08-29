// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Landmark _$LandmarkFromJson(Map<String, dynamic> json) => Landmark(
      json['mid'] as String,
      json['description'] as String,
      (json['score'] as num).toDouble(),
      LandmarkScreenLocation.fromJson(
          json['boundingPoly'] as Map<String, dynamic>),
      (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LandmarkToJson(Landmark instance) => <String, dynamic>{
      'mid': instance.mid,
      'description': instance.description,
      'score': instance.score,
      'boundingPoly': instance.boundingPoly,
      'locations': instance.locations,
    };
