import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/localization_controller.dart';
import 'app_constants.dart';

final robotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoMedium = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w600,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBold = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w800,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBlack = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w900,
  fontSize: Dimensions.fontSizeDefault,
);

final poppinsRegular = TextStyle(
  fontFamily: Get.find<LocalizationController>().locale.languageCode == "en"
      ? AppConstants.poppins
      : AppConstants.tajawal,
  fontWeight: Get.find<LocalizationController>().locale.languageCode == "en"
      ? FontWeight.w500
      : FontWeight.w600,
  fontSize: Dimensions.fontSizeDefault,
);

final poppinsMedium = TextStyle(
  fontFamily: Get.find<LocalizationController>().locale.languageCode == "en"
      ? AppConstants.poppins
      : AppConstants.tajawal,
  fontWeight: Get.find<LocalizationController>().locale.languageCode == "en"
      ? FontWeight.w600
      : FontWeight.w700,
  fontSize: Dimensions.fontSizeDefault,
);

final poppinsBold = TextStyle(
  fontFamily: Get.find<LocalizationController>().locale.languageCode == "en"
      ? AppConstants.poppins
      : AppConstants.tajawal,
  fontWeight: Get.find<LocalizationController>().locale.languageCode == "en"
      ? FontWeight.w700
      : FontWeight.w800,
  fontSize: Dimensions.fontSizeDefault,
);

final poppinsBlack = TextStyle(
  fontFamily: Get.find<LocalizationController>().locale.languageCode == "en"
      ? AppConstants.poppins
      : AppConstants.tajawal,
  fontWeight: FontWeight.w900,
  fontSize: Dimensions.fontSizeDefault,
);

final ralewayRegular = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault,
);

final ralewayMedium = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w600,
  fontSize: Dimensions.fontSizeDefault,
);

final ralewayBold = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w800,
  fontSize: Dimensions.fontSizeDefault,
);

final ralewayBlack = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w900,
  fontSize: Dimensions.fontSizeDefault,
);
