import 'package:flutter/material.dart';

class Weather extends StatelessWidget {
  final int weatherIndex;
  final List<String> weathers;

  const Weather({Key key, this.weatherIndex, this.weathers}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        weathers[weatherIndex],
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
