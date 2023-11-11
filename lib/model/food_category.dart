// To parse this JSON data, do
//
//     final foodCategory = foodCategoryFromJson(jsonString);

import 'dart:convert';

List<FoodCategory> foodCategoryFromJson(String str) => List<FoodCategory>.from(json.decode(str).map((x) => FoodCategory.fromJson(x)));

String foodCategoryToJson(List<FoodCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodCategory {
  FoodCategory({
    required this.foodcategory,
    required this.foodposcat,
  });

  String foodcategory;
  String foodposcat;

  factory FoodCategory.fromJson(Map<String, dynamic> json) => FoodCategory(
    foodcategory: json["foodcategory"],
    foodposcat: json["foodposcat"],
  );

  Map<String, dynamic> toJson() => {
    "foodcategory": foodcategory,
    "foodposcat": foodposcat,
  };
}
