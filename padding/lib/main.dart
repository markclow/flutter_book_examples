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
      home: new HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  static const double TWENTY = 20.0;
  static const List<String> _titles = [
    "all 20.0",
    "left 20.0",
    "right 20.0",
    "top 20.0",
    "bottom 20.0",
    "sym horiz 20.0",
    "sym vert 20.0"
  ];
  static const List<EdgeInsets> _edgeInsets = [
    const EdgeInsets.all(TWENTY),
    const EdgeInsets.only(left: TWENTY),
    const EdgeInsets.only(right: TWENTY),
    const EdgeInsets.only(top: TWENTY),
    const EdgeInsets.only(bottom: TWENTY),
    const EdgeInsets.symmetric(horizontal: TWENTY),
    const EdgeInsets.symmetric(vertical: TWENTY)
  ];
  int _index = 0;
  final Container _childContainer = Container(color: Colors.blue);

  void _next() {
    setState(() {
      _index++;
      if (_index >= _titles.length) {
        _index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Padding padding =
        Padding(padding: _edgeInsets[_index], child: _childContainer);
    return Scaffold(
        appBar: AppBar(
          title: Text(_titles[_index]),
          actions: [
            new IconButton(
                icon: new Icon(Icons.refresh), onPressed: () => _next())
          ],
        ),
        body: Center(
            child: Container(
                child: padding,
                decoration: BoxDecoration(
                    border: new Border.all(color: Colors.blueAccent)))));
  }
}
