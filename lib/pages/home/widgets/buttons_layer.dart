import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

import '../../station/station.dart';
import '../../profile/profile.dart';
import '../../geo_location/geo_location.dart';
import 'package:nomref_mob/pages/login/login.dart';
import 'package:nomref_mob/pages/station_view/station_view.dart';
import 'package:nomref_mob/services/common_ui/common_ui.dart';
import 'package:nomref_mob/authentication/authentication.dart';

import '../home.dart';

class ButtonsLayer extends StatelessWidget {
  final MapController mapController;

  ButtonsLayer({this.mapController});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);
    final isAuthenticated = authenticationCubit.state ==
        AuthenticationStatus.authenticated;
    return Stack(
      children: [
        positionedButton(
          top: 15,
          left: 15,
          alignment: Alignment.topLeft,
          child: CustomButton.withIcon(
            icon: Icons.account_circle_outlined,
            onTap: () => Navigator.of(context).pushNamed(
              isAuthenticated
                  ? ProfilePage.routeName
                  : LoginPage.routeName,
            ),
          ),
        ),
        positionedButton(
          top: 15,
          right: 15,
          alignment: Alignment.topRight,
          child: CustomButton.withIcon(
            icon: Icons.search,
            onTap: () => showSearch(
              context: context,
              delegate: GeoLocationSearch(),
            ).then((value) {
              if (value != null) {
                mapController.move(
                  LatLng(value['location']?.latitude,
                      value['location']?.longitude),
                  mapController.zoom,
                );
              }
            }),
          ),
        ),
        positionedButton(
          left: 15,
          bottom: 15,
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isAuthenticated) ...[
                CustomButton.withIcon(
                  icon: Icons.add,
                  onTap: () => homeCubit.setAddStationToActive(
                    center: [
                      mapController.center.latitude,
                      mapController.center.longitude,
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
              CustomButton.withIcon(
                icon: Icons.brightness_1_outlined,
                onTap: () => homeCubit.setRadarStateToActive(
                  center: [
                    mapController.center.latitude,
                    mapController.center.longitude,
                  ],
                ),
              ),
            ],
          ),
        ),
        positionedButton(
          right: 15,
          bottom: 15,
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomButton.withText(
                context,
                width: 100,
                text: 'Списком',
                onTap: () => navigationButtonPressed(
                  context: context,
                  stations: homeCubit.stations,
                  routeName: StationViewPage.routeName,
                ),
              ),
              if (isAuthenticated) ...[
                SizedBox(height: 10),
                CustomButton.withText(
                  context,
                  text: 'Мои станции',
                  onTap: () async {
                    await navigationButtonPressed(
                      context: context,
                      routeName: StationPage.routeName,
                      stations: authenticationCubit
                          ?.userRepository?.stations,
                      trailingIcon: Icons.edit,
                    );
                    homeCubit.getStations(
                        data: getMapBounds(mapController.bounds));
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Widget positionedButton({
  @required Widget child,
  @required Alignment alignment,
  double top = 0,
  double left = 0,
  double right = 0,
  double bottom = 0,
}) {
  return Align(
    alignment: alignment,
    child: SafeArea(
      minimum: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: child,
    ),
  );
}
