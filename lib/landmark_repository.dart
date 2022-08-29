import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:landmark_recognition/models/landmark.dart';

class LandmarkRepository {
  static const String _baseUrl =
      'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyDsscYGPDgRsWajgWL9t8caMPzm2g5pXoU';

  final Dio _dio;

  LandmarkRepository({Dio? dio}) : _dio = Dio();

  Future<Landmark?> getLandmarkInfo(
    String encodedImage,
  ) async {
    print(_dio);
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
            "content": encodedImage
          }
        }
      ]
    };

    // print(json.encode(params));

    final response = await _dio.post(
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
}