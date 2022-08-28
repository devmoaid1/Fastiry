import 'dart:async';

import 'package:get/get.dart';

import '../util/services_instances.dart';

class ConectivityController extends GetxController implements GetxService {
  StreamSubscription _conectivitySubscription;

  @override
  void onInit() {
    initConnectionStream();
    super.onInit();
  }

  bool isFirstTime = true;
  void initConnectionStream() {
    _conectivitySubscription =
        connectivityService.connectivityStream.listen((status) {
      connectivityService.handleStatus(status);
    });
  }

  @override
  void onClose() {
    super.onClose();
    _conectivitySubscription.cancel();
  }
}
