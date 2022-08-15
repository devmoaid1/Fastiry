import 'dart:async';

import 'package:efood_multivendor/data/services/connectivity_service.dart';
import 'package:get/get.dart';

class ConectivityController extends GetxController implements GetxService {
  final connectivityService = Get.find<ConnectivityService>();

  StreamSubscription _conectivitySubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initConnectionStream();
  }

  void initConnectionStream() {
    _conectivitySubscription =
        connectivityService.connectivityStream.listen((status) {
      connectivityService.handleStatus(status);
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _conectivitySubscription.cancel();
  }
}
