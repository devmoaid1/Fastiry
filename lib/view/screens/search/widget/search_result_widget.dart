import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/theme/font_styles.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/search/widget/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  SearchResultWidget({@required this.searchText});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: Dimensions.blockscreenVertical * 2,
      ),
      Container(
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).backgroundColor,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: Get.find<FontStyles>().poppinsRegular.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: Dimensions.fontSizeSmall),
          labelStyle: Get.find<FontStyles>().poppinsBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).primaryColor),
          tabs: [
            Tab(text: 'food'.tr),
            Tab(text: 'Restaurants'.tr),
          ],
        ),
      ),
      Expanded(
          child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<SearchController>()
                .setRestaurant(_tabController.index == 1);
            Get.find<SearchController>().searchData(widget.searchText);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            ItemView(isRestaurant: false),
            ItemView(isRestaurant: true),
          ],
        ),
      )),
    ]);
  }
}
