import '/controller/location_controller.dart';
import '/data/model/response/address_model.dart';
import '/helper/responsive_helper.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;
  final int index;
  final LocationController locationController;

  AddressWidget(
      {@required this.address,
      @required this.fromAddress,
      this.onRemovePressed,
      this.onEditPressed,
      this.onTap,
      this.index = 0,
      this.locationController,
      this.fromCheckout = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                  ? Dimensions.PADDING_SIZE_DEFAULT
                  : Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(children: [
                Image.asset(
                  Images.pinIcon,
                  width: Dimensions.blockscreenVertical * 5,
                  height: Dimensions.blockscreenVertical * 5,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${address.addressType.tr} (${address.address}) ",
                          style: Get.find<FontStyles>()
                              .poppinsMedium
                              .copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text(
                          "${address.road} , ${address.house} , ${address.floor}",
                          style: Get.find<FontStyles>().poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${address.contactPersonName}",
                          style: Get.find<FontStyles>().poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              "Mobile Number:",
                              style: Get.find<FontStyles>()
                                  .poppinsRegular
                                  .copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${address.contactPersonNumber}",
                              style: Get.find<FontStyles>()
                                  .poppinsRegular
                                  .copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).disabledColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ]),
                ),
                // fromAddress ? IconButton(
                //   icon: Icon(Icons.edit, color: Colors.blue, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
                //   onPressed: onEditPressed,
                // ) : SizedBox(),
                fromAddress
                    ? InkWell(
                        onTap: onRemovePressed,
                        child: SvgPicture.asset(Images.trashIcon,
                            width: 20,
                            height: 20,
                            color: Theme.of(context).primaryColor),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                fromAddress
                    ? InkWell(
                        onTap: onEditPressed,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).dividerColor,
                          size: 23,
                        ),
                      )
                    : fromCheckout &&
                            locationController.selectedAddressIndex == index
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: Dimensions.blockscreenVertical * 4.5,
                          )
                        : SizedBox(),
              ]),
            ),
          ),
          Divider(
            color: Theme.of(context).disabledColor.withOpacity(0.6),
            thickness: 0.7,
          )
        ],
      ),
    );
  }
}
