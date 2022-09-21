import '/util/images.dart';

String getSubCategoryImage(String name) {
  String imagePath = "";

  if (name == "منتجات الالبان" || name == "Dairy milks") {
    imagePath = Images.milkImage;
  } else if (name == "ايس كريم" || name == "Ice cream") {
    imagePath = Images.iceCreamImage;
  } else {
    imagePath = Images.breakFastImage;
  }

  return imagePath;
}
