// To parse this JSON data, do
//
//     final fetchAddOneList = fetchAddOneListFromJson(jsonString);

import 'dart:convert';

List<FetchAddOneList> fetchAddOneListFromJson(String str) => List<FetchAddOneList>.from(json.decode(str).map((x) => FetchAddOneList.fromJson(x)));

String fetchAddOneListToJson(List<FetchAddOneList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchAddOneList {
  String addOnId;
  String foodId;
  String addOnName;
  String price;
  DateTime createdAt;

  FetchAddOneList({
    required this.addOnId,
    required this.foodId,
    required this.addOnName,
    required this.price,
    required this.createdAt,
  });

  factory FetchAddOneList.fromJson(Map<String, dynamic> json) => FetchAddOneList(
    addOnId: json["add_on_id"],
    foodId: json["food_id"],
    addOnName: json["add_on_name"],
    price: json["price"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "add_on_id": addOnId,
    "food_id": foodId,
    "add_on_name": addOnName,
    "price": price,
    "created_at": createdAt.toIso8601String(),
  };
}
