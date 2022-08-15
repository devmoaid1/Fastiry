import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';

class AddressMapCard extends StatelessWidget {
  final LocationController locationController;
  const AddressMapCard({Key key, @required this.locationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Dimensions.screeHeight * 0.35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            border: Border.all(
                color: Theme.of(context).disabledColor.withOpacity(0.7),
                width: 0.5)),
        width: Dimensions.screenWidth,
        child: Column(
          children: [
            Container(
              height: (Dimensions.screeHeight * 0.35) * 0.65,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          zoom: 17,
                          target: LatLng(
                              double.parse(locationController
                                      .getUserAddress()
                                      .latitude ??
                                  0),
                              double.parse(locationController
                                      .getUserAddress()
                                      .longitude ??
                                  0))),
                      onTap: (latLang) {},
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      onCameraIdle: () {
                        locationController.updatePosition(
                            CameraPosition(
                                zoom: 17,
                                target: LatLng(
                                    double.parse(locationController
                                            .selectedAddress.latitude ??
                                        ' 0'),
                                    double.parse(locationController
                                            .selectedAddress.longitude ??
                                        '0'))),
                            true);
                      },
                      indoorViewEnabled: true,
                      mapToolbarEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        locationController.setMapController(controller);

                        locationController.getCurrentLocation(true,
                            mapController: controller);
                      }),
                ),
                locationController.loading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(),
                Center(
                    child: !locationController.loading
                        ? Image.asset(Images.pinIcon, height: 50, width: 50)
                        : CircularProgressIndicator()),
              ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.blockscreenVertical,
                  horizontal: Dimensions.blockscreenHorizontal * 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            Images.locationIconSvg,
                            width: 20,
                            height: 20,
                            color: Theme.of(context).dividerColor,
                          ),
                          SizedBox(width: 5),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: Dimensions.screenWidth * 0.5),
                            child: Text(
                              locationController.selectedAddress != null
                                  ? locationController.selectedAddress.address
                                  : locationController.getUserAddress().address,
                              maxLines: 1,
                              style: poppinsMedium.copyWith(
                                  fontSize:
                                      Dimensions.blockscreenHorizontal * 3.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "${"address_type".tr}:",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.blockscreenHorizontal * 4,
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                              constraints: BoxConstraints(
                                  maxWidth: Dimensions.screenWidth * 0.5),
                              child: Text(
                                locationController.selectedAddress != null
                                    ? locationController
                                        .selectedAddress.addressType.tr
                                    : locationController
                                        .getUserAddress()
                                        .addressType
                                        .tr,
                                maxLines: 1,
                                style: poppinsRegular.copyWith(
                                    fontSize:
                                        Dimensions.blockscreenHorizontal * 4,
                                    color: Theme.of(context).dividerColor),
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(RouteHelper.getAddressRoute('checkout'));
                    },
                    child: Text("change".tr,
                        maxLines: 1,
                        style: poppinsMedium.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 3.5,
                            color: Theme.of(context).primaryColor)),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
