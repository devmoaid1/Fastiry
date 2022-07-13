import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:efood_multivendor/view/screens/auth/widget/guest_button.dart';
import 'package:efood_multivendor/view/screens/auth/widget/or_row.dart';
import 'package:efood_multivendor/view/screens/auth/widget/social_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700
                ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                : null,
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 700 : 300],
                          blurRadius: 5,
                          spreadRadius: 1)
                    ],
                  )
                : BoxDecoration(color: Colors.white),
            child: GetBuilder<AuthController>(builder: (authController) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // Center(child: Image.asset(Images.logo_name, width: 100)),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text('Create Account'.tr,
                        style: poppinsRegular.copyWith(fontSize: 30)),
                    SizedBox(height: 20),
                    Column(children: [
                      CustomTextField(
                        hintText: 'first_name'.tr,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.user,
                        divider: false,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'last_name'.tr,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.user,
                        divider: false,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                        divider: false,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      Row(children: [
                        CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          initialSelection: CountryCode.fromCountryCode(
                                  Get.find<SplashController>()
                                      .configModel
                                      .country)
                              .code,
                          favorite: [
                            CountryCode.fromCountryCode(
                                    Get.find<SplashController>()
                                        .configModel
                                        .country)
                                .code
                          ],
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          dialogBackgroundColor: Theme.of(context).cardColor,
                          textStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Expanded(
                            child: CustomTextField(
                          hintText: 'phone'.tr,
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.phone,
                          divider: false,
                        )),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        divider: false,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        nextFocus: _referCodeFocus,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        divider: false,
                        onSubmit: (text) =>
                            (GetPlatform.isWeb && authController.acceptTerms)
                                ? _register(authController, _countryDialCode)
                                : null,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: 'refer_code'.tr,
                        controller: _referCodeController,
                        focusNode: _referCodeFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.refer_code,
                        divider: false,
                        prefixSize: 14,
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    ConditionCheckBox(authController: authController),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    !authController.isLoading
                        ? CustomButton(
                            buttonText: 'sign_up'.tr,
                            onPressed: authController.acceptTerms
                                ? () =>
                                    _register(authController, _countryDialCode)
                                : null,
                          )
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    Row(
                      children: [
                        Text(
                          "Already have account ?".tr,
                          style: poppinsRegular,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () => Get.toNamed(
                                RouteHelper.getSignInRoute('sign-in')),
                            child: Text(
                              "sign_in".tr,
                              style: poppinsMedium.copyWith(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    OrRow(),
                    SocialLoginWidget(
                        fontColor: Colors.black,
                        color: Colors.white,
                        iconPath: Images.googleIcon,
                        title: "Continue With Google",
                        onTap: () {}),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    SocialLoginWidget(
                        fontColor: Colors.black,
                        iconColor: Colors.blue,
                        color: Colors.white,
                        iconPath: Images.facebookIcon,
                        title: "Continue With Faceook",
                        onTap: () {}),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    GuestButton(),
                  ]);
            }),
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();

    String _numberWithCountryCode = countryCode + _number;
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

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: _firstName,
        lName: _lastName,
        email: _email,
        phone: _numberWithCountryCode,
        password: _password,
        refCode: _referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          if (status.message == "The email has already been taken." ||
              status.message == "The phone has already been taken.") {
            showCustomSnackBar(status.message);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('successup'.tr),
                backgroundColor: Colors.teal,
                duration: Duration(milliseconds: 6000),
              ),
            );
            Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.signUp));
          }
        }
      });
    }
  }
}
