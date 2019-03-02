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
        onPressed: () {}, elevation: 2.0, fillColor: Colors.red);
    RawMaterialButton greenButton = new RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.green,
    );
    RawMaterialButton blueButton = new RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.blue,
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Column"),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: redButton),
              Expanded(child: greenButton),
              Expanded(child: blueButton)
            ],
          ),
        ));
  }
}
