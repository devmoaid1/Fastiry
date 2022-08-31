import 'dart:async';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_dialog.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../theme/font_styles.dart';
import '../../../util/colors.dart';

class VerificationScreen extends StatefulWidget {
  final String number;
  final bool fromSignUp;
  final String token;
  final String password;
  VerificationScreen(
      {@required this.number,
      @required this.password,
      @required this.fromSignUp,
      @required this.token});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _number;
  Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _number = widget.number.startsWith('+')
        ? widget.number
        : '+' + widget.number.substring(1, widget.number.length);
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer?.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
          title: 'otp_verification'.tr,
          onBackPressed: () {
            Get.find<AuthController>().googleSignOut();
            Get.back();
          }),
      body: SafeArea(
          child: Scrollbar(
              child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700
              ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
              : null,
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: Get.isDarkMode
                      ? null
                      : [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                )
              : null,
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(children: [
              Image.asset(
                Images.verficationImage,
                height: Dimensions.blockscreenVertical * 35,
              ),
              Get.find<SplashController>().configModel.demo
                  ? Text(
                      'for_demo_purpose'.tr,
                      style: Get.find<FontStyles>().poppinsRegular,
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'enter_the_verification_sent_to'.tr,
                            style: Get.find<FontStyles>()
                                .poppinsRegular
                                .copyWith(
                                    color: Theme.of(context).dividerColor)),
                        TextSpan(
                            text: ' $_number',
                            style: Get.find<FontStyles>()
                                .poppinsMedium
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                      ])),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.blockscreenHorizontal * 6,
                    vertical: Dimensions.blockscreenVertical * 4),
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  cursorColor: Theme.of(context).primaryColor,
                  textStyle: Get.find<FontStyles>().poppinsMedium.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 6,
                      color: lightGreyTextColor),
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 60,
                      fieldWidth: 70,
                      borderWidth: 2,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      selectedColor: Theme.of(context).primaryColor,
                      selectedFillColor: Colors.white,
                      inactiveColor:
                          Theme.of(context).disabledColor.withOpacity(0.8),
                      inactiveFillColor: Colors.white,
                      activeColor:
                          Theme.of(context).primaryColor.withOpacity(0.8),
                      activeFillColor: Colors.white),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: authController.updateVerificationCode,
                  beforeTextPaste: (text) => true,
                ),
              ),
              (widget.password != null && widget.password.isNotEmpty)
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'did_not_receive_the_code'.tr,
                        style: Get.find<FontStyles>().poppinsRegular.copyWith(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.7),
                            fontSize: Dimensions.blockscreenHorizontal * 4),
                      ),
                      TextButton(
                        onPressed: _seconds < 1
                            ? () {
                                if (widget.fromSignUp) {
                                  authController
                                      .login(_number, widget.password)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      _startTimer();
                                      showCustomSnackBar(
                                          'resend_code_successful'.tr,
                                          isError: false);
                                    } else {
                                      showCustomSnackBar(value.message);
                                    }
                                  });
                                } else {
                                  authController
                                      .forgetPassword(_number)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      _startTimer();
                                      showCustomSnackBar(
                                          'resend_code_successful'.tr,
                                          isError: false);
                                    } else {
                                      showCustomSnackBar(value.message);
                                    }
                                  });
                                }
                              }
                            : null,
                        child: Text(
                          '${'resend'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}',
                          style: Get.find<FontStyles>().poppinsMedium.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.blockscreenHorizontal * 4),
                        ),
                      ),
                    ])
                  : SizedBox(),
              authController.verificationCode.length == 4
                  ? !authController.isLoading
                      ? CustomButton(
                          height: Dimensions.blockscreenVertical * 7,
                          buttonText: 'verify'.tr,
                          onPressed: () {
                            if (widget.fromSignUp) {
                              authController
                                  .verifyPhone(_number, widget.token)
                                  .then((value) {
                                if (value.isSuccess) {
                                  showAnimatedDialog(
                                      context,
                                      Center(
                                        child: Container(
                                          width: 300,
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_LARGE),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .RADIUS_EXTRA_LARGE)),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(Images.checked,
                                                    width: 100, height: 100),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                Text('verified'.tr,
                                                    style:
                                                        Get.find<FontStyles>()
                                                            .poppinsBold
                                                            .copyWith(
                                                              fontSize: 30,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .color,
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                            )),
                                              ]),
                                        ),
                                      ),
                                      dismissible: false);
                                  Future.delayed(Duration(seconds: 2), () {
                                    Get.offNamed(
                                        RouteHelper.getAccessLocationRoute(
                                            RouteHelper.splash));
                                  });
                                } else {
                                  showCustomSnackBar(value.message);
                                }
                              });
                            } else {
                              authController.verifyToken(_number).then((value) {
                                if (value.isSuccess) {
                                  Get.toNamed(RouteHelper.getResetPasswordRoute(
                                      _number,
                                      authController.verificationCode,
                                      'reset-password'));
                                } else {
                                  showCustomSnackBar(value.message);
                                }
                              });
                            }
                          },
                        )
                      : Center(child: CircularProgressIndicator())
                  : SizedBox.shrink(),
            ]);
          }),
        ),
      ))),
    );
  }
}
