import 'package:flutter/material.dart';

void main() => runApp(new ColumnSpacedEvenly());

class ColumnSpacedEvenly extends StatelessWidget {
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

class HomeWidget extends StatelessWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RawMaterialButton redButton = RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 188.0, minHeight: 136.0),
      onPressed: () {},
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.red,
      padding: const EdgeInsets.all(15.0),
    );
    RawMaterialButton greenButton = new RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 188.0, minHeight: 136.0),
      onPressed: () {},
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.green,
      padding: const EdgeInsets.all(15.0),
    );
    RawMaterialButton blueButton = new RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 188.0, minHeight: 136.0),
      onPressed: () {},
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.blue,
      padding: const EdgeInsets.all(15.0),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Column"),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[redButton, greenButton, blueButton],
          ),
        ));
  }
}
