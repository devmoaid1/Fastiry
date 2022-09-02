import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';
import '../../api/api_consumer.dart';
import '../../model/response/product_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<BasicCampaignModel>> getBasicCampaignList();

  Future<BasicCampaignModel> getCampaignDetails(String campaignID);

  Future<List<Product>> getItemCampaignList();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiConsumer apiClient;

  CategoryRemoteDataSourceImpl({@required this.apiClient});
  @override
  Future<List<BasicCampaignModel>> getBasicCampaignList() async {
    return await apiClient.get(AppConstants.BASIC_CAMPAIGN_URI);
  }

  @override
  Future<BasicCampaignModel> getCampaignDetails(String campaignID) async {
    return await apiClient.get('${AppConstants.BASIC_CAMPAIGN_DETAILS_URI}',
        queryParams: {"basic_campaign_id": campaignID});
  }

  @override
  Future<List<Product>> getItemCampaignList() async {
    return await apiClient.get(AppConstants.ITEM_CAMPAIGN_URI);
  }
}
