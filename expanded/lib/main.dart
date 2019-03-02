import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
  bool _topExpanded = false;
  bool _bottomExpanded = false;

  toggleTop() {
    setState(() => _topExpanded = !_topExpanded);
  }

  toggleBottom() {
    setState(() => _bottomExpanded = !_bottomExpanded);
  }

  @override
  Widget build(BuildContext context) {
    Container topContainer = Container(
      child: new Text(
        'Top Container',
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.blue),
      padding: EdgeInsets.all(10.0),
    );
    Container bottomContainer = Container(
      child: new Text(
        'Bottom Container',
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.yellow),
      padding: EdgeInsets.all(10.0),
    );
    Widget topWidget =
        _topExpanded ? Expanded(child: topContainer) : topContainer;
    Widget bottomWidget =
        _bottomExpanded ? Expanded(child: bottomContainer) : bottomContainer;
    return new Scaffold(
        appBar: new AppBar(title: new Text("Expanded"), actions: <Widget>[
          FlatButton.icon(
              icon: Icon(_topExpanded ? Icons.expand_more : Icons.expand_less),
              label: Text("Top"),
              onPressed: () => toggleTop()),
          FlatButton.icon(
              icon:
                  Icon(_bottomExpanded ? Icons.expand_less : Icons.expand_more),
              label: Text("Bottom"),
              onPressed: () => toggleBottom())
        ]),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[topWidget, bottomWidget],
          ),
        ));
  }
}
