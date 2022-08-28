import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/body/review_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepo extends GetxService {
  final ApiConsumer apiClient;
  ProductRepo({@required this.apiClient});

  Future<Response> getPopularProductList(String type) async {
    return await apiClient
        .get('${AppConstants.POPULAR_PRODUCT_URI}', queryParams: {
      "type": type,
    });
  }

  Future<Response> getReviewedProductList(String type) async {
    return await apiClient
        .get('${AppConstants.REVIEWED_PRODUCT_URI}', queryParams: {
      "type": type,
    });
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.post(AppConstants.REVIEW_URI,
        body: reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.post(AppConstants.DELIVER_MAN_REVIEW_URI,
        body: reviewBody.toJson());
  }
}
