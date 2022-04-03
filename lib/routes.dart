import 'package:flutter/material.dart';
import 'package:nomref_mob/pages/home/home.dart';
import 'package:nomref_mob/pages/login/login.dart';
import 'package:nomref_mob/pages/station/station.dart';
import 'package:nomref_mob/pages/profile/profile.dart';
import 'package:nomref_mob/pages/station_view/station_view.dart';
import 'package:nomref_mob/pages/registration/view/view.dart';

abstract class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: HomePage.routeName),
          builder: (context) => HomePage(),
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: LoginPage.routeName),
          builder: (context) => LoginPage(),
        );
      case RegistrationPage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: RegistrationPage.routeName),
          builder: (context) => RegistrationPage(),
        );
      case ProfilePage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ProfilePage.routeName),
          builder: (context) => ProfilePage(),
        );
      case StationViewPage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: StationViewPage.routeName),
          builder: (context) => StationViewPage(args),
        );
      case StationPage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: StationPage.routeName),
          builder: (context) => StationPage(args),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Ошибка')),
        body: Center(child: Text('Ошибка навигации')),
      );
    });
  }
}
