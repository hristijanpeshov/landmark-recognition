import 'package:dio/dio.dart';
import 'package:landmark_recognition/models/landmark_details.dart';

class KnowledgeGraph {

  var API_KEY = "AIzaSyDsscYGPDgRsWajgWL9t8caMPzm2g5pXoU";
  final Dio _dio;

  KnowledgeGraph({Dio? dio}) : _dio = Dio();

  Future<LandmarkDetails?> getWikiInfo(String ?id) async {

      var service_url = 'https://kgsearch.googleapis.com/v1/entities:search?ids=$id&key=$API_KEY&limit=1&indent=True';
      final response = await _dio.get(service_url);
      // print("RESULTTTT");
      // print(response.data["itemListElement"][0]["result"]["detailedDescription"]["articleBody"]);
      return LandmarkDetails.fromJson(response.data["itemListElement"][0]["result"]);
  }
}

