import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:japanes_res/controller/api.dart';

import '../controller/design_controller.dart';
import '../model/check_cart.dart';
import '../model/food_category.dart';
import 'food_view.dart';

class Category_page extends StatefulWidget {
  const Category_page({Key? key}) : super(key: key);

  @override
  State<Category_page> createState() => _Category_pageState();
}

class _Category_pageState extends State<Category_page> {


  String api = API_Names().api;
  late Future<List<FoodCategory>> category;
  Future<List<FoodCategory>> find_category() async{
    var response = await http.get(Uri.parse("http://$api/ordertake_api/ordertake/ordertake_app/food/read_reswise_food_category.php?res_id=216464"));
    // print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<FoodCategory>((json) => FoodCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch Data');
    }

  }

  String selectedValue = 'Language';
  // The initially selected value
  List<String> options = ['Language','English', 'Bangla', 'Japanese'];

  Color_Controller color_controller = Color_Controller();
  Size_Controller size_controller = Size_Controller();

  late Future<List<CheckCartModel>> checkCart;
  Future<List<CheckCartModel>> find_from_cart() async{
    var response = await http.post(Uri.parse("http://$api/ordertake_api/ordertake/small_api/show_cart_kot_active.php"),
      body:jsonEncode(<String,String>{
        "res_id": "216464",
        "table_no": "5"
      }),
    );
    // print(response.body);
    // print("http://$api/ordertake_api/ordertake/ordertake_app/food/read_categorywise_all_food.php?res_id=216464&food_category=${widget.catergory}");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<CheckCartModel>((json) => CheckCartModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch Data');
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    category = find_category();
    find_category();
    checkCart = find_from_cart();
    find_from_cart();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Category"),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart), // Troly icon
              onPressed: () {
                // Add your Troly icon press logic here
              },
            ),
            IconButton(
              icon: Icon(Icons.warning), // SOS icon
              onPressed: () {
                // Add your SOS icon press logic here
              },
            ),
          ],
        ),
        body: Row(
          children: [
            Container(
              height: size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: FutureBuilder<List<FoodCategory>>(
                future: category,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // if (snapshot.hasData) {
                  //   return ListView.builder(
                  //     itemCount: snapshot.data!.length,
                  //     itemBuilder: (_, index) => Container(
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: (){
                  //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Football_field_select()));
                  //                 },
                  //                 child: Card_controller(
                  //                   text: "${snapshot.data![index].sName}",
                  //                   image: "field_book.jpg",
                  //                 ),
                  //               ),
                  //
                  //               SizedBox(width: 20,),
                  //
                  //             ],
                  //           ),
                  //
                  //
                  //         ],
                  //       ),
                  //
                  //     ),
                  //   );
                  // }

                  if (snapshot.hasData) {
                    return  GridView.count(
                        // physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: .9,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        // Number of columns in the grid
                        children: List.generate(snapshot.data!.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 2),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Food_view_page(catergory: snapshot.data![index].foodcategory,)));
                              },
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Color(0xff3fc380),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Align(
                                        alignment : Alignment.centerLeft,
                                        child: Text(

                                          '${snapshot.data![index].foodcategory}',
                                          style: TextStyle(
                                            fontSize: size_controller.text20,
                                             color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image(
                                          fit:BoxFit.cover,
                                          // height: size.height / 35,
                                          image: NetworkImage("http://$api/ordertake_api/ordertake/images/${snapshot.data![index].foodposcat}"),
                                        ),
                                      ),
                                    ),
                                    // Icon(Icons.local_pizza, color: Color(0xffF7A037),),

                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    );
                  }


                  else {
                    return Text('An Error kkkkkOccurred',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    );
                  }
                },
              ),
            ),


          ],
        )
      ),
    );
  }
}


