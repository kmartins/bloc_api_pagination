

import 'package:dio/dio.dart';
import 'package:paginations/ApiResult.dart';

class Api {
  Future<ApiResult> getFavorites(int page) async {
    Response response = await Dio().get("https://reqres.in/api/users?page=$page");
    return ApiResult.fromJson(response.data);
  }
}