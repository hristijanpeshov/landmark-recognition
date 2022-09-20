import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:landmark_recognition/models/landmark.dart';

import 'google_repository.dart';

class LandmarkRepository extends GoogleRepository {
  static const String _baseUrl =
      'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyDsscYGPDgRsWajgWL9t8caMPzm2g5pXoU';

  // final Dio _dio;

  static final LandmarkRepository _instance = LandmarkRepository._();

  factory LandmarkRepository() {
    return _instance;
  }

  LandmarkRepository._({Dio? dio}) : super(Dio());

  @override
  Future getLandmarkInfo(String? additionalInfo) async {
    // print(_dio);
    // print(origin);
    // print(destination);

    var params =  {
      "requests": [
        {
          "features": [
            {
              "maxResults": 10,
              "type": "LANDMARK_DETECTION"
            }
          ],
          "image": {
            "content": additionalInfo!
          },
          // "imageContext": {
          //   "cropHintsParams": {
          //     "aspectRatios": [
          //       0.5625
          //     ]
          //   }
          // },
        }
      ]
    };

    // print(json.encode(params));

    final response = await dio.post(
      _baseUrl,
      data: json.encode(params),
    );
    print(response);

    // Check if response is successful
    if (response.data["responses"][0]["landmarkAnnotations"] != null) {
      return Landmark.fromJson(response.data["responses"][0]["landmarkAnnotations"][0]);
    }
    return null;
  }


  // Future<Landmark?> getLandmarkInfo(
  //   String encodedImage,
  // ) async {
  //   print(_dio);
  //   // print(origin);
  //   // print(destination);
  //
  //   var params =  {
  //     "requests": [
  //       {
  //         "features": [
  //           {
  //             "maxResults": 10,
  //             "type": "LANDMARK_DETECTION"
  //           }
  //         ],
  //         "image": {
  //           "content": encodedImage
  //         },
  //         // "imageContext": {
  //         //   "cropHintsParams": {
  //         //     "aspectRatios": [
  //         //       0.5625
  //         //     ]
  //         //   }
  //         // },
  //       }
  //     ]
  //   };
  //
  //   // print(json.encode(params));
  //
  //   final response = await _dio.post(
  //     _baseUrl,
  //     data: json.encode(params),
  //   );
  //   print(response);
  //
  //   // Check if response is successful
  //   if (response.data["responses"][0]["landmarkAnnotations"] != null) {
  //     return Landmark.fromJson(response.data["responses"][0]["landmarkAnnotations"][0]);
  //   }
  //   return null;
  // }
}