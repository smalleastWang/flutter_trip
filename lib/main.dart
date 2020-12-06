import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_trip/navigator/tab_navigator.dart';

void main() {
    // debugPaintSizeEnabled = true;
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:TabNavigator(),
    );
  }
}