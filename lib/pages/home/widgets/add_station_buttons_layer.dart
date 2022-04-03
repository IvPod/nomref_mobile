import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../station/station.dart';
import '../../../models/station/station.dart';
import '../../../models/location/location.dart';
import '../../../services/common_ui/common_ui.dart';
import '../../../authentication/authentication.dart';

import '../home.dart';

class AddStationButtonLayer extends StatelessWidget {
  final MapController mapController;
  const AddStationButtonLayer({this.mapController});

  @override
  Widget build(BuildContext context) {
    var station;
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);

    if (homeCubit.stationAddress != null) {
      station = Station(
        userId: authenticationCubit.userRepository.user.id,
        location: Location(
          type: 'Point',
          formattedAddress: homeCubit.stationAddress.formattedAddress,
          coordinates: [
            homeCubit.stationAddress.latitude,
            homeCubit.stationAddress.longitude,
          ],
        ),
        sensors: [],
      );
    }
    return Stack(
      children: [
        positionedButton(
          left: 15,
          bottom: 15,
          alignment: Alignment.bottomLeft,
          child: CustomButton.withText(
            context,
            width: 100,
            text: 'Назад',
            onTap: () {
              homeCubit.setAddStationToNotActive();
              homeCubit.getStations(
                  data: getMapBounds(mapController.bounds));
            },
          ),
        ),
        positionedButton(
          right: 15,
          bottom: 15,
          alignment: Alignment.bottomRight,
          child: CustomButton.withText(
            context,
            width: 100,
            text: 'Далее',
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  StationPage.routeName,
                  arguments: station);
              homeCubit.setAddStationToNotActive();
              homeCubit.getStations(
                  data: getMapBounds(mapController.bounds));
            },
          ),
        ),
      ],
    );
  }
}
