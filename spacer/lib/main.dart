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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(actions: <Widget>[
          Spacer(),
          Center(
              child: Text(
            "Spacer",
            style: TextStyle(fontSize: 20.0),
          )),
          Spacer(flex: 5),
          IconButton(icon: Icon(Icons.settings_overscan), onPressed: () => {}),
          Spacer(),
          IconButton(icon: Icon(Icons.settings_overscan), onPressed: () => {})
        ]),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Dummy',
              )
            ],
          ),
        ));
  }
}
