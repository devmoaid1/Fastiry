import 'package:flutter/material.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget mainWidget;

  ProfileBgWidget({
    @required this.mainWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      mainWidget,
    ]);
  }
}
