import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new CircleWidget(),
      routes: <String, WidgetBuilder>{
        '/circle': (context) => CircleWidget(),
        '/square': (context) => SquareWidget(),
      },
    );
  }
}

class Colorizer {
  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  List<Color> _colors = [];
  _initColors() {
    for (int i = 0; i < 100; i++) {
      _colors.add(Colors.green
          .withRed(next(0, 255))
          .withGreen(next(0, 255))
          .withBlue(next(0, 255)));
    }
  }
}

class CirclePainter extends CustomPainter with Colorizer {
  CirclePainter() {
    _initColors();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      var radius = (i * 10).toDouble();
      canvas.drawCircle(
          new Offset(1000.0, 1000.0),
          radius,
          new Paint()
            ..color = _colors[i]
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..strokeWidth = 15.0);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}

class SquarePainter extends CustomPainter with Colorizer {
  SquarePainter() {
    _initColors();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 100; i++) {
      var inset = (i * 10).toDouble();
      canvas.drawRect(
          new Rect.fromLTRB(inset, inset, 2000.0 - inset, 2000.0 - inset),
          new Paint()
            ..color = _colors[i]
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..strokeWidth = 15.0);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}

class CircleWidget extends StatelessWidget {
  CirclePainter _painter = new CirclePainter();
  CircleWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Circle"), actions: [
          IconButton(
              icon: Icon(Icons.crop_square),
              onPressed: () => Navigator.pushNamed(context, "/square"))
        ]),
        body: new SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            child: CustomPaint(
              size: Size(2000.0, 2000.0),
              foregroundPainter: _painter,
            )));
  }
}

class SquareWidget extends StatelessWidget {
  SquarePainter _painter = new SquarePainter();
  SquareWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Square"),
        ),
        body: new SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            child: CustomPaint(
              size: Size(2000.0, 2000.0),
              foregroundPainter: _painter,
            )));
  }
}
