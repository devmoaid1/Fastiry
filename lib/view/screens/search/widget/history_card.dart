import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';

class HistoryCard extends StatelessWidget {
  final SearchController searchController;
  final int index;
  const HistoryCard(
      {Key key, @required this.index, @required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.blockscreenVertical),
      child: Column(children: [
        Row(children: [
          SvgPicture.asset(
            Images.historyIcon,
            color: Theme.of(context).dividerColor,
            width: Dimensions.blockscreenHorizontal * 5,
            height: Dimensions.blockscreenHorizontal * 5,
          ),
          SizedBox(
            width: Dimensions.blockscreenHorizontal * 2,
          ),
          Expanded(
            child: InkWell(
              onTap: () => searchController
                  .searchData(searchController.historyList[index]),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Text(
                  searchController.historyList[index],
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 4,
                      color: Theme.of(context).dividerColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => searchController.removeHistory(index),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Icon(Icons.close,
                  color: Theme.of(context).disabledColor, size: 20),
            ),
          )
        ]),
        // index != searchController.historyList.length - 1 ? Divider() : SizedBox(),
      ]),
    );
  }
}
