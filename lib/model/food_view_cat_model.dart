// To parse this JSON data, do
//
//     final foodViewCatModel = foodViewCatModelFromJson(jsonString);

import 'dart:convert';

List<FoodViewCatModel> foodViewCatModelFromJson(String str) => List<FoodViewCatModel>.from(json.decode(str).map((x) => FoodViewCatModel.fromJson(x)));

String foodViewCatModelToJson(List<FoodViewCatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodViewCatModel {
  String foodId;
  String foodName;
  String resId;
  String resName;
  String foodPrice;
  String foodCategory;
  String foodPhoto;
  String foodDetail;
  String foodVariation;
  String foodDiscount;
  String foodCoupon;
  String foodRating;
  int foodActive;

  FoodViewCatModel({
    required this.foodId,
    required this.foodName,
    required this.resId,
    required this.resName,
    required this.foodPrice,
    required this.foodCategory,
    required this.foodPhoto,
    required this.foodDetail,
    required this.foodVariation,
    required this.foodDiscount,
    required this.foodCoupon,
    required this.foodRating,
    required this.foodActive,
  });

  factory FoodViewCatModel.fromJson(Map<String, dynamic> json) => FoodViewCatModel(
    foodId: json["food_id"],
    foodName: json["food_name"],
    resId: json["res_id"],
    resName: json["res_name"],
    foodPrice: json["food_price"],
    foodCategory: json["food_category"],
    foodPhoto: json["food_photo"],
    foodDetail: json["food_detail"],
    foodVariation: json["food_variation"],
    foodDiscount: json["food_discount"],
    foodCoupon: json["food_coupon"],
    foodRating: json["food_rating"],
    foodActive: json["food_active"],
  );

  Map<String, dynamic> toJson() => {
    "food_id": foodId,
    "food_name": foodName,
    "res_id": resId,
    "res_name": resName,
    "food_price": foodPrice,
    "food_category": foodCategory,
    "food_photo": foodPhoto,
    "food_detail": foodDetail,
    "food_variation": foodVariation,
    "food_discount": foodDiscount,
    "food_coupon": foodCoupon,
    "food_rating": foodRating,
    "food_active": foodActive,
  };
}
