import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;
  AddressWidget(
      {@required this.address,
      @required this.fromAddress,
      this.onRemovePressed,
      this.onEditPressed,
      this.onTap,
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
                  width: 25,
                  height: 25,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${address.addressType.tr} (${address.address}) ",
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text(
                          "${address.road} , ${address.house} , ${address.floor}",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${address.contactPersonName}",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              "Mobile Number:",
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).disabledColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${address.contactPersonNumber}",
                              style: poppinsRegular.copyWith(
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
