import 'package:conv_moedas/home_conversor.dart';
import 'package:flutter/material.dart';

void main() async {
  final ThemeData thema = ThemeData();
  runApp(MaterialApp(
    home: const HomeConver(),
    theme: ThemeData().copyWith(
        colorScheme: thema.colorScheme.copyWith(
      primary: Color.fromARGB(255, 128, 188, 68),
      //secondary: Colors.blue,
      // background: Colors.blue,
    )),
    debugShowCheckedModeBanner: false,
  ));
}
