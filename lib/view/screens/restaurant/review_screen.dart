import '/controller/restaurant_controller.dart';
import '/data/model/response/review_model.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/no_data_screen.dart';
import '/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  final String restaurantID;
  final String restaurantName;
  ReviewScreen({@required this.restaurantID, @required this.restaurantName});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>()
        .getRestaurantReviewList(widget.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: 'restaurant_reviews'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return restController.restaurantReviewList != null
            ? restController.restaurantReviewList.length == 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await restController
                          .getRestaurantReviewList(widget.restaurantID);
                    },
                    child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: ListView.builder(
                          itemCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          itemBuilder: (context, index) {
                            return ReviewWidget(
                              resturantName: widget.restaurantName,
                              review: ReviewModel(
                                  id: 1,
                                  comment: "super crazy restaurant",
                                  createdAt: "Mon,2022",
                                  customerName: "Moaid Mohamed",
                                  foodName: "Magnum Fried chicken",
                                  rating: 3,
                                  foodImage: ""),
                              hasDivider: true,
                            );
                          },
                        )),
                  )
                : Center(child: NoDataScreen(text: 'no_review_found'.tr))
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
