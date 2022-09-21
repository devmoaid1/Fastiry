import '/util/images.dart';
import 'package:extended_image/extended_image.dart';
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
    return ExtendedImage.network(image,
        key: UniqueKey(),
        height: height,
        width: width,
        fit: fit,
        cache: true, loadStateChanged: (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          return Image.asset(Images.fastiryLogoRed,
              height: height, width: width, fit: fit);
          break;

        ///if you don't want override completed widget
        ///please return null or state.completedWidget
        //return null;
        //return state.completedWidget;
        case LoadState.completed:
          return ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            width: width,
            height: height,
            fit: BoxFit.fill,
          );
          break;
        case LoadState.failed:
          return Image.asset(Images.placeholder,
              height: height, width: width, fit: fit);
          break;
      }
      return state.completedWidget;
    }

        // placeholder: placeholder,
        // fadeInDuration: Duration(milliseconds: 5),
        // fadeOutDuration: Duration(milliseconds: 5),
        // imageErrorBuilder: (context, url, error) => Image.asset(
        //     Images.placeholder,
        //     height: height,
        //     width: width,
        //     fit: fit),

        // loadingBuilder: (context, child, loadingProgress) {
        //   if (loadingProgress == null) return child;

        //   return Image.asset(placeholder,
        //       height: height, width: width, fit: fit);
        // },
        // errorBuilder: (context, url, error) =>
        //     Image.asset(placeholder, height: height, width: width, fit: fit),
        );
  }
}
