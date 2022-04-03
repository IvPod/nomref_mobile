import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme.dart';
import 'routes.dart';
import 'pages/home/home.dart';
import 'authentication/authentication.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (_) =>
          AuthenticationCubit(userRepository: UserRepository())
            ..appStarted(),
      child: MaterialApp(
        title: 'Nomref',
        theme: appTheme,
        initialRoute: HomePage.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
