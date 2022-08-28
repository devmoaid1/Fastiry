import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WalletRepo {
  final ApiConsumer apiClient;
  WalletRepo({@required this.apiClient});

  Future<Response> getWalletTransactionList(String offset) async {
    return await apiClient.get('${AppConstants.WALLET_TRANSACTION_URL}',
        queryParams: {"offset": "$offset", "limit": "10"});
  }

  Future<Response> getLoyaltyTransactionList(String offset) async {
    return await apiClient.get('${AppConstants.LOYALTY_TRANSACTION_URL}',
        queryParams: {"offset": "$offset", "limit": "10"});
  }

  Future<Response> pointToWallet({int point}) async {
    return await apiClient
        .post(AppConstants.LOYALTY_POINT_TRANSFER_URL, body: {"point": point});
  }
}
