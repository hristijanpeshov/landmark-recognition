import 'package:dio/dio.dart';
import 'package:landmark_recognition/google_repository.dart';
import 'package:landmark_recognition/models/landmark_details.dart';

class KnowledgeGraph extends GoogleRepository {

  var API_KEY = "AIzaSyDsscYGPDgRsWajgWL9t8caMPzm2g5pXoU";

  static final KnowledgeGraph _instance = KnowledgeGraph._();

  factory KnowledgeGraph() {
    return _instance;
  }

  KnowledgeGraph._({Dio? dio}) : super(Dio());


  @override
  Future getLandmarkInfo(String? additionalInfo) async {
    var service_url = 'https://kgsearch.googleapis.com/v1/entities:search?ids=$additionalInfo&key=$API_KEY&limit=1&indent=True';
    final response = await dio.get(service_url);
    return LandmarkDetails.fromJson(response.data["itemListElement"][0]["result"]);
  }
}

