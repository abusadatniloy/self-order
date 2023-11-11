import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:japanes_res/view/initial/start_ordering_page.dart';
import 'package:http/http.dart' as http;
import '../../controller/design_controller.dart';
import '../category.dart';
import 'floating_button.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  Color_Controller color_controller = Color_Controller();
  Size_Controller size_controller = Size_Controller();


  String selectedValue = 'Language';
  // The initially selected value
  List<String> options = ['Language','English', 'Bangla', 'Japanese'];




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
        body: GestureDetector(
          onTap: (){

          },
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/table_no.jpg"),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 450.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_page()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Background color
                      onPrimary: Colors.white,
                      fixedSize: Size(250, 80),// Text color
                    ),
                    child: Text(
                      'Eat In',
                      style: TextStyle(fontSize: 28),
                    ),

                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_page()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Background color
                      onPrimary: Colors.white,
                      fixedSize: Size(250, 80),// Text color
                    ),
                    child: Text(
                      'Take Away',
                      style: TextStyle(fontSize: 28),
                    ),

                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

