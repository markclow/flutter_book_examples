import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Simple Dialog',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(title: 'Simple Dialog'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  BoxFit _boxFit = BoxFit.cover;

  void _showBoxFitDialog() async {
    BoxFit boxFit = await showDialog<BoxFit>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Box Fit'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.cover);
                },
                child: const Text('Cover'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.contain);
                },
                child: const Text('Contain'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.fill);
                },
                child: const Text('Fill'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.fitHeight);
                },
                child: const Text('Fit Height'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.fitWidth);
                },
                child: const Text('Fit Width'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.scaleDown);
                },
                child: const Text('Scale Down'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, BoxFit.none);
                },
                child: const Text('None'),
              ),
            ],
          );
        });
    if (boxFit != null) {
      // not cancelled
      setState(() {
        _boxFit = boxFit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> kittenTiles = [];
    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = "http://placekitten.com/200/${i}";
      kittenTiles.add(GridTile(child: Image.network(imageUrl, fit: _boxFit)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}: ${_boxFit}"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: kittenTiles);
      }),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showBoxFitDialog,
        child: new Icon(Icons.select_all),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
