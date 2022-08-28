import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiConsumer apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getRunningOrderList(int offset) async {
    return await apiClient
        .get('${AppConstants.RUNNING_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response> getHistoryOrderList(int offset) async {
    return await apiClient
        .get('${AppConstants.HISTORY_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response> getOrderDetails(String orderID) async {
    return await apiClient
        .get('${AppConstants.ORDER_DETAILS_URI}', queryParams: {
      "order_id=": orderID,
    });
  }

  Future<Response> cancelOrder(String orderID) async {
    return await apiClient.post(AppConstants.ORDER_CANCEL_URI,
        body: {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> trackOrder(String orderID) async {
    return await apiClient.get('${AppConstants.TRACK_URI}', queryParams: {
      "order_id=": orderID,
    });
  }

  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    return await apiClient.post(AppConstants.PLACE_ORDER_URI,
        body: orderBody.toJson());
  }

  Future<Response> getDeliveryManData(String orderID) async {
    return await apiClient
        .get('${AppConstants.LAST_LOCATION_URI}', queryParams: {
      "order_id=": orderID,
    });
  }

  Future<Response> switchToCOD(String orderID) async {
    return await apiClient.post(AppConstants.COD_SWITCH_URL,
        body: {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    return await apiClient
        .get('${AppConstants.DISTANCE_MATRIX_URI}', queryParams: {
      "origin_lat": "${originLatLng.latitude}",
      "origin_lng": "${originLatLng.longitude}",
      "destination_lat": "${destinationLatLng.longitude}",
      "destination_lng": "${destinationLatLng.latitude}",
    });
  }
}
