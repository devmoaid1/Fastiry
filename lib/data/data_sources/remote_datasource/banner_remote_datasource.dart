import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';
import '../../api/api_consumer.dart';
import '../../model/response/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<BannerModel> getBannerList();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiConsumer apiClient;

  BannerRemoteDataSourceImpl({@required this.apiClient});
  @override
  Future<BannerModel> getBannerList() async {
    return await apiClient.get(AppConstants.BANNER_URI);
  }
}
