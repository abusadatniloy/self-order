import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:japanes_res/view/initial/how_to_order.dart';
import '../../controller/design_controller.dart';
import '../category.dart';
import 'notice_page.dart';
import 'package:http/http.dart' as http;


class Start_ordering_Page extends StatefulWidget {
  const Start_ordering_Page({Key? key}) : super(key: key);

  @override
  State<Start_ordering_Page> createState() => _Start_ordering_PageState();
}

class _Start_ordering_PageState extends State<Start_ordering_Page> {

  Color_Controller color_controller = Color_Controller();
  Size_Controller size_controller = Size_Controller();


  String selectedValue = 'Language';
  // The initially selected value
  List<String> options = ['Language','English', 'Bangla', 'Japanese'];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
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

          body: Column(
            children: [

              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height/1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage("images/start_order.png"),
                      width: MediaQuery.of(context).size.width/2,
                    ),
                    Column(
                      children: [

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>How_to_order()));
                          },
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Image(image: AssetImage("images/tutorial.gif"),
                                  height: MediaQuery.of(context).size.height/4,
                                ),
                                Text("How to Order",
                                  style: TextStyle(
                                      fontSize: size_controller.text25,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Notice_car()));
                          },
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Image(image: AssetImage("images/notice.jpg"),
                                  height: MediaQuery.of(context).size.height/4,
                                ),
                                Text("Notice",
                                  style: TextStyle(
                                      fontSize: size_controller.text25,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                height:100,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(color_controller.theme_color),
                    minimumSize: MaterialStateProperty.all<Size>(Size(300, 80)), // Define the button size
                    // fixedSize: MaterialStateProperty.all<Size>(Size(300, 40)),// Change the button background color
                  ),
                  child: Text('Menu',
                    style: TextStyle(
                        fontSize: size_controller.text15,
                        color: color_controller.white
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_page())); // Close the dialog
                  },
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }
}
