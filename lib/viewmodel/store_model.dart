import 'package:flutter/foundation.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:flutter_mask/repository/location_repository.dart';
import 'package:flutter_mask/repository/store_repository.dart';
import 'package:geolocator/geolocator.dart';

class StoreModel with ChangeNotifier {
  var isLoading;
  List<Store> stores = [];
  final _storeRepository = StoreRepository();
  final _locationRepository = LocationRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    isLoading = true;
    notifyListeners();

    Position position = await _locationRepository.getCurrentLocation();

    stores =
        await _storeRepository.fetch(position.latitude, position.longitude);
    isLoading = false;
    // print('fetch 완료');
    notifyListeners();
  }
}
