import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/authentication/authentication.dart';

import '../registration.dart';

class RegistrationPage extends StatelessWidget {
  static const routeName = '/registration';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: BlocProvider<RegistrationCubit>(
        create: (context) => RegistrationCubit(
            BlocProvider.of<AuthenticationCubit>(context)),
        child: RegistrationForm(),
      ),
    );
  }
}
