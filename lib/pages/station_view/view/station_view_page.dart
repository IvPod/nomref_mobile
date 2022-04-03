import 'package:flutter/material.dart';

import '../../../models/station/station.dart';

class StationViewPage extends StatelessWidget {
  static const routeName = '/station_view';
  final Station station;

  const StationViewPage(this.station);

  @override
  Widget build(BuildContext context) {
    final coordinates =
        '${station.location.coordinates[0]}, ${station.location.coordinates[0]}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Станция'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('Название'),
                subtitle: Text(station.name),
                leading: Icon(
                  Icons.nature_outlined,
                  size: 37,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('Адрес'),
                subtitle: Text(station.location.formattedAddress),
                leading: Icon(
                  Icons.location_on_outlined,
                  size: 37,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('Координаты'),
                subtitle: Text(coordinates),
                leading: Icon(
                  Icons.explore_outlined,
                  size: 37,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('Датчики'),
                subtitle: station.sensors.isNotEmpty
                    ? Wrap(
                        children: station.sensors
                            .map((element) => Row(
                                  children: [Text(SENSORS[element])],
                                ))
                            .toList(),
                      )
                    : Text('Отсутствуют'),
                leading: Icon(
                  Icons.track_changes_outlined,
                  size: 37,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('Дата создания'),
                subtitle:
                    Text(station.createdAt.toString().split(' ')[0]),
                leading: Icon(
                  Icons.schedule_outlined,
                  size: 37,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
