import 'package:dio/dio.dart';

abstract class GoogleRepository {
  Dio dio;

  GoogleRepository(this.dio);

  Future getLandmarkInfo(String? additionalInfo);

}