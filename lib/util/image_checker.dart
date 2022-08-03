import 'package:flutter/material.dart';

import '../view/base/custom_image.dart';
import 'images.dart';

Widget checkImage(String url, double width, double height, BoxFit fit) {
  try {
    return CustomImage(
      image: url,
      height: height,
      width: width,
      fit: BoxFit.fill,
    );
  } catch (e) {
    return Image.asset(
      Images.placeholder,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
