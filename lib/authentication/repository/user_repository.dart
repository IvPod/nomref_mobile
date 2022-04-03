import '../../services/api/api.dart';
import '../../models/user/user.dart';
import '../../models/station/station.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  User _user;
  List<Station> _stations = [];

  User get user => _user;
  List<Station> get stations => _stations;

  Future<User> logIn(Map<String, dynamic> data) async =>
      await UserAPI.logIn(data);

  Future<User> signUp(Map<String, dynamic> data) async =>
      await UserAPI.signUp(data);

  Future<void> getUserStations() async =>
      _stations = await UserAPI.getUserStations(_user?.id);

  Future<bool> hasInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      final token = prefs.getString('token');
      ApiHelper().addAuthorizationHeader(token);
      _user = await UserAPI.getUserInfo().then(
          (value) => value.copyWith(token: prefs.getString('token')));
    }

    return _user == null ? false : true;
  }

  Future<void> persistInfo(User user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _user.token);
    ApiHelper().addAuthorizationHeader(_user.token);
  }

  Future<void> deleteInfo() async {
    _user = null;
    _stations = [];

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    ApiHelper().removeAuthorizationHeader();
  }
}
