import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/station/station.dart';
import '../../../authentication/authentication.dart';

import '../station.dart';

class StationPage extends StatelessWidget {
  static const routeName = '/station';
  final Station station;

  const StationPage(this.station);

  @override
  Widget build(BuildContext context) {
    final authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Станция'),
      ),
      body: BlocProvider(
        create: (_) => StationCubit(
          station: station,
          authenticationCubit: authenticationCubit,
        ),
        child: StationForm(),
      ),
    );
  }
}
