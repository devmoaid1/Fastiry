import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import '../../../data/model/body/customer.dart';
import '../../../theme/font_styles.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBody socialLogInBody;
  final String token;
  final Customer customer;
  ForgetPassScreen(
      {@required this.fromSocialLogin,
      @required this.socialLogInBody,
      this.token,
      this.customer});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _countryDialCode = CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel.country)
      .dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
          title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      body: SafeArea(
          child: Center(
        child: Scrollbar(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Center(
              child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700
                ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                : null,
            child: Column(children: [
              Image.asset(Images.forgot,
                  height: Dimensions.blockscreenVertical * 25),
              SizedBox(
                height: Dimensions.PADDING_SIZE_LARGE,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.RADIUS_SMALL,
                    vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                child: Text('please_enter_mobile'.tr,
                    style: Get.find<FontStyles>()
                        .poppinsRegular
                        .copyWith(color: Theme.of(context).dividerColor),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: Dimensions.blockscreenVertical * 5),
              Row(children: [
                CodePickerWidget(
                  onChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  initialSelection: CountryCode.fromCountryCode(
                          Get.find<SplashController>().configModel.country)
                      .code,
                  favorite: [
                    CountryCode.fromCountryCode(
                            Get.find<SplashController>().configModel.country)
                        .code
                  ],
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  showFlagMain: true,
                  countryFilter: [_countryDialCode],
                  dialogBackgroundColor: Theme.of(context).cardColor,
                  textStyle: Get.find<FontStyles>().poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).dividerColor,
                      ),
                ),
                Expanded(
                    child: CustomTextField(
                  controller: _numberController,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                  textColor: Theme.of(context).dividerColor,
                  hintText: 'phone'.tr,
                  onSubmit: (text) =>
                      GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null,
                )),
              ]),
              SizedBox(height: Dimensions.blockscreenVertical * 5),
              GetBuilder<AuthController>(builder: (authController) {
                return !authController.isLoading
                    ? CustomButton(
                        height: Dimensions.blockscreenVertical * 8,
                        buttonText: 'next'.tr,
                        onPressed: () => _forgetPass(_countryDialCode),
                      )
                    : Center(child: CircularProgressIndicator());
              }),
            ]),
          )),
        )),
      )),
    );
  }

  void _forgetPass(String countryCode) async {
    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = countryCode + _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      if (widget.fromSocialLogin) {
        widget.socialLogInBody.phone = _numberWithCountryCode;
        Get.find<AuthController>().handleSocialPhone(
            widget.socialLogInBody, widget.customer, widget.token);
        //  Get.find<AuthController>()
        // .registerWithSocialMedia(widget.socialLogInBody);
      } else {
        Get.find<AuthController>()
            .forgetPassword(_numberWithCountryCode)
            .then((status) async {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getVerificationRoute(
                _numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
