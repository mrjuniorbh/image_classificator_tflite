import 'package:flutter/material.dart';
import 'package:image_classification_ml/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classificador de Imagem - Homem ou Mulher',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff4caf50),
        accentColor: Colors.green[500],
        primarySwatch: Colors.deepOrange,
        //primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
