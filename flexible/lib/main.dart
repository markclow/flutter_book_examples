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
  bool _topTightFit = false;
  bool _bottomExpanded = false;

  toggleTop() {
    setState(() => _topTightFit = !_topTightFit);
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
      constraints: BoxConstraints(
          minHeight: 100.0, minWidth: 100.0, maxHeight: 200.0, maxWidth: 200.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.blue),
      padding: EdgeInsets.all(10.0),
    );
    Container bottomContainer = Container(
      child: new Text(
        'Bottom Container',
      ),
      constraints: BoxConstraints(
          minHeight: 100.0, minWidth: 100.0, maxHeight: 200.0, maxWidth: 200.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.yellow),
      padding: EdgeInsets.all(10.0),
    );
    Widget topWidget = Flexible(
        child: topContainer, fit: _topTightFit ? FlexFit.tight : FlexFit.loose);
    Widget bottomWidget =
        _bottomExpanded ? Expanded(child: bottomContainer) : bottomContainer;
    String toolbarTextTop = "Top (" + (_topTightFit ? "tight" : "loose") + ")";
    String toolbarTextBottom =
        "Bottom (" + (_bottomExpanded ? "expanded" : "not expanded") + ")";
    return new Scaffold(
        appBar: new AppBar(title: new Text("Expanded"), actions: <Widget>[
          FlatButton.icon(
              icon: Icon(_topTightFit
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_up),
              label: Text(toolbarTextTop),
              onPressed: () => toggleTop()),
          FlatButton.icon(
              icon: Icon(_bottomExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_down),
              label: Text(toolbarTextBottom),
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
