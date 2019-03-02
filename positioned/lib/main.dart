import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _top = 0.0;
  double _left = 0.0;
  List<Widget> widgetList = [];

  final _random = new Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

  void _addLayer() {
    setState(() {
      widgetList.add(Positioned(
          left: _left,
          top: _top,
          child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                color: Color.fromRGBO(
                    next(0, 255), next(0, 255), next(0, 255), 0.5),
              ))));
    });
    _top += 30;
    _left += 30;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Positioned"),
      ),
      body: new Stack(children: widgetList),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addLayer,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
