import 'package:flutter/material.dart';

class How_to_order extends StatefulWidget {
  const How_to_order({Key? key}) : super(key: key);

  @override
  State<How_to_order> createState() => _How_to_orderState();
}

class _How_to_orderState extends State<How_to_order> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image(image: AssetImage("images/tutorial.gif",),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
