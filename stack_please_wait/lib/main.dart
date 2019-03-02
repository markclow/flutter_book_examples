import 'package:flutter/material.dart';

void main() => runApp(new StackPleaseWaitAppWidget());

class StackPleaseWaitAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(title: 'Card Layout Demo'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));
  final AppWidget _appWidget = AppWidget(key: ObjectKey("appWidget"));

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _pleaseWait = false;

  void _togglePleaseWait() {
    setState(() {
      _pleaseWait = !_pleaseWait;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childWidgets = _pleaseWait
        ? [widget._pleaseWaitWidget, widget._appWidget]
        : [widget._appWidget];
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
            child: Stack(key: ObjectKey("stack"), children: childWidgets)),
        floatingActionButton: new FloatingActionButton.extended(
            onPressed: _togglePleaseWait,
            label: Text('Please Wait On/Off'),
            icon: new Icon(Icons.cached)));
  }
}

class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 8.0),
        ),
        color: Colors.grey.withOpacity(0.3));
  }
}

class AppWidget extends StatelessWidget {
  AppWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text('Your', style: TextStyle(fontSize: 20.0)),
          const Text('App', style: TextStyle(fontSize: 20.0)),
          const Text('Goes', style: TextStyle(fontSize: 20.0)),
          const Text('Here', style: TextStyle(fontSize: 20.0))
        ],
      ),
    );
  }
}
