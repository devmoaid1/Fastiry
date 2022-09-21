import '/helper/route_helper.dart';
import '/util/colors.dart';
import '/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import '/controller/localization_controller.dart';
import '/util/app_constants.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/view/base/custom_button.dart';
import '/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

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
                          child: Text('select_language'.tr,
                              style: Get.find<FontStyles>().poppinsMedium),
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
                            style: Get.find<FontStyles>()
                                .poppinsRegular
                                .copyWith(
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

                  Get.offNamed(RouteHelper.getSplashRoute(null));
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
