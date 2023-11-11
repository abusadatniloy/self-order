import 'package:flutter/material.dart';
import 'package:japanes_res/controller/design_controller.dart';

class Floating_action extends StatefulWidget {


  @override
  State<Floating_action> createState() => _Floating_actionState();
}

class _Floating_actionState extends State<Floating_action> {
  Color_Controller color_controller = Color_Controller();

  Size_Controller size_controller = Size_Controller();

  String selectedValue = 'Option 1';
  // The initially selected value
  List<String> options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            color: color_controller.theme_color,
            child: Column(
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
          SizedBox(width: 20),
          Container(
            color: color_controller.theme_color,
            child: Row(
              children: [
                Icon(Icons.language,
                  color: color_controller.white,
                ),
                SizedBox(width: 10,),
                Center(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
