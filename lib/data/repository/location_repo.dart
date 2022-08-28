import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final ApiConsumer apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({this.apiClient, this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.get(AppConstants.ADDRESS_LIST_URI);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient
        .get('${AppConstants.ZONE_URI}', queryParams: {"lat": lat, "lng": lng});
  }

  Future<Response> removeAddressByID(int id) async {
    return await apiClient.post('${AppConstants.REMOVE_ADDRESS_URI}$id',
        body: {"_method": "delete"});
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.post(AppConstants.ADD_ADDRESS_URI,
        body: addressModel.toJson());
  }

  Future<Response> updateAddress(
      AddressModel addressModel, int addressId) async {
    return await apiClient.put('${AppConstants.UPDATE_ADDRESS_URI}$addressId',
        body: addressModel.toJson());
  }

  Future<bool> saveUserAddress(String address, List<int> zoneIDs) async {
    // apiClient.updateHeader(
    //   sharedPreferences.getString(AppConstants.TOKEN), zoneIDs,
    //   sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
    // );
    return await sharedPreferences.setString(
        AppConstants.USER_ADDRESS, address);
  }

  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    return await apiClient.get('${AppConstants.GEOCODE_URI}', queryParams: {
      "lat": "${latLng.latitude}",
      "lng": "${latLng.longitude}"
    });
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS);
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.get('${AppConstants.SEARCH_LOCATION_URI}',
        queryParams: {"search_text": text});
  }

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.get('${AppConstants.PLACE_DETAILS_URI}',
        queryParams: {"placeid": placeID});
  }
}
