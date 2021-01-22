import 'package:flutter_mask/model/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong/latlong.dart';

class StoreRepository {
  final _distance = Distance();

  Future<List<Store>> fetch(double lat, double lng) async {
    final stores = List<Store>();

    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat=$lat&lng=$lng&m=5000';
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResult = jsonDecode(response.body);
        // print(jsonResult['stores']);
        final jsonStores = jsonResult['stores'];
        // setState(() {
        jsonStores.forEach((e) {
          final store = Store.fromJson(e);
          final km = _distance.as(
              LengthUnit.Kilometer, LatLng(store.lat, store.lng),
              LatLng(lat, lng));
          store.km = km;
          stores.add(store);
        });
        // });

        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');//${(utf8.decode(response.bodyBytes))}');
        return stores
            .where((e) =>
        e.remainStat == 'plenty' ||
            e.remainStat == 'some' ||
            e.remainStat == 'few')
            .toList()
          ..sort((a, b) => a.km.compareTo(b.km));
      } else {
        return [];
      }
    } catch(e) {
      return [];
    }
  }
}
