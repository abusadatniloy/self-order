import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:japanes_res/controller/api.dart';

import '../controller/design_controller.dart';
import '../model/check_cart.dart';
import '../model/fetch_add_one_list.dart';
import '../model/food_view_cat_model.dart';

class Food_view_page extends StatefulWidget {

  Food_view_page({required this.catergory});
  String catergory;

  @override
  State<Food_view_page> createState() => _Food_view_pageState();
}

enum Name_status { Data1, Data2,Data3}

class _Food_view_pageState extends State<Food_view_page> {

  String name= "Data1";


  Name_status ? namestatus = Name_status.Data1;

  String api = API_Names().api;
  late Future<List<FoodViewCatModel>> food_view;
  Future<List<FoodViewCatModel>> find_food() async{
    var response = await http.get(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/food/read_categorywise_all_food.php?res_id=216464&food_category=${widget.catergory}"));
    // print("http://$api/ordertake_api/ordertake/ordertake_app/food/read_categorywise_all_food.php?res_id=216464&food_category=${widget.catergory}");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<FoodViewCatModel>((json) => FoodViewCatModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch Data');
    }

  }

  late Future<List<CheckCartModel>> checkCart;
  // Future<List<CheckCartModel>> find_from_cart() async{
  //   var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/show_cart_kot_active.php"),
  //     body:jsonEncode(<String,String>{
  //       "res_id": "216464",
  //       "table_no": "5"
  //     }),
  //   );
  //   print(response.body);
  //   // print("http://$api/ordertake_api/ordertake/ordertake_app/food/read_categorywise_all_food.php?res_id=216464&food_category=${widget.catergory}");
  //
  //   if (response.statusCode == 200) {
  //     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
  //
  //     return parsed
  //         .map<CheckCartModel>((json) => CheckCartModel.fromJson(json))
  //         .toList();
  //
  //     double totalPrice = cartModels.fold<double>(0, (total, cartModel) {
  //       return total + (double.tryParse(cartModel.food_tprice) ?? 0.0);
  //     });
  //
  //   } else {
  //     throw Exception('Failed to fetch Data');
  //   }
  //
  //
  //
  // }

  double totalPrice = 0.0;
  Future<List<CheckCartModel>> find_from_cart() async {
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/show_cart_kot_active.php"),
      body: jsonEncode(<String, String>{
        "res_id": "216464",
        "table_no": "5"
      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      // Create a list of CheckCartModel objects
      final List<CheckCartModel> cartModels = parsed
          .map<CheckCartModel>((json) => CheckCartModel.fromJson(json))
          .toList();

      // Calculate the sum of food_tprice values
      totalPrice = cartModels.fold<double>(0, (total, cartModel) {
        return total + (double.tryParse(cartModel.foodTprice) ?? 0.0);
      });

      print('Total Price: $totalPrice');

      return cartModels;
    } else {
      throw Exception('Failed to fetch Data');
    }
  }



  Color_Controller color_controller = Color_Controller();
  Size_Controller size_controller = Size_Controller();


  String selectedValue = 'Language';
  // The initially selected value
  List<String> options = ['Language','English', 'Bangla', 'Japanese'];

  print_kot()async{
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_to_kot.php"),
      body:jsonEncode(<String,String>{
        "res_id": "216464",
        "table_no": "5"
      }),
    );
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){

      final snackBar = SnackBar(
        content: const Text('Added to KOT'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }else{
      final snackBar = SnackBar(
        content: const Text('KOT not added'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    _refreshData();

  }


  print_bill()async{
    var response = await http.post(
        Uri.parse(
            'http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_to_bill.php'),
        body: jsonEncode(<String, String>{
          "table_no": "5",
          "res_id":"216464",
          "total_bill": "$totalPrice",
          "bill_active": "On Counter",
        }
        )
    );
    print(response.body);
    Navigator.pop(context);
    _refreshData();
  }


  add_to_cart(
      String food_id,
      String food_name,
      String food_quantity,
      String food_price,
      String food_tprice,
      String food_variation) async {
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_create.php"),
      body:jsonEncode(<String,String>{
        "user_id":"216464",
        "cart_id":"123321",
        "table_no":"5",
        "person":"xyz",
        "res_id":"216464",
        "food_id":food_id,
        "food_name":food_name,
        "food_quantity":food_quantity,
        "food_price":food_price,
        "food_tprice":food_tprice,
        "food_variation":food_variation,
        "kot_active":"1",
        "kot_status":"Cooking"
      }),
    );
    print(response.body);

    if(response.statusCode == 201){
      final snackBar = SnackBar(
        content: const Text('Product added'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }else{
      final snackBar = SnackBar(
        content: const Text('Product not added'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    _refreshData();

  }

  quantity_update(String food_id, int quantity) async {
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_update.php?user_id=216464&res_id=216464&food_id=$food_id&table_no=5"),
      body:jsonEncode(<String,String>{
        "food_quantity":quantity.toString(),
        "food_tprice":"$total_product_price"
      }),
    );
    print(response.body);
    _refreshData();
  }


  deleteproduct(String food_id)async{
    var response = await http.get(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_delete_onefood.php?user_id=216464&res_id=216464&food_id=$food_id&table_no=5"));
    print(response.body);
    _refreshData();
    //print("http://$api/ordertake_api/ordertake/ordertake_app/cart/cart_delete_onefood.php?user_id=${widget.loginModel.uId}&res_id=1100&food_id=$food_id&table_no=${dropdownValue}");
  }

  StreamController _event = StreamController<int>.broadcast();
  int total_product_price = 0;
  int unit_price = 0;
  int _counter = 1;
  _incrementCounter(double food_price) {
    setState(() {
      unit_price = food_price~/_counter;
      print("Unit");
      print(unit_price);
      _counter++;
      total_product_price = _counter * unit_price;
    });

    _event.add(_counter);
    print("${_counter}");
  }

  _decrementCounter(String food_id, int food_price) {
    if(_counter==0){
      setState(() {
        deleteproduct(food_id);
      });

    }
    else {
      setState(() {
        unit_price= food_price~/_counter;
        _counter--;
        total_product_price = _counter * unit_price;
      });
    }
    _event.add(_counter);
  }

  List<dynamic> _counter_refresh = <dynamic>[];

  void _refreshData() async {
    print("refresh data");
    final data = await find_from_cart();
    setState(() {
      _counter_refresh = data;
    });
  }

  bool cart_status = true;

  TextEditingController noteController = TextEditingController();
  TextEditingController totalPersonediting = TextEditingController();

  updatenote(String table_no, String food_id)async{
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/noteupdate.php"),
      body:jsonEncode(<String,String>{
        "table_no":table_no,
        "food_id":"$food_id",
        "note": noteController.text
      }),
    );
    print(response.body);
  }

  updateAddons(String table_no, String food_id,String addons,String add_on_price)async{
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/addonsupdate.php"),
      body:jsonEncode(<String,String>{
        "table_no":table_no,
        "food_id":"$food_id",
        "addons": addons,
        "add_on_price": add_on_price
      }),
    );
    print(response.body);

    _refreshData();
  }


  late Future<List<FetchAddOneList>> fetch_add_ons_data;
  // Future<List<FetchAddOneList>> fetch_addones(String food_id) async {
  //   var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/add_ones_list.php"),
  //     body: jsonEncode(<String, String>{
  //       "res_id": "216464",
  //       "food_id": food_id
  //     }),
  //   );
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
  //
  //     // Create a list of CheckCartModel objects
  //     final List<FetchAddOneList> addonModels = parsed
  //         .map<FetchAddOneList>((json) => FetchAddOneList.fromJson(json))
  //         .toList();
  //
  //     return addonModels;
  //   } else {
  //     throw Exception('Failed to fetch Data');
  //   }
  // }

  Future<List<FetchAddOneList>> fetch_addones(String food_id) async{
    print(food_id);
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/add_ones_list.php"),
      body: jsonEncode(<String, String>{
        "res_id": "216464",
        "food_id": food_id
      }),
    );
    print(response.body);
    // print("http://$api/ordertake_api/ordertake/ordertake_app/food/read_categorywise_all_food.php?res_id=216464&food_category=${widget.catergory}");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<FetchAddOneList>((json) => FetchAddOneList.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch Data');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    food_view = find_food();
    find_food();
    checkCart = find_from_cart();
    find_from_cart();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: Row(

          children: [
            SizedBox(width: 50,),
            GestureDetector(

              onTap: ()async{

                var response = await http.post(Uri.parse("http://103.150.48.234:2164/japan/ordertake_api/ordertake/small_api/user_calling_staff.php"),
                  body:jsonEncode(<String,String>{
                    "table_number":"5"
                  }),
                );

                print(response.body);

              },

              child: Container(
                height: 70,
                width: 200,
                color: color_controller.theme_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications,
                      color: color_controller.white,
                    ),
                    Text("Call Staff",
                      style: TextStyle(
                          fontSize: size_controller.text20,
                          color: color_controller.white
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(
              height: 70,
              width: 200,
              color: color_controller.theme_color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language,
                    color: color_controller.white,
                  ),
                  SizedBox(width: 10,),
                  Center(
                    child: DropdownButton<String>(
                      dropdownColor: color_controller.theme_color,
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                            style: TextStyle(
                                fontSize: size_controller.text20,
                                color: color_controller.white
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
            child: Row(
              children: [
                Container(
                  height: size.height,
                  width: size.width / 1.8,
                  padding: EdgeInsets.all(20),
                  child: FutureBuilder<List<FoodViewCatModel>>(
                    future: food_view,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        return  GridView.count(
                          // physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: .9,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            // Number of columns in the grid
                            children: List.generate(snapshot.data!.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 2),
                                child: GestureDetector(
                                  onTap: (){
                                    add_to_cart(
                                        snapshot.data![index].foodId,
                                        snapshot.data![index].foodName,
                                        // _counter[index].toString(),
                                        1.toString(),
                                        snapshot.data![index].foodPrice,
                                        // (int.parse(snapshot.data![index].foodPrice)*(_counter[index])).toString(),
                                        (snapshot.data![index].foodPrice).toString(),
                                        snapshot.data![index].foodCategory
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 200,
                                            width: MediaQuery.of(context).size.width,
                                            //color: Colors.lightBlue,
                                            child: Column(

                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      height:100,
                                                      width: 110,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Image(
                                                          fit:BoxFit.cover,
                                                          // height: size.height / 35,
                                                          image: NetworkImage("http://$api/ordertake_api/ordertake/ordertake_app/asset/food/${snapshot.data![index].foodPhoto}"),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 190,
                                                          child: Text('${snapshot.data![index].foodName}',
                                                            style: TextStyle(
                                                              fontSize: 20, // Set the font size to 25
                                                              fontWeight: FontWeight.bold, // Make the text bold
                                                              // Set the text color to red
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${snapshot.data![index].foodPrice} Tk',

                                                          style: TextStyle(
                                                            fontSize: 19, // Set the font size to 25
                                                            fontWeight: FontWeight.bold, // Make the text bold
                                                            color: Colors.red, // Set the text color to red
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),

                                          actions: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height:150,
                                              color: Color(0xffffec8b),
                                              child: Column(
                                                children: [

                                                  TextField(
                                                    controller: noteController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Note',
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    onChanged: (text) {
                                                      // Handle text input changes here
                                                      print('Input Text: $text');
                                                    },
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                    children: [
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                                          minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)), // Define the button size
                                                          //fixedSize: MaterialStateProperty.all<Size>(Size(150, 40)),// Change the button background color
                                                        ),
                                                        child: Text('Cancel',
                                                          style: TextStyle(
                                                              fontSize: size_controller.text15,
                                                              color: color_controller.white
                                                          ),
                                                        ),
                                                        onPressed: () {

                                                          // print_kot();
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              _decrementCounter(snapshot.data![index].foodId, int.parse(snapshot.data![index].foodPrice));
                                                              print(_counter);
                                                              if(_counter==0){
                                                                deleteproduct(snapshot.data![index].foodId);
                                                              }
                                                              quantity_update(snapshot.data![index].foodId, _counter);
                                                            },
                                                            icon: Icon(
                                                              Icons.remove,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${_counter}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              // color: Color(0xffF7A037),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              _incrementCounter(double.parse(snapshot.data![index].foodPrice));
                                                              quantity_update(snapshot.data![index].foodId, _counter);
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                            ),
                                                          ),

                                                        ],
                                                      ),

                                                      TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(color_controller.theme_color),
                                                          minimumSize: MaterialStateProperty.all<Size>(Size(120, 80)), // Define the button size
                                                          //fixedSize: MaterialStateProperty.all<Size>(Size(150, 40)),// Change the button background color
                                                        ),
                                                        child: Text('Add to Cart',
                                                          style: TextStyle(
                                                              fontSize: size_controller.text15,
                                                              color: color_controller.white
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          updatenote('5','${snapshot.data![index].foodId}');
                                                          // print_kot();
                                                          Navigator.of(context).pop(); // Close the dialog
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: Color(0xffe4e9ed),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Image(
                                            fit:BoxFit.cover,
                                            // height: size.height / 35,
                                            image: NetworkImage("http://$api/ordertake_api/ordertake/ordertake_app/asset/food/${snapshot.data![index].foodPhoto}"),
                                          ),
                                        ),
                                        // Icon(Icons.local_pizza, color: Color(0xffF7A037),),
                                        Text(
                                          '${snapshot.data![index].foodName}',
                                          style: TextStyle(
                                            fontSize: size_controller.text18,
                                            // color: Color(0xffF7A037),
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data![index].foodPrice} TK ',
                                          style: TextStyle(
                                            fontSize: size_controller.text18,
                                            // color: Color(0xffF7A037),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        );
                      }

                      else {
                        return Text('An Error Occurred',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                      }
                    },
                  ),
                ),


                Expanded(
                  child: Container(

                    width: size.width / 2.5,

                    color: Color(0xff043b5c),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:5 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Status : ",
                                style:
                                TextStyle(fontSize: 25, color: Colors.white),
                              ),
                              Text(
                                "#90345",
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:5 ),
                          child: SizedBox(
                            height: size.height / 1.9,
                            child: FutureBuilder<List<CheckCartModel>>(
                              future: find_from_cart(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return  ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Card(
                                          // shape: const StadiumBorder(),
                                          elevation: 3,
                                          color: Colors.white,
                                          shadowColor: Color(0xffF7A037).withOpacity(0.5),
                                          child:  Container(
                                            height: 210,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height:50,
                                                          width: 60,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(3.0),
                                                            child: Image(
                                                              fit:BoxFit.cover,
                                                              // height: size.height / 35,
                                                              image: NetworkImage("http://$api/ordertake_api/ordertake/images/cat_kebab.jpg"),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 200,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                '${snapshot.data![index].foodName}',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold
                                                                  // color: Color(0xffF7A037),
                                                                ),
                                                              ),
                                                              Text(
                                                                "Add Ons:  ${snapshot.data![index].add_on}",
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold
                                                                  // color: Color(0xffF7A037),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        if(cart_status == false)...[

                                                        ]else...[
                                                          IconButton(
                                                              onPressed: (){
                                                                deleteproduct(snapshot.data![index].foodId);
                                                              },
                                                              icon: Icon(Icons.delete,
                                                                color: Colors.red,
                                                              )
                                                          ),
                                                        ]

                                                      ],
                                                    ),

                                                    SizedBox(height: 18,),


                                                    Row(

                                                      children: [
                                                        Icon(
                                                          Icons.soup_kitchen,
                                                          color:Color(0xffFF6347),
                                                        ),
                                                        SizedBox(width: 20,),
                                                        Container(
                                                          height: 25,
                                                          width: 70,
                                                          alignment: Alignment.center,
                                                          color: Color(0xffFF6347), // Set the background color to tomato
                                                          child: Text(
                                                            cart_status ? 'On Cart' : 'Preparing',
                                                            // snapshot.data![index].kotActive == 0
                                                            //     ? 'Ordered'
                                                            //     : snapshot.data![index].kotActive == 1
                                                            //     ? 'Preparing'
                                                            //     : 'Served',
                                                            // snapshot.data![index].kotActive == 0 ? 'Served' : 'On Cart',
                                                            //textAlign: TextAlign.center,

                                                            style: TextStyle(
                                                              color: Colors.white, // Set the text color to white
                                                              // You can customize other text styles as needed.
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(width: 50),

                                                        GestureDetector(
                                                          onTap: (){
                                                            fetch_addones(snapshot.data![index].foodId);
                                                            fetch_add_ons_data = fetch_addones(snapshot.data![index].foodId);
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Add Ons'),
                                                                  content: Container(
                                                                    height: 500,
                                                                    width: 500,
                                                                    child: FutureBuilder<List<FetchAddOneList>>(
                                                                      future: fetch_add_ons_data,
                                                                      builder: (context, snapshot) {
                                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                                          return Center(
                                                                            child: CircularProgressIndicator(),
                                                                          );
                                                                        }
                                                                        if (snapshot.hasData) {
                                                                          return  ListView.builder(
                                                                              physics: ClampingScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.vertical,
                                                                              itemCount: snapshot.data!.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                return GestureDetector(
                                                                                  onTap: (){
                                                                                    updateAddons('5','${snapshot.data![index].foodId}', '${snapshot.data![index].addOnName}', '${snapshot.data![index].price}');
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Card(
                                                                                    // shape: const StadiumBorder(),
                                                                                    elevation: 3,
                                                                                    color: Colors.white,
                                                                                    shadowColor: Color(0xffF7A037).withOpacity(0.5),
                                                                                    child:  Container(
                                                                                      width: 200,
                                                                                      child: Text(
                                                                                        '${snapshot.data![index].addOnName}    Price:  ${snapshot.data![index].price}',
                                                                                        style: TextStyle(
                                                                                            fontSize: 18,
                                                                                            fontWeight: FontWeight.bold
                                                                                          // color: Color(0xffF7A037),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }

                                                                          );
                                                                        }

                                                                        else {
                                                                          return Text('An Error Occurred',
                                                                            style: TextStyle(
                                                                              fontSize: 20,
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                  // actions: <Widget>[
                                                                  //   TextButton(
                                                                  //     onPressed: () {
                                                                  //       // Close the dialog
                                                                  //       Navigator.of(context).pop();
                                                                  //     },
                                                                  //     child: Text('Close'),
                                                                  //   ),
                                                                  // ],
                                                                );
                                                              },
                                                            );


                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 70,
                                                            alignment: Alignment.center,
                                                            color: Color(0xffFF6347), // Set the background color to tomato
                                                            child: Text("Add On",
                                                              style: TextStyle(
                                                                color: Colors.white, // Set the text color to white
                                                                // You can customize other text styles as needed.
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(width: 50),

                                                        Column(
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                _decrementCounter(snapshot.data![index].foodId, int.parse(snapshot.data![index].foodPrice));
                                                                print(_counter);
                                                                if(_counter==0){
                                                                  deleteproduct(snapshot.data![index].foodId);
                                                                }
                                                                quantity_update(snapshot.data![index].foodId, _counter);
                                                                _refreshData();
                                                              },
                                                              icon: Icon(
                                                                Icons.remove,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${snapshot.data![index].foodPrice} * ${snapshot.data![index].foodQuantity}",

                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold
                                                                // color: Color(0xffF7A037),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                _incrementCounter(double.parse(snapshot.data![index].foodPrice));
                                                                quantity_update(snapshot.data![index].foodId, _counter);
                                                                _refreshData();
                                                              },
                                                              icon: Icon(
                                                                Icons.add,
                                                              ),
                                                            ),

                                                          ],
                                                        ),

                                                        // Text(
                                                        //   "${snapshot.data![index].foodPrice} * ${snapshot.data![index].foodQuantity}",
                                                        //
                                                        //   style: TextStyle(
                                                        //       fontSize: 16,
                                                        //       fontWeight: FontWeight.bold
                                                        //     // color: Color(0xffF7A037),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                                // SizedBox(
                                                //   width: size.width / 70,
                                                // ),


                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                  );
                                }

                                else {
                                  return Text('An Error Occurred',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:5 ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total (With Tax)",

                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "$totalPrice Tk",

                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),

                                ],
                              ),
                              Divider(thickness: 2,color: Colors.white,),
                              Text(
                                "Sales tax",

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "0",

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),



                            ],
                          ),
                        ),
                        SizedBox(height: 30,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context, void Function(void Function()) setState) {
                                          return AlertDialog(
                                            title: const Text("Warning"),
                                            content: Card(
                                              elevation: 5,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(
                                                      'General Bill',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    leading: Radio<Name_status>(
                                                      value: Name_status.Data1,
                                                      groupValue: namestatus,
                                                      onChanged: (Name_status? value) {
                                                        setState(() {
                                                          namestatus = value;
                                                          name = "General Bill";
                                                          print("aaaaaa:$name");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      'Split Equal',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    leading: Radio<Name_status>(
                                                      value: Name_status.Data2,
                                                      groupValue: namestatus,
                                                      onChanged: (Name_status? value) {
                                                        setState(() {
                                                          namestatus = value;
                                                          name = "Split Equal";
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      'Split as Person',
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    leading: Radio<Name_status>(
                                                      value: Name_status.Data3,
                                                      groupValue: namestatus,
                                                      onChanged: (Name_status? value) {
                                                        setState(() {
                                                          namestatus = value;
                                                          name = "Split as Person";
                                                          print("aaaaaa:$name");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      print(name);
                                                      if (name == "General Bill") {
                                                        // Placeholder for the print_bill() function
                                                        // Replace this with the actual implementation
                                                        print_bill();
                                                      } else if (name == "Split Equal") {
                                                        Future.delayed(Duration(milliseconds: 100), () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Equal Split"),
                                                                content: TextField(
                                                                  controller: totalPersonediting,
                                                                  decoration: InputDecoration(
                                                                    labelText: 'Enter Total Person',
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                  onChanged: (text) {
                                                                    // Handle text input changes here
                                                                    // print('Input Text: $text');
                                                                  },
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed: () {

                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Bill"),
                                                                            content: Text("Everyone's Bill is${totalPrice / int.parse(totalPersonediting.text)}"
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                  Navigator.of(context).pop();

                                                                                },
                                                                                child: Text("Ok"),
                                                                              ),


                                                                            ],
                                                                            scrollable: true,
                                                                          );
                                                                        },
                                                                      );

                                                                    },
                                                                    child: Text("Ok"),
                                                                  ),


                                                                ],
                                                                scrollable: true,
                                                              );
                                                            },
                                                          );
                                                        });
                                                      } else {
                                                        // Handle other cases here
                                                        Future.delayed(Duration(milliseconds: 100), () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Equal Split"),
                                                                content: TextField(
                                                                  controller: totalPersonediting,
                                                                  decoration: InputDecoration(
                                                                    labelText: 'Enter Total Person',
                                                                    border: OutlineInputBorder(),
                                                                  ),
                                                                  onChanged: (text) {
                                                                    // Handle text input changes here
                                                                    // print('Input Text: $text');
                                                                  },
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed: () {
                                                                      find_from_cart();

                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return AlertDialog(
                                                                            title: const Text("Bill"),
                                                                            content: Container(
                                                                              height: 500,
                                                                              width: 500,
                                                                              child: FutureBuilder<List<CheckCartModel>>(
                                                                                future: find_from_cart(),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                    return Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    );
                                                                                  }
                                                                                  if (snapshot.hasData) {
                                                                                    return  ListView.builder(
                                                                                        physics: ClampingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: snapshot.data!.length,
                                                                                        itemBuilder: (BuildContext context, int index) {
                                                                                          return Card(
                                                                                            // shape: const StadiumBorder(),
                                                                                            elevation: 3,
                                                                                            color: Colors.white,
                                                                                            shadowColor: Color(0xffF7A037).withOpacity(0.5),
                                                                                            child:  Container(
                                                                                              height: 210,
                                                                                              child: Text(
                                                                                                '${snapshot.data![index].foodName}',
                                                                                                style: TextStyle(
                                                                                                    fontSize: 18,
                                                                                                    fontWeight: FontWeight.bold
                                                                                                  // color: Color(0xffF7A037),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }

                                                                                    );
                                                                                  }

                                                                                  else {
                                                                                    return Text('An Error Occurred',
                                                                                      style: TextStyle(
                                                                                        fontSize: 20,
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                  Navigator.of(context).pop();

                                                                                },
                                                                                child: Text("Ok"),
                                                                              ),


                                                                            ],
                                                                            scrollable: true,
                                                                          );
                                                                        },
                                                                      );

                                                                    },
                                                                    child: Text("Ok"),
                                                                  ),


                                                                ],
                                                                scrollable: true,
                                                              );
                                                            },
                                                          );
                                                        });
                                                      }

                                                      // You can add your Ok button functionality here
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text("Ok"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            scrollable: true,
                                          );
                                        },
                                      );
                                    },
                                  );


                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return StatefulBuilder(
                                  //         builder: (BuildContext context, void Function(void Function()) setState) {
                                  //           return AlertDialog(
                                  //             title: const Text("Warning"),
                                  //             content:  Card(
                                  //               elevation: 5,
                                  //               child: Column(
                                  //                 children: [
                                  //                   ListTile(
                                  //                     title: Text(
                                  //                       'Data1',
                                  //                       style:TextStyle(
                                  //                         fontSize: 22.0,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                     ),
                                  //                     leading: Radio<Name_status >(
                                  //                       value: Name_status .Data1,
                                  //                       groupValue: namestatus ,
                                  //                       onChanged: (Name_status? value) {
                                  //                         setState(() {
                                  //                           namestatus = value;
                                  //                           name = "Data1";
                                  //                           print("aaaaaa:$name");
                                  //                         });
                                  //                       },
                                  //                     ),
                                  //                   ),
                                  //                   ListTile(
                                  //                     title: Text(
                                  //                       'Data2',
                                  //                       style:TextStyle(
                                  //                         fontSize: 22.0,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                     ),
                                  //                     leading: Radio<Name_status >(
                                  //                       value: Name_status .Data2,
                                  //                       groupValue: namestatus ,
                                  //                       onChanged: (Name_status? value) {
                                  //                         setState(() {
                                  //                           namestatus = value;
                                  //                           name = "Data2";
                                  //
                                  //                         });
                                  //                       },
                                  //                     ),
                                  //                   ),
                                  //                   ListTile(
                                  //                     title: Text(
                                  //                       'Data3',
                                  //                       style:TextStyle(
                                  //                         fontSize: 22.0,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                     ),
                                  //                     leading: Radio<Name_status >(
                                  //                       value: Name_status .Data3,
                                  //                       groupValue: namestatus ,
                                  //                       onChanged: (Name_status? value) {
                                  //                         setState(() {
                                  //                           namestatus = value;
                                  //                           name = "Data3";
                                  //
                                  //                           print("aaaaaa:$name");
                                  //                         });
                                  //                       },
                                  //                     ),
                                  //                   ),
                                  //
                                  //                   ElevatedButton(
                                  //                     onPressed: () {
                                  //                       print(name);
                                  //                       if(name == "Data1"){
                                  //                         print_bill();
                                  //                       }else if(name == "Data2"){
                                  //
                                  //                         showDialog(
                                  //                             context: context,
                                  //                             builder: (BuildContext context) {
                                  //                               return AlertDialog(
                                  //                                 title: const Text("Warning"),
                                  //                                 content: Text("Your Username or Password was not correct"),
                                  //                                 scrollable: true,
                                  //                               );
                                  //                             });
                                  //
                                  //
                                  //                       }
                                  //                       else{
                                  //                         print("object");
                                  //                       }
                                  //
                                  //                       // You can add your Ok button functionality here
                                  //                       Navigator.of(context).pop(); // Close the dialog
                                  //                     },
                                  //                     child: Text("Ok"),
                                  //                   ),
                                  //
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             scrollable: true,
                                  //           );
                                  //         },
                                  //
                                  //       );
                                  //     });

                                  // Place your onPressed logic here
                                  // showCustomAlertDialog(context);


                                  //print_bill();
                                  //

                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  foregroundColor: MaterialStateProperty.all<Color>(Color(0xff043B5C)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0), // Set the border radius here
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Generate Bill',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold/// Adjust the font size as needed
                                  ),
                                ),
                                ),
                            ElevatedButton(
                              onPressed: () {
                                // Place your onPressed logic here

                                setState(() {
                                  cart_status = false;
                                });
                                print_kot();

                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                foregroundColor: MaterialStateProperty.all<Color>(Color(0xff043B5C)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0), // Set the border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                'Place Order',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold// Adjust the font size as needed
                                ),
                              ),
                            ),
                          ],
                        ),


                        // Container(
                        //   padding: const EdgeInsets.all(15),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("Items(${sna.length})"),
                        //           Text("${ordered_price.sum} Taka"),
                        //         ],
                        //       ),
                        //       // Row(
                        //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       //   children: [
                        //       //     Text("Vat"),
                        //       //     Text("00.00 Taka"),
                        //       //   ],
                        //       // ),
                        //       // Row(
                        //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       //   children: [
                        //       //     Text("SD"),
                        //       //     Text("00.00 Taka"),
                        //       //   ],
                        //       // ),
                        //       // Row(
                        //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       //   children: [
                        //       //     Text("Discount"),
                        //       //     Text("00.00 Taka"),
                        //       //   ],
                        //       // ),
                        //       SizedBox(height: 20,),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text("Total",style: GoogleFonts.quando(
                        //               color: Color(0xffF7A037),
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold),),
                        //           Text("${ordered_price.sum} Taka",style: GoogleFonts.quando(
                        //               color: Color(0xffF7A037),
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.bold),),
                        //         ],
                        //       ),
                        //       // GestureDetector(
                        //       //   onTap: (){
                        //       //     //print_bill();
                        //       //     print(total_product_price);
                        //       //   },
                        //       //   child: Container(
                        //       //     alignment: Alignment.center,
                        //       //     height: 40.0,
                        //       //     width:135,
                        //       //     // width: MediaQuery.of(context).size.width * 0.5,
                        //       //     decoration: BoxDecoration(
                        //       //       borderRadius: BorderRadius.circular(80.0),
                        //       //       gradient: const LinearGradient(
                        //       //         colors: [
                        //       //           Color.fromARGB(255, 255, 136, 34),
                        //       //           Color.fromARGB(255, 255, 177, 41)
                        //       //         ],
                        //       //       ),
                        //       //     ),
                        //       //     padding: const EdgeInsets.all(0),
                        //       //     child:Text(
                        //       //       "Print Bill",
                        //       //       textAlign: TextAlign.center,
                        //       //       style: TextStyle(
                        //       //           fontSize: 20,
                        //       //           color: Colors.white,
                        //       //           fontWeight: FontWeight.bold
                        //       //       ),
                        //       //     ),
                        //       //
                        //       //   ),
                        //       //
                        //       // ),
                        //       Padding(
                        //         padding: const EdgeInsets.only(left:8.0),
                        //         child: GestureDetector(
                        //           onTap: (){
                        //             // print(ordered_name);
                        //             // print(ordered_price);
                        //             // print(ordered_id);
                        //             // print(_counter);
                        //             // insert_kot() ;
                        //             if(ordered_name.isEmpty){
                        //               showDialog(
                        //                   context: context,
                        //                   builder: (BuildContext context) {
                        //                     return AlertDialog(
                        //                       title: const Text("Warning"),
                        //                       content: Text("Nothing is in order"),
                        //                       scrollable: true,
                        //                     );
                        //                   });
                        //             }else{
                        //               print_kot();
                        //
                        //               // bookedTable(dropdownValue,"1");
                        //               // setState((){
                        //               //   ordered_name.removeRange(0, ordered_name.length);
                        //               //   ordered_price.removeRange(0, ordered_price.length);
                        //               //   ordered_id.removeRange(0, ordered_id.length);
                        //               //   _counter.removeRange(0, _counter.length);
                        //               // });
                        //
                        //             }
                        //
                        //
                        //           },
                        //           child: Container(
                        //             alignment: Alignment.center,
                        //             height: 40.0,
                        //             width:135,
                        //             // width: MediaQuery.of(context).size.width * 0.5,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(80.0),
                        //               gradient: const LinearGradient(
                        //                 colors: [
                        //                   Color.fromARGB(255, 255, 136, 34),
                        //                   Color.fromARGB(255, 255, 177, 41)
                        //                 ],
                        //               ),
                        //             ),
                        //             padding: const EdgeInsets.all(0),
                        //             child:Text(
                        //               "Order",
                        //               textAlign: TextAlign.center,
                        //               style: TextStyle(
                        //                   fontSize: 20,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.bold
                        //               ),
                        //             ),
                        //
                        //           ),
                        //
                        //
                        //
                        //         ),
                        //       ),
                        //
                        //       SizedBox(height: 20,),
                        //
                        //       Padding(
                        //         padding: const EdgeInsets.only(left:8.0),
                        //         child: GestureDetector(
                        //           onTap: (){
                        //             print_bill();
                        //
                        //             setState((){
                        //               ordered_name.removeRange(0, ordered_name.length);
                        //               ordered_price.removeRange(0, ordered_price.length);
                        //               ordered_id.removeRange(0, ordered_id.length);
                        //               _counter.removeRange(0, _counter.length);
                        //             });
                        //
                        //             // showDialog(
                        //             //   context: context,
                        //             //   builder: (BuildContext context) {
                        //             //     return StatefulBuilder(
                        //             //         builder: (context, setState){
                        //             //           return AlertDialog(
                        //             //             shape: RoundedRectangleBorder(
                        //             //               borderRadius: BorderRadius.circular(10.0),
                        //             //             ),
                        //             //             title: Text('Message'),
                        //             //             content: Container(
                        //             //               height: 200,
                        //             //               child: Column(
                        //             //                 children: [
                        //             //                   Card(
                        //             //                     elevation: 5,
                        //             //                     child: ListTile(
                        //             //                       title: Text(
                        //             //                         'Online',
                        //             //                         style: TextStyle(
                        //             //                           fontSize: 22.0,
                        //             //                           color: Colors.black,
                        //             //                         ),
                        //             //                       ),
                        //             //                       leading: Radio<Payment_type_status >(
                        //             //                         value: Payment_type_status.online,
                        //             //                         groupValue: paymentstatus ,
                        //             //                         onChanged: (Payment_type_status? value) {
                        //             //                           setState(() {
                        //             //                             paymentstatus = value;
                        //             //                             paystatus = "Online";
                        //             //                           });
                        //             //                         },
                        //             //                       ),
                        //             //                     ),
                        //             //                   ),
                        //             //
                        //             //                   Card(
                        //             //                     elevation: 5,
                        //             //                     child: ListTile(
                        //             //                       title: Text(
                        //             //                         'On Counter',
                        //             //                         style: TextStyle(
                        //             //                           fontSize: 22.0,
                        //             //                           color: Colors.black,
                        //             //                         ),
                        //             //                       ),
                        //             //                       leading: Radio<Payment_type_status >(
                        //             //                         value: Payment_type_status.oncounter,
                        //             //                         groupValue: paymentstatus ,
                        //             //                         onChanged: (Payment_type_status? value) {
                        //             //                           setState(() {
                        //             //                             paymentstatus = value;
                        //             //                             paystatus = "On Counter";
                        //             //                           });
                        //             //                         },
                        //             //                       ),
                        //             //                     ),
                        //             //                   ),
                        //             //
                        //             //                 ],
                        //             //               ),
                        //             //             ),
                        //             //             actions: [
                        //             //               TextButton(
                        //             //                 style: ButtonStyle(
                        //             //                   backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        //             //                 ),
                        //             //                 child: Text('OK',
                        //             //                   style: TextStyle(
                        //             //                       color: Colors.white
                        //             //                   ),
                        //             //                 ),
                        //             //                 onPressed: () {
                        //             //
                        //             //                   if(paystatus == "On Counter"){
                        //             //                     print_bill();
                        //             //                     // bookedTable("01","0");
                        //             //                     print(total_product_price);
                        //             //                   }else{
                        //             //                     pay_ment(double.parse(ordered_price.sum.toString()));
                        //             //                     print_bill();
                        //             //                   }
                        //             //
                        //             //
                        //             //
                        //             //                   setState((){
                        //             //                     ordered_name.removeRange(0, ordered_name.length);
                        //             //                     ordered_price.removeRange(0, ordered_price.length);
                        //             //                     ordered_id.removeRange(0, ordered_id.length);
                        //             //                     _counter.removeRange(0, _counter.length);
                        //             //                   });
                        //             //                   Navigator.pop(context);
                        //             //                 }
                        //             //               ),
                        //             //             ],
                        //             //           );
                        //             //         }
                        //             //     );
                        //             //   },
                        //             // );
                        //           },
                        //           child: Container(
                        //             alignment: Alignment.center,
                        //             height: 40.0,
                        //             width:135,
                        //             // width: MediaQuery.of(context).size.width * 0.5,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(80.0),
                        //               gradient: const LinearGradient(
                        //                 colors: [
                        //                   Color.fromARGB(255, 255, 136, 34),
                        //                   Color.fromARGB(255, 255, 177, 41)
                        //                 ],
                        //               ),
                        //             ),
                        //             padding: const EdgeInsets.all(0),
                        //             child:Text(
                        //               "Print Bill",
                        //               textAlign: TextAlign.center,
                        //               style: TextStyle(
                        //                   fontSize: 20,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.bold
                        //               ),
                        //             ),
                        //
                        //           ),
                        //
                        //         ),
                        //       ),
                        //
                        //       // Padding(
                        //       //   padding: const EdgeInsets.only(top: 5),
                        //       //   child: GestureDetector(
                        //       //     onTap: (){
                        //       //
                        //       //       showDialog(
                        //       //           context: context,
                        //       //           builder: (BuildContext context) {
                        //       //             return StatefulBuilder(
                        //       //             builder: (context, setState) {
                        //       //               return AlertDialog(
                        //       //                 title: const Text("Switch Table"),
                        //       //                 content: Row(
                        //       //                   children: [
                        //       //                     DropdownButton<String>(
                        //       //                       hint: const Text(
                        //       //                         "Table",
                        //       //                         style: TextStyle(fontWeight: FontWeight.bold),
                        //       //                       ),
                        //       //                       icon: const Icon(Icons.keyboard_arrow_down),
                        //       //                       elevation: 16,
                        //       //                       style: const TextStyle(
                        //       //                           color: Colors.black, fontSize: 15),
                        //       //                       underline: Container(
                        //       //                         height: 2,
                        //       //                         color: Colors.white,
                        //       //                       ),
                        //       //                       items: dropdownListall?.map((item) {
                        //       //                         return DropdownMenuItem<String>(
                        //       //                           value: item.resTableNo,
                        //       //                           child: Text(item.resTableNo),
                        //       //                         );
                        //       //                       }).toList(),
                        //       //                       value: dropdownValueall,
                        //       //                       onChanged: (newValue) {
                        //       //
                        //       //                         setState(() {
                        //       //                           dropdownValueall = newValue!;
                        //       //                           //one method need to call for dropdown
                        //       //                         });
                        //       //                       },
                        //       //                     ),
                        //       //                     DropdownButton<String>(
                        //       //                       hint: const Text(
                        //       //                         "Table",
                        //       //                         style: TextStyle(fontWeight: FontWeight.bold),
                        //       //                       ),
                        //       //                       icon: const Icon(Icons.keyboard_arrow_down),
                        //       //                       elevation: 16,
                        //       //                       style: const TextStyle(
                        //       //                           color: Colors.black, fontSize: 15),
                        //       //                       underline: Container(
                        //       //                         height: 2,
                        //       //                         color: Colors.white,
                        //       //                       ),
                        //       //                       items: dropdownList?.map((item) {
                        //       //                         return DropdownMenuItem<String>(
                        //       //                           value: item.resTableNo,
                        //       //                           child: Text(item.resTableNo),
                        //       //                         );
                        //       //                       }).toList(),
                        //       //                       value: dropdownValue,
                        //       //                       onChanged: (newValue) {
                        //       //
                        //       //                         setState(() {
                        //       //                           dropdownValue = newValue!;
                        //       //                           //one method need to call for dropdown
                        //       //                         });
                        //       //                       },
                        //       //                     ),
                        //       //                     Padding(
                        //       //                       padding: const EdgeInsets.all(8.0),
                        //       //                       child: GestureDetector(
                        //       //                         onTap: (){
                        //       //                           switchTable();
                        //       //                           // bookedTable(dropdownValueall,"0");
                        //       //                           // bookedTable(dropdownValue,"1");
                        //       //                           Navigator.pop(context);
                        //       //
                        //       //                         },
                        //       //                         child: Container(
                        //       //                           alignment: Alignment.center,
                        //       //                           height: 40.0,
                        //       //                           width:135,
                        //       //                           // width: MediaQuery.of(context).size.width * 0.5,
                        //       //                           decoration: BoxDecoration(
                        //       //                             borderRadius: BorderRadius.circular(80.0),
                        //       //                             gradient: const LinearGradient(
                        //       //                               colors: [
                        //       //                                 Color.fromARGB(255, 255, 136, 34),
                        //       //                                 Color.fromARGB(255, 255, 177, 41)
                        //       //                               ],
                        //       //                             ),
                        //       //                           ),
                        //       //                           padding: const EdgeInsets.all(0),
                        //       //                           child:Text(
                        //       //                             "Confirm",
                        //       //                             textAlign: TextAlign.center,
                        //       //                             style: TextStyle(
                        //       //                                 fontSize: 20,
                        //       //                                 color: Colors.white,
                        //       //                                 fontWeight: FontWeight.bold
                        //       //                             ),
                        //       //                           ),
                        //       //
                        //       //                         ),
                        //       //
                        //       //
                        //       //
                        //       //                       ),
                        //       //                     ),
                        //       //                   ],
                        //       //                 ),
                        //       //                 scrollable: true,
                        //       //               );
                        //       //             }
                        //       //             );
                        //       //           });
                        //       //
                        //       //
                        //       //     },
                        //       //     child: Container(
                        //       //       alignment: Alignment.center,
                        //       //       height: 40.0,
                        //       //       width:250,
                        //       //       // width: MediaQuery.of(context).size.width * 0.5,
                        //       //       decoration: BoxDecoration(
                        //       //         borderRadius: BorderRadius.circular(80.0),
                        //       //         gradient: const LinearGradient(
                        //       //           colors: [
                        //       //             Color(0xffd66d75),
                        //       //             Color(0xffe29587),
                        //       //           ],
                        //       //         ),
                        //       //       ),
                        //       //       padding: const EdgeInsets.all(0),
                        //       //       child:Text(
                        //       //         "Switch Table",
                        //       //         textAlign: TextAlign.center,
                        //       //         style: TextStyle(
                        //       //             fontSize: 20,
                        //       //             color: Colors.white,
                        //       //             fontWeight: FontWeight.bold
                        //       //         ),
                        //       //       ),
                        //       //
                        //       //     ),
                        //       //
                        //       //   ),
                        //       // ),
                        //
                        //     ],
                        //   ),
                        // )
                      ],

                    ),
                  ),
                )
              ],
            ),
            ),
        );
    }
}