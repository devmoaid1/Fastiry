import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholder;
  final Widget loadingWidget;
  CustomImage(
      {@required this.image,
      this.height,
      this.loadingWidget,
      this.width,
      this.fit = BoxFit.cover,
      this.placeholder = Images.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FadeInImage.assetNetwork(
        image: image,
        height: height,
        width: width,
        fit: fit,
        placeholder: placeholder,
        fadeInDuration: Duration(milliseconds: 5),
        fadeOutDuration: Duration(milliseconds: 5),
        imageErrorBuilder: (context, url, error) => Image.asset(
            Images.placeholder,
            height: height,
            width: width,
            fit: fit),

        // loadingBuilder: (context, child, loadingProgress) {
        //   if (loadingProgress == null) return child;

        //   return Image.asset(placeholder,
        //       height: height, width: width, fit: fit);
        // },
        // errorBuilder: (context, url, error) =>
        //     Image.asset(placeholder, height: height, width: width, fit: fit),
      ),
    );
  }
}
