// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:map_page1/MapPage.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MapPage(),
      debugShowCheckedModeBanner: false, // Assuming MapPage is the home page of your app
    );
  }
}

void main() {
  runApp(MyApp());
}
