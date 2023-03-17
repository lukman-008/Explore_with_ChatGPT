import 'dart:async';
import 'package:explore/screens/chat_screen.dart';
import 'package:flutter/material.dart';
class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ChatScreen()));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/gptscreen.jpg"),
              fit: BoxFit.fill,
          )
        )),
    );
  }
}