import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Future Builder App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  String computeListOfTimestamps(int count) {
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < count; i++) {
      sb.writeln("${i + 1} : ${DateTime.now()}");
    }
    return sb.toString();
  }

  Future<String> createFutureCalculation(int count) {
    return new Future(() {
      return computeListOfTimestamps(count);
    });
  }

  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _showCalculation = false;

  void _onInvokeFuturePressed() {
    setState(() {
      _showCalculation = !_showCalculation;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _showCalculation
        ? FutureBuilder(
            future: widget.createFutureCalculation(10000),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Expanded(
                  child: SingleChildScrollView(
                      child: Text(
                          '${snapshot.data == null ? "" : snapshot.data}',
                          style: TextStyle(fontSize: 20.0))));
            })
        : Text('hit the button to show calculation');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Future"),
      ),
      body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[child])),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onInvokeFuturePressed,
        tooltip: 'Invoke Future',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
