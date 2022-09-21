import '/controller/splash_controller.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/view/base/custom_button.dart';
import '/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/font_styles.dart';

class UpdateScreen extends StatelessWidget {
  final bool isUpdate;
  UpdateScreen({@required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              isUpdate ? Images.update : Images.maintenance,
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              isUpdate ? 'update'.tr : 'we_are_under_maintenance'.tr,
              style: Get.find<FontStyles>().poppinsBold.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              isUpdate
                  ? 'your_app_is_deprecated'.tr
                  : 'we_will_be_right_back'.tr,
              style: Get.find<FontStyles>().poppinsRegular.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height:
                    isUpdate ? MediaQuery.of(context).size.height * 0.04 : 0),
            isUpdate
                ? CustomButton(
                    buttonText: 'update_now'.tr,
                    onPressed: () async {
                      String _appUrl = 'https://google.com';
                      if (GetPlatform.isAndroid) {
                        _appUrl = Get.find<SplashController>()
                            .configModel
                            .appUrlAndroid;
                      } else if (GetPlatform.isIOS) {
                        _appUrl =
                            Get.find<SplashController>().configModel.appUrlIos;
                      }
                      if (await canLaunchUrl(Uri.parse(_appUrl))) {
                        launchUrl(Uri.parse(_appUrl));
                      } else {
                        showCustomSnackBar('${'can_not_launch'.tr} $_appUrl');
                      }
                    })
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
