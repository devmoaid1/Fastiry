import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CouponRepo {
  final ApiConsumer apiClient;
  CouponRepo({@required this.apiClient});

  Future<Response> getCouponList() async {
    return await apiClient.get(AppConstants.COUPON_URI);
  }

  Future<Response> applyCoupon(String couponCode, int restaurantID) async {
    return await apiClient.get('${AppConstants.COUPON_APPLY_URI}',
        queryParams: {
          "code": couponCode,
          "restaurant_id": restaurantID.toString()
        });
  }
}
