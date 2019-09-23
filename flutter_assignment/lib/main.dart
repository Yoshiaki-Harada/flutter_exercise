import 'package:flutter/material.dart';
import 'package:flutter_assignment/Change.dart';
import 'package:flutter_assignment/Weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _weathers = const ['Sunny', 'Cloudy', 'Rainy'];

  var weatherIndex = 0;

  void _changeWeather() {
    setState(() {
      weatherIndex++;
      weatherIndex = weatherIndex % _weathers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
        ),
        body: Row(
          children: <Widget>[
            Change(_changeWeather),
            Weather(
              weathers: _weathers,
              weatherIndex: weatherIndex,
            ),
          ],
        ),
      ),
    );
  }
}
