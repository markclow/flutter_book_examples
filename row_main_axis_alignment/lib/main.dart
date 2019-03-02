import 'package:flutter/material.dart';

void main() => runApp(new RowMainAxisAlignmentApp());

class RowMainAxisAlignmentApp extends StatelessWidget {
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
    return new Scaffold(
        appBar: new AppBar(title: new Text("Rows")),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("center")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("end")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("spaceAround")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("spaceEvenly")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("spaceBetween")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text("MainAxisAlignment"),
                const Text("is"),
                const Text("start")
              ],
            ),
          ],
        ));
  }
}
