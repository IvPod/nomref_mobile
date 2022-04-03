import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/authentication/authentication.dart';

import '../home.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder(
        cubit: BlocProvider.of<AuthenticationCubit>(context),
        builder: (context, state) {
          return Scaffold(
            body: HomeForm(),
          );
        },
      ),
    );
  }
}
