import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:equatable/equatable.dart';

import '../restaurant_model.dart';

class WishListModel extends Equatable {
  final List<Product> food;
  final List<Restaurant> restaurant;

  const WishListModel({this.food, this.restaurant});

  factory WishListModel.fromJson(Map<String, dynamic> data) {
    return WishListModel(
      food: (data['food'] as List<Product>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      restaurant: (data['restaurant'] as List<Restaurant>)
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.map((e) => e.toJson()).toList(),
      'restaurant': restaurant.map((e) => e.toJson()).toList(),
    };
  }

  WishListModel copyWith({
    List<Product> food,
    List<Restaurant> restaurant,
  }) {
    return WishListModel(
      food: food ?? this.food,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object> get props => [food, restaurant];
}
