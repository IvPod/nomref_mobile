import 'package:flutter/material.dart';

import '../../home/home.dart';
import '../../../models/station/station.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/common_ui/common_ui.dart';

import '../station.dart';

class StationForm extends StatefulWidget {
  @override
  _StationFormState createState() => _StationFormState();
}

class _StationFormState extends State<StationForm> {
  StationCubit _stationCubit;
  TextEditingController _nameController;
  TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _stationCubit = BlocProvider.of<StationCubit>(context);
    _nameController =
        TextEditingController(text: _stationCubit.station?.name);
    _addressController = TextEditingController(
        text: _stationCubit.station?.location?.formattedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: _stationCubit,
      listener: (context, state) {
        Scaffold.of(context).removeCurrentSnackBar();
        if (state is StationLoading)
          showSnackBar(
            context,
            'Загрузка...',
            showProgress: true,
          );
        if (state is StationSuccess)
          showSnackBar(context, 'Данные успешно сохранены');
        if (state is StationDeleted)
          Navigator.of(context)
              .popUntil(ModalRoute.withName(HomePage.routeName));
        if (state is StationFailed)
          showSnackBar(
            context,
            'Ошибка обновления данных!',
            isError: true,
          );
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.nature_outlined),
                    labelText: 'Название',
                  ),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on_outlined),
                    labelText: 'Адрес',
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Датчики',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                ..._stationCubit.sensors.entries
                    .map(
                      (sensor) => _buildSensorSwitch(sensor),
                    )
                    .toList(),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    if (_stationCubit.station.id != null)
                      CustomButton.withText(
                        context,
                        text: 'Удалить станцию',
                        textColor: Colors.red[500],
                        onTap: _stationCubit.deleteStation,
                      ),
                    CustomButton.withText(
                      context,
                      text: 'Сохранить',
                      onTap: () => _stationCubit.updateStation({
                        'name': _nameController.text,
                        'address': _addressController.text,
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSensorSwitch(MapEntry<String, bool> sensor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(SENSORS[sensor.key],
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            Switch(
              value: sensor.value,
              onChanged: (value) =>
                  _stationCubit.updateSensor(sensor.key, value),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
