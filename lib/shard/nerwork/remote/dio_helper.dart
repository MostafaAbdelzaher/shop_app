import 'package:dio/dio.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData(
      {required String url, Map<String, dynamic>? query, String? token}) async {
    dio!.options.headers = {
      'Content-Type': ' application/json',
      'lang': 'en',
      'Authorization': token,
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': ' application/json',
      'lange': 'en',
      'Authorization': token
    };
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': ' application/json',
      'lange': 'en',
      'Authorization': token
    };
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData(
      {required String url, String lang = 'en', String? token}) async {
    dio!.options.headers = {
      'Content-Type': ' application/json',
      'lange': 'en',
      'Authorization': token
    };
    return await dio!.delete(
      url,
    );
  }
}
