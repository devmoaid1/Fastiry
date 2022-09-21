import '/util/services_instances.dart';
import '/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetConnectionWrapper extends StatelessWidget {
  final Widget screen;
  const InternetConnectionWrapper({Key key, this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityService.isConnected.isTrue) {
        return screen;
      }

      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: NoInternetScreen(
          child: screen,
        ),
      );
    });
  }
}
