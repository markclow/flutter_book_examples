import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earth',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: MyHomePage(title: 'Earth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // Create animation controller.
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..addListener(() {
            setState(() {
              // Force build.
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.dismissed) {
              _controller.forward();
            } else if (status == AnimationStatus.completed) {
              _controller.reverse();
            }
          });

    // Start animation automatically.
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Transform.scale(
              scale: 1.6,
              child: Transform.rotate(
                  angle: math.pi * _controller.value, // rotate animation
                  child: Image.network(
                      "https://ak7.picdn.net/shutterstock/videos/3010597/thumb/1.jpg")))),
    );
  }
}
