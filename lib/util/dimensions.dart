import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context.width >= 1300 ? 15 : 12;
  static double fontSizeSmall = Get.context.width >= 1300 ? 18 : 14;
  static double fontSizeDefault = Get.context.width >= 1300 ? 19 : 15;
  static double fontSizeLarge = Get.context.width >= 1300 ? 21 : 17;
  static double fontSizeExtraLarge = Get.context.width >= 1300 ? 23 : 19;
  static double fontSizeOverLarge = Get.context.width >= 1300 ? 29 : 25;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;
  static const double PADDING_SIZE_OVER_LARGE = 30.0;

  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double RADIUS_EXTRA_LARGE = 20.0;

  static const double WEB_MAX_WIDTH = 1170;
}
