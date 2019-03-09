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
      home: new HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  HomePageWidget({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('An unexpected error occurred: Error!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Snackbar"),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Content goes here.',
              ),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton.extended(
            icon: Icon(Icons.explicit),
            label: Text("Throw Error"),
            onPressed: () => _showSnackBar(),
            tooltip: 'Throw Error'));
  }
}
