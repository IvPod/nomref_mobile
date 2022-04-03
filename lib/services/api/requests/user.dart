import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../api.dart';

import '../../../models/user/user.dart';
import '../../../models/station/station.dart';

abstract class UserAPI {
  static Future<User> getUserInfo() async {
    final response = await ApiHelper().get('/users/myProfile');
    return User.fromJson(response);
  }

  static Future<List<Station>> getUserStations(String userId) async {
    final response = await ApiHelper().get('/stations/user/$userId');
    final listStations = response['data']
        ?.map<Station>((station) => Station.fromJson(station))
        ?.toList();
    return listStations;
  }

  static Future<User> logIn(Map<String, dynamic> data) async {
    final response = await ApiHelper().post('/users/login', data);
    return User.fromJson(response['data']);
  }

  static Future<User> signUp(Map<String, dynamic> data) async {
    final response = await ApiHelper().post('/users', data);
    return User.fromJson(response['data']);
  }

  static Future<User> updateInfo(Map<String, dynamic> data) async {
    final response = await ApiHelper().put('/users/myProfile', data);
    return User.fromJson(response['data']);
  }

  static Future<bool> deleteMyProfile() async {
    await ApiHelper().delete('/users/myProfile');
    return true;
  }

  static Future<String> uploadAvatar(String avatarPath) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        avatarPath,
        contentType: MediaType('image', '*'),
      ),
    });

    var response = await ApiHelper().put('/users/photo', formData);
    return response['data']['image'];
  }
}
