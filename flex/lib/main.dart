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
        home: new HomeWidget(title: 'Flex'));
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomeWidget> {
  List<MainAxisAlignment> _alignments = [
    MainAxisAlignment.start,
    MainAxisAlignment.end,
    MainAxisAlignment.center,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
    MainAxisAlignment.spaceAround
  ];
  List<String> _alignmentsText = [
    "Start",
    "End",
    "Center",
    "Soace Between",
    "Space Evenly",
    "Space Around"
  ];

  bool _vertical = true;
  int _alignmentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.rotate_right),
              tooltip: 'Direction',
              onPressed: () {
                setState(() {
                  _vertical = !_vertical;
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(_vertical ? "Vertical" : "Horizontal")),
            IconButton(
              icon: const Icon(Icons.aspect_ratio),
              tooltip: 'Main axis',
              onPressed: () {
                setState(() {
                  _alignmentIndex++;
                  if (_alignmentIndex >= _alignments.length) {
                    _alignmentIndex = 0;
                  }
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(_alignmentsText[_alignmentIndex])),
            Padding(
              padding: EdgeInsets.all(10.0),
            )
          ],
        ),
        body: new Flex(
          direction: _vertical ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: _alignments[_alignmentIndex],
          children: <Widget>[redButton, greenButton, blueButton],
        ));
  }
}
