import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication.dart';

import '../login.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: BlocProvider<LoginCubit>(
        create: (context) =>
            LoginCubit(BlocProvider.of<AuthenticationCubit>(context)),
        child: LoginForm(),
      ),
    );
  }
}
