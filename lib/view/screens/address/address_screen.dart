import '/controller/auth_controller.dart';
import '/controller/location_controller.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import '/view/base/confirmation_dialog.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/custom_loader.dart';
import '/view/base/custom_snackbar.dart';
import '/view/base/no_data_screen.dart';
import '/view/base/not_logged_in_screen.dart';
import '/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  final bool fromCheckout;

  AddressScreen({Key key, this.fromCheckout = false}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromCheckout &&
          Get.find<LocationController>().addressList.isNotEmpty) {
        final addressList = Get.find<LocationController>().addressList;
        Get.find<LocationController>().changeAddress(addressList.first);
      }
      // Add Your Code here.
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: 'my_address'.tr),
      floatingActionButton: FloatingActionButton(
        elevation: Get.isDarkMode ? 0 : 1,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(false)),
      ),
      floatingActionButtonLocation: ResponsiveHelper.isDesktop(context)
          ? FloatingActionButtonLocation.centerFloat
          : null,
      body: _isLoggedIn
          ? GetBuilder<LocationController>(builder: (locationController) {
              return locationController.addressList != null
                  ? locationController.addressList.length > 0
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await locationController.getAddressList();
                          },
                          child: Scrollbar(
                              child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                                itemCount:
                                    locationController.addressList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressWidget(
                                    address:
                                        locationController.addressList[index],
                                    fromAddress:
                                        widget.fromCheckout ? false : true,
                                    locationController: locationController,
                                    index: index,
                                    fromCheckout: widget.fromCheckout,
                                    onTap: () {
                                      if (widget.fromCheckout) {
                                        locationController
                                            .setAddressIndex(index);
                                        locationController.changeAddress(
                                            locationController
                                                .addressList[index]);
                                      } else {
                                        Get.toNamed(RouteHelper.getMapRoute(
                                          locationController.addressList[index],
                                          'address',
                                        ));
                                      }
                                    },
                                    onEditPressed: () {
                                      Get.toNamed(
                                          RouteHelper.getEditAddressRoute(
                                              locationController
                                                  .addressList[index]));
                                    },
                                    onRemovePressed: () {
                                      if (Get.isSnackbarOpen) {
                                        Get.back();
                                      }
                                      Get.dialog(ConfirmationDialog(
                                          icon: Images.warning,
                                          description:
                                              'are_you_sure_want_to_delete_address'
                                                  .tr,
                                          onYesPressed: () {
                                            Get.back();
                                            Get.dialog(CustomLoader(),
                                                barrierDismissible: false);
                                            locationController
                                                .deleteUserAddressByID(
                                                    locationController
                                                        .addressList[index].id,
                                                    index)
                                                .then((response) {
                                              Get.back();
                                              showCustomSnackBar(
                                                  response.message,
                                                  isError: !response.isSuccess);
                                            });
                                          }));
                                    },
                                  );
                                },
                              ),
                            ),
                          )),
                        )
                      : NoDataScreen(text: 'no_saved_address_found'.tr)
                  : Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(),
    );
  }
}
