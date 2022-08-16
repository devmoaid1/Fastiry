import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/app_constants.dart';
import '../util/dimensions.dart';

class FontStyles extends GetxService {
  TextStyle _poppinsRegular;
  TextStyle _poppinsMedium;
  TextStyle _poppinsBlack;
  TextStyle _poppinsBold;

  TextStyle get poppinsRegular => _poppinsRegular;
  TextStyle get poppinsMedium => _poppinsMedium;
  TextStyle get poppinsBlack => _poppinsBlack;
  TextStyle get poppinsBold => _poppinsBold;

  void setFonts(String languageCode) {
    if (languageCode == "en") {
      _poppinsRegular = TextStyle(
        fontFamily: AppConstants.poppins,
        fontWeight: FontWeight.w500,
        fontSize: Dimensions.fontSizeDefault,
      );

      _poppinsMedium = TextStyle(
        fontFamily: AppConstants.poppins,
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.fontSizeDefault,
      );
      _poppinsBold = TextStyle(
        fontFamily: AppConstants.poppins,
        fontWeight: FontWeight.w700,
        fontSize: Dimensions.fontSizeDefault,
      );

      _poppinsBlack = TextStyle(
        fontFamily: AppConstants.poppins,
        fontWeight: FontWeight.w900,
        fontSize: Dimensions.fontSizeDefault,
      );
    } else {
      _poppinsRegular = TextStyle(
        fontFamily: AppConstants.tajawal,
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.fontSizeDefault,
      );

      _poppinsMedium = TextStyle(
        fontFamily: AppConstants.tajawal,
        fontWeight: FontWeight.w700,
        fontSize: Dimensions.fontSizeDefault,
      );
      _poppinsBold = TextStyle(
        fontFamily: AppConstants.tajawal,
        fontWeight: FontWeight.w800,
        fontSize: Dimensions.fontSizeDefault,
      );

      _poppinsBlack = TextStyle(
        fontFamily: AppConstants.tajawal,
        fontWeight: FontWeight.w900,
        fontSize: Dimensions.fontSizeDefault,
      );
    }
  }

  FontStyles();
  FontStyles.english() {
    _poppinsRegular = TextStyle(
      fontFamily: AppConstants.poppins,
      fontWeight: FontWeight.w500,
      fontSize: Dimensions.fontSizeDefault,
    );

    _poppinsMedium = TextStyle(
      fontFamily: AppConstants.poppins,
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.fontSizeDefault,
    );
    _poppinsBold = TextStyle(
      fontFamily: AppConstants.poppins,
      fontWeight: FontWeight.w700,
      fontSize: Dimensions.fontSizeDefault,
    );

    _poppinsBlack = TextStyle(
      fontFamily: AppConstants.poppins,
      fontWeight: FontWeight.w900,
      fontSize: Dimensions.fontSizeDefault,
    );
  }

  FontStyles.arabic() {
    _poppinsRegular = TextStyle(
      fontFamily: AppConstants.tajawal,
      fontWeight: FontWeight.w600,
      fontSize: Dimensions.fontSizeDefault,
    );

    _poppinsMedium = TextStyle(
      fontFamily: AppConstants.tajawal,
      fontWeight: FontWeight.w700,
      fontSize: Dimensions.fontSizeDefault,
    );
    _poppinsBold = TextStyle(
      fontFamily: AppConstants.tajawal,
      fontWeight: FontWeight.w800,
      fontSize: Dimensions.fontSizeDefault,
    );

    _poppinsBlack = TextStyle(
      fontFamily: AppConstants.tajawal,
      fontWeight: FontWeight.w900,
      fontSize: Dimensions.fontSizeDefault,
    );
  }
}
