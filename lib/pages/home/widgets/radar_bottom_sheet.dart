import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../station_view/station_view.dart';
import '../../../services/common_ui/common_ui.dart';

import '../home.dart';

class RadarBottomSheet extends StatefulWidget {
  final MapController mapController;
  const RadarBottomSheet({this.mapController});

  @override
  _RadarBottomSheetState createState() => _RadarBottomSheetState();
}

class _RadarBottomSheetState extends State<RadarBottomSheet> {
  HomeCubit _homeCubit;
  @override
  void didChangeDependencies() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                _buildRadius(),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton.withText(
                        context,
                        text: 'Назад',
                        onTap: () {
                          _homeCubit.setRadarStateToNotActive();
                          _homeCubit.getStations(
                              data: getMapBounds(
                                  widget.mapController.bounds));
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomButton.withText(
                        context,
                        text: 'Списком',
                        onTap: _homeCubit.stations.isNotEmpty
                            ? () => navigationButtonPressed(
                                  context: context,
                                  routeName:
                                      StationViewPage.routeName,
                                  stations: _homeCubit.stations,
                                )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadius() {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Радиус',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '${_homeCubit.radius.toInt()} км',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        Slider(
          max: 300,
          divisions: 10,
          value: _homeCubit.radius,
          label: '${_homeCubit.radius}',
          onChanged: (value) => _homeCubit.setRadius(value),
          onChangeEnd: (value) => _homeCubit.getStationsInRadius(),
        ),
      ],
    );
  }
}
