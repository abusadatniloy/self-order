// To parse this JSON data, do
//
//     final checkCart = checkCartFromJson(jsonString);

import 'dart:convert';

List<CheckCartModel> checkCartFromJson(String str) => List<CheckCartModel>.from(json.decode(str).map((x) => CheckCartModel.fromJson(x)));

String checkCartToJson(List<CheckCartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckCartModel {
  String id;
  String userId;
  String cartId;
  String tableNo;
  String person;
  String resId;
  String foodId;
  String foodName;
  String foodQuantity;
  String foodPrice;
  String foodTprice;
  String foodVariation;
  String kotActive;
  String add_on;

  CheckCartModel({
    required this.id,
    required this.userId,
    required this.cartId,
    required this.tableNo,
    required this.person,
    required this.resId,
    required this.foodId,
    required this.foodName,
    required this.foodQuantity,
    required this.foodPrice,
    required this.foodTprice,
    required this.foodVariation,
    required this.kotActive,
    required this.add_on,
  });

  factory CheckCartModel.fromJson(Map<String, dynamic> json) => CheckCartModel(
    id: json["id"],
    userId: json["user_id"],
    cartId: json["cart_id"],
    tableNo: json["table_no"],
    person: json["person"],
    resId: json["res_id"],
    foodId: json["food_id"],
    foodName: json["food_name"],
    foodQuantity: json["food_quantity"],
    foodPrice: json["food_price"],
    foodTprice: json["food_tprice"],
    foodVariation: json["food_variation"],
    kotActive: json["kot_active"],
    add_on: json["add_on"] ?? "",

  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "user_id": userId,
  "cart_id": cartId,
  "table_no": tableNo,
  "person": person,
  "res_id": resId,
  "food_id": foodId,
  "food_name": foodName,
  "food_quantity": foodQuantity,
  "food_price": foodPrice,
  "food_tprice": foodTprice,
  "food_variation": foodVariation,
  "kot_active": kotActive,
  "add_on": add_on,

  };
}