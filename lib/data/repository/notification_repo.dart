import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  final ApiConsumer apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo(
      {@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getNotificationList() async {
    return await apiClient.get(AppConstants.NOTIFICATION_URI);
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, count);
  }

  int getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.NOTIFICATION_COUNT);
  }
}
