import 'package:rxdart/rxdart.dart';

import '../../../services/api/api.dart';
import '../../../models/address/address.dart';

class GeoLocationSearchBloc {
  String _error;
  String get error => _error;
  final _subjectAddress = BehaviorSubject<List<Address>>();
  Stream<List<Address>> get address => _subjectAddress.stream;

  void getAddress(String address) async {
    try {
      final listAddresses =
          await MapAPI.getLocationByAddress(address);
      _subjectAddress.sink.add(listAddresses);
      _error = null;
    } catch (e) {
      _error = 'Ошибка получения данных';
    }
  }

  void dispose() {
    _subjectAddress.close();
  }
}
