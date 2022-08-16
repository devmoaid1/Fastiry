import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController implements GetxService {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  RxBool _isConnected = true.obs;

  RxBool get isConnected => _isConnected;

  ConnectivityResult get connectionStatus => _connectionStatus;
  Stream get connectivityStream => Connectivity().onConnectivityChanged;

  ConnectivityService() {
    getInitialConnectionStatus();
  }

  Future<void> getInitialConnectionStatus() async {
    final result = await Connectivity().checkConnectivity();
    handleStatus(result);
  }

  void handleStatus(ConnectivityResult result) async {
    _connectionStatus = result;

    getConnectionStatus(result);
  }

  Future<bool> checkConnection() async {
    try {
      final res =
          await InternetAddress.lookup('www.google.com'); // lookup a site
      final result = res.isNotEmpty && res[0].rawAddress.isNotEmpty;
      return result; //true if result is not empty
    } catch (err) {
      return false;
    }
  }

  void getConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      if (_isConnected.isTrue) {
        _isConnected.toggle(); // no connection
      }
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      final status =
          await checkConnection(); // check connection while wifi or data

      if (status) {
        if (_isConnected.isFalse) _isConnected.toggle(); // connection exits
      }
    }

    update();

    print("Connection status is $_isConnected");
  }
}
