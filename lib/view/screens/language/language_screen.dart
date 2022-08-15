import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  ChooseLanguageScreen({this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
          return Column(children: [
            Expanded(
                child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Container(
                                child: Image.asset(
                                  Images.fastiryRed,
                                  fit: BoxFit.fill,
                                ),
                                height: Dimensions.blockscreenHorizontal * 30)),

                        SizedBox(
                          height: Dimensions.blockscreenVertical * 3,
                        ),
                        //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child:
                              Text('select_language'.tr, style: poppinsMedium),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        ListView.builder(
                          itemCount: localizationController.languages.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => LanguageWidget(
                            languageModel:
                                localizationController.languages[index],
                            localizationController: localizationController,
                            index: index,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        Text('you_can_change_language'.tr,
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: lightGreyTextColor.withOpacity(0.7),
                            )),
                      ]),
                ),
              ),
            )),
            CustomButton(
              buttonText: 'save'.tr,
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              onPressed: () {
                if (localizationController.languages.length > 0 &&
                    localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex]
                        .languageCode,
                    AppConstants.languages[localizationController.selectedIndex]
                        .countryCode,
                  ));
                  // Get.rootController.refresh();
                  // Get.rootController.restartApp();
                  Get.offNamed(RouteHelper.getSplashRoute(null));

                  // if (fromMenu) {
                  //   Navigator.pop(context);
                  // } else {
                  //   Get.offNamed(RouteHelper.getOnBoardingRoute());
                  // }
                } else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ]);
        }),
      ),
    );
  }
}
