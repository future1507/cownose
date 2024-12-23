import 'package:flutter/material.dart';
import 'package:my_app/showdata.dart';
import 'package:my_app/provider/appdata.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [ChangeNotifierProvider(create: (context) => AppData())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowdataPage()
    );
  }
}
