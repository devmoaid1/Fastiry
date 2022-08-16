import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final int ratingCount;
  RatingBar(
      {@required this.rating, @required this.ratingCount, this.size = 18});

  @override
  Widget build(BuildContext context) {
    List<Widget> _starList = [];

    int realNumber = rating.floor();
    int partNumber = ((rating - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        _starList.add(Icon(Icons.star,
            color: Theme.of(context).primaryColor, size: size));
      } else if (i == realNumber) {
        _starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(Icons.star,
                  color: Theme.of(context).primaryColor, size: size),
              ClipRect(
                clipper: _Clipper(part: partNumber),
                child: Icon(Icons.star, color: Colors.grey, size: size),
              )
            ],
          ),
        ));
      } else {
        _starList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
    }
    ratingCount != null
        ? _starList.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Text('($ratingCount)',
                style: Get.find<FontStyles>().poppinsRegular.copyWith(
                    fontSize:
                        Get.locale.languageCode == "en" ? size * 0.8 : size,
                    color: Theme.of(context).disabledColor)),
          ))
        : SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _starList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;

  _Clipper({@required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      (size.width / 10) * part,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
