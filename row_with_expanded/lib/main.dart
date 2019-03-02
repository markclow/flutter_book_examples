import 'package:flutter/material.dart';

void main() => runApp(new RowWithExpandedApp());

class RowWithExpandedApp extends StatelessWidget {
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
            const Text("None expanded:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("aaaaaaaaaa"),
                const Text("bbbbbbbbbb"),
                const Text("cccccccccc")
              ],
            ),
            const Text("1st child expanded:"),
            Row(
              children: <Widget>[
                const Expanded(child: const Text("aaaaaaaaaa")),
                const Text("bbbbbbbbbb"),
                const Text("cccccccccc")
              ],
            ),
            const Text("2nd child expanded:"),
            Row(
              children: <Widget>[
                const Text("aaaaaaaaaa"),
                const Expanded(child: const Text("bbbbbbbbbb")),
                const Text("cccccccccc")
              ],
            ),
            const Text("3rd child expanded:"),
            Row(
              children: <Widget>[
                const Text("aaaaaaaaaa"),
                const Text("bbbbbbbbbb"),
                const Expanded(child: const Text("cccccccccc"))
              ],
            ),
          ],
        ));
  }
}
