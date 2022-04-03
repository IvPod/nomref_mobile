import '../../../models/address/address.dart';
import '../../../models/station/station.dart';

import '../api.dart';

class MapAPI {
  static Future<List<Address>> getLocationByAddress(
      String address) async {
    final response =
        await ApiHelper().get('/stations/address/$address');
    final listAddresses = response['data']
        ?.map<Address>((address) => Address.fromJson(address))
        ?.toList();
    return listAddresses;
  }

  static Future<List<Station>> getStations() async {
    final response = await ApiHelper().get('/stations');
    final listStations = response['data']
        ?.map<Station>((station) => Station.fromJson(station))
        ?.toList();
    return listStations;
  }

  static Future<List<Station>> getStationsInBox(
      Map<String, dynamic> data) async {
    final response = await ApiHelper().get(
        '/stations/box/${data['SWLat']},${data['SWLng']}/${data['NELat']},${data['NELng']}');
    final listStations = response['data']
        ?.map<Station>((station) => Station.fromJson(station))
        ?.toList();
    return listStations;
  }

  static Future<List<Station>> getStationsInRadius(
      Map<String, dynamic> data) async {
    final response = await ApiHelper().get(
        '/stations/radius/${data['lat']},${data['lng']}/${data['radius']}');
    final listStations = response['data']
        ?.map<Station>((station) => Station.fromJson(station))
        ?.toList();
    return listStations;
  }

  static Future<Address> getLocationByCoords(
      List<double> data) async {
    final response = await ApiHelper()
        .get('/stations/latlng/${data[0]},${data[1]}');
    final address = Address.fromJson(response['data'][0]);
    return address;
  }

  static Future<Station> createStation(
      Map<String, dynamic> data) async {
    final response = await ApiHelper().post('/stations', data);
    return Station.fromJson(response['data']);
  }

  static Future<Station> updateStation(
      Map<String, dynamic> data) async {
    final response =
        await ApiHelper().put('/stations/${data['_id']}', data);
    return Station.fromJson(response['data']);
  }

  static Future<bool> deleteStation(String stationId) async {
    await ApiHelper().delete('/stations/$stationId');
    return true;
  }
}
