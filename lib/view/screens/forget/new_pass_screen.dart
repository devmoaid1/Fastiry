import '/controller/auth_controller.dart';
import '/controller/user_controller.dart';
import '/data/model/response/userinfo_model.dart';
import '/helper/route_helper.dart';
import '/util/colors.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/custom_button.dart';
import '/view/base/custom_snackbar.dart';
import '/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class NewPassScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;
  NewPassScreen(
      {@required this.resetToken,
      @required this.number,
      @required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.fromPasswordChange
            ? 'change_password'.tr
            : 'reset_password'.tr,
        isWithLogo: true,
        onBackPressed: () {
          Get.offNamed(RouteHelper.signIn);
        },
      ),
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
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 700 : 300],
                        blurRadius: 5,
                        spreadRadius: 1)
                  ],
                )
              : null,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: Dimensions.blockscreenVertical * 6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.blockscreenHorizontal * 2,
                  vertical: Dimensions.blockscreenHorizontal * 3),
              child: Text('reset_password'.tr,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        fontSize: Dimensions.blockscreenHorizontal * 8,
                      ),
                  textAlign: TextAlign.left),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.blockscreenHorizontal * 2),
              child: Text('enter_new_password'.tr,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 4,
                      color: lightGreyTextColor),
                  textAlign: TextAlign.left),
            ),
            SizedBox(height: Dimensions.blockscreenHorizontal * 14),
            Column(children: [
              CustomTextField(
                hintText: 'new_password'.tr,
                controller: _newPasswordController,
                focusNode: _newPasswordFocus,
                nextFocus: _confirmPasswordFocus,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Images.lock,
                isPassword: true,
              ),
              SizedBox(
                height: Dimensions.blockscreenVertical * 3,
              ),
              CustomTextField(
                hintText: 'confirm_password'.tr,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Images.lock,
                isPassword: true,
                onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
              ),
            ]),
            SizedBox(height: Dimensions.blockscreenHorizontal * 10),
            GetBuilder<UserController>(builder: (userController) {
              return GetBuilder<AuthController>(builder: (authBuilder) {
                return (!authBuilder.isLoading && !userController.isLoading)
                    ? CustomButton(
                        height: Dimensions.blockscreenHorizontal * 13,
                        buttonText: 'done'.tr,
                        onPressed: () => _resetPassword(),
                      )
                    : Center(child: CircularProgressIndicator());
              });
            }),
          ]),
        ),
      ))),
    );
  }

  void _resetPassword() {
    String _password = _newPasswordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        UserInfoModel _user = Get.find<UserController>().userInfoModel;
        _user.password = _password;
        Get.find<UserController>().changePassword(_user).then((response) {
          if (response.isSuccess) {
            showCustomSnackBar('password_updated_successfully'.tr,
                isError: false);
          } else {
            showCustomSnackBar(response.message);
          }
        });
      } else {
        Get.find<AuthController>()
            .resetPassword(widget.resetToken, '+' + widget.number.trim(),
                _password, _confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>()
                .login('+' + widget.number.trim(), _password)
                .then((value) async {
              Get.offAllNamed(
                  RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
