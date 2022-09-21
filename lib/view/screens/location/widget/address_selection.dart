import '/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/address_model.dart';
import '../../../base/custom_loader.dart';
import '../../address/widget/address_widget.dart';

class AddressSelection extends StatelessWidget {
  final bool fromSignUp;
  final String route;
  final LocationController locationController;
  const AddressSelection(
      {Key key, this.fromSignUp, this.locationController, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: locationController.addressList.length,
        itemBuilder: (context, index) {
          return Center(
              child: SizedBox(
                  width: 700,
                  child: AddressWidget(
                    address: locationController.addressList[index],
                    fromAddress: false,
                    onTap: () {
                      Get.dialog(CustomLoader(), barrierDismissible: false);
                      AddressModel _address =
                          locationController.addressList[index];
                      locationController.saveAddressAndNavigate(
                          _address, fromSignUp, route, route != null);
                    },
                  )));
        },
      ),
    );
  }
}
