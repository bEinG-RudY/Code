import 'package:flutter/material.dart';
import 'HomePage.dart';

void main(){
  runApp(const myApp());
}
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Home());
  }
}
// import 'package:flutter/material.dart';
// import 'package:speeches/Home.dart';
// import 'package:speeches/NewsData.dart';
//
// void main() =>
//   runApp(MaterialApp(
//     home: QuoteList(),
//   ));

  // List<Quote> quotes = [
  //   Quote(text: 'Be yourself; everyone else is already taken', author: 'oscar wild'),
  //   Quote(text: 'I have nothing to declare except my genius', author: 'richard petronski'),
  //   Quote(text: 'The Truth is rarely pure and never simple', author: 'mark manson')
  //   // 'Be yourself; everyone else is already taken',
  //   // 'I have nothing to declare except my genius',
  //   // 'The Truth is rarely pure and never simple',
  // ];
