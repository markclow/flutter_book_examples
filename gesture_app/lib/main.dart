import 'package:flutter/material.dart';

void main() => runApp(new GestureApp());

class GestureApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(title: 'Gestures'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String _log = '';

  void _clear() {
    setState(() {
      _log = '';
    });
  }

  void _logGesture(String logText) {
    setState(() {
      _log += "\n";
      _log += logText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  child: Text(
                    'Gesture Me',
                  ),
                  onTap: () => _logGesture('tap'),
                  onTapDown: (details) => _logGesture('onTapDown: ${details}'),
                  onTapUp: (details) => _logGesture('onTapUp: ${details}'),
                  onTapCancel: () => _logGesture('onTapCancel'),
                  onDoubleTap: () => _logGesture('onDoubleTap'),
                  onLongPress: () => _logGesture('onLongPress'),
                  onVerticalDragDown: (details) =>
                      _logGesture('onVerticalDragDown: ${details}'),
                  onVerticalDragStart: (details) =>
                      _logGesture('onVerticalDragStart: ${details}'),
                  onVerticalDragUpdate: (details) =>
                      _logGesture('onVerticalDragUpdate'),
                  onVerticalDragEnd: (details) =>
                      _logGesture('onVerticalDragEnd: ${details}'),
                  onVerticalDragCancel: () =>
                      _logGesture('onVerticalDragCancel'),
                  onHorizontalDragDown: (details) =>
                      _logGesture('onHorizontalDragDown: ${details}'),
                  onHorizontalDragStart: (details) =>
                      _logGesture('onHorizontalDragStart: ${details}'),
                  onHorizontalDragUpdate: (details) =>
                      _logGesture('onHorizontalDragUpdate: ${details}'),
                  onHorizontalDragEnd: (details) =>
                      _logGesture('onHorizontalDragEnd: ${details}'),
                  onHorizontalDragCancel: () =>
                      _logGesture('onHorizontalDragCancel')),
              Container(
                  child: SingleChildScrollView(child: Text('$_log')),
                  constraints: BoxConstraints(maxHeight: 200.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  )),
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0)),
              RaisedButton(child: Text('Clear'), onPressed: () => _clear())
            ],
          ),
        ));
  }
}
