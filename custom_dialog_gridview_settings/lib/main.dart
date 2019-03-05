import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new GridViewApp());

class GridOptions {
  int _crossAxisCountPortrait;
  int _crossAxisCountLandscape;
  double _childAspectRatio;
  double _padding;
  double _spacing;

  GridOptions(this._crossAxisCountPortrait, this._crossAxisCountLandscape,
      this._childAspectRatio, this._padding, this._spacing);

  GridOptions.copyOf(GridOptions gridOptions) {
    this._crossAxisCountPortrait = gridOptions._crossAxisCountPortrait;
    this._crossAxisCountLandscape = gridOptions._crossAxisCountLandscape;
    this._childAspectRatio = gridOptions._childAspectRatio;
    this._padding = gridOptions._padding;
    this._spacing = gridOptions._spacing;
  }

  @override
  String toString() {
    return 'GridOptions{_crossAxisCountPortrait: $_crossAxisCountPortrait, _crossAxisCountLandscape: $_crossAxisCountLandscape, _childAspectRatio: $_childAspectRatio, _padding: $_padding, _spacing: $_spacing}';
  }
}

class GridViewApp extends StatelessWidget {
  // This widget is the root of your application.
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

class CustomDialogWidget extends StatefulWidget {
  GridOptions _gridOptions;
  CustomDialogWidget(this._gridOptions) : super();

  @override
  _CustomDialogWidgetState createState() =>
      new _CustomDialogWidgetState(GridOptions.copyOf(this._gridOptions));
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  GridOptions _gridOptions;

  _CustomDialogWidgetState(this._gridOptions);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.0,
        width: 250.0,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                Widget>[
          Text("Grid Options",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Spacer(),
            Text("Cross Axis Count Portrait"),
            Spacer(),
            new DropdownButton<int>(
              value: _gridOptions._crossAxisCountPortrait,
              items: <int>[2, 3, 4, 5, 6].map((int value) {
                return new DropdownMenuItem<int>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gridOptions._crossAxisCountPortrait = newValue;
                });
              },
            ),
            Spacer(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Spacer(),
            Text("Cross Axis Count Landscape"),
            Spacer(),
            new DropdownButton<int>(
              value: _gridOptions._crossAxisCountLandscape,
              items: <int>[2, 3, 4, 5, 6].map((int value) {
                return new DropdownMenuItem<int>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gridOptions._crossAxisCountLandscape = newValue;
                });
              },
            ),
            Spacer(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Spacer(),
            Text("Aspect Ratio"),
            Spacer(),
            new DropdownButton<double>(
              value: _gridOptions._childAspectRatio,
              items: <double>[1.0, 1.5, 2.0, 2.5].map((double value) {
                return new DropdownMenuItem<double>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gridOptions._childAspectRatio = newValue;
                });
              },
            ),
            Spacer(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Spacer(),
            Text("Padding"),
            Spacer(),
            new DropdownButton<double>(
              value: _gridOptions._padding,
              items:
                  <double>[1.0, 2.0, 4.0, 8.0, 16.0, 32.0].map((double value) {
                return new DropdownMenuItem<double>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gridOptions._padding = newValue;
                });
              },
            ),
            Spacer(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Spacer(),
            Text("Spacing"),
            Spacer(),
            new DropdownButton<double>(
              value: _gridOptions._spacing,
              items:
                  <double>[1.0, 2.0, 4.0, 8.0, 16.0, 32.0].map((double value) {
                return new DropdownMenuItem<double>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gridOptions._spacing = newValue;
                });
              },
            ),
            Spacer(),
          ]),
          FlatButton(
              child: Text("Apply"),
              onPressed: () => Navigator.pop(context, _gridOptions))
        ]));
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Widget> _kittenTiles = [];
  GridOptions _gridOptions = GridOptions(2, 3, 1.0, 4.0, 4.0);

  _HomeWidgetState() : super() {
    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = "http://placekitten.com/200/${i}";
      _kittenTiles.add(GridTile(
          header: GridTileBar(
            title: Text("Cats", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
          ),
          footer: GridTileBar(
              title: Text("How cute",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          child: Image.network(imageUrl, fit: BoxFit.cover)));
    }
  }

  void _showGridOptionsDialog() async {
    GridOptions gridOptions = await showDialog<GridOptions>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: CustomDialogWidget(this._gridOptions));
        });
    if (gridOptions != null) {
      setState(() {
        _gridOptions = gridOptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait)
                ? _gridOptions._crossAxisCountPortrait
                : _gridOptions._crossAxisCountLandscape,
            childAspectRatio: _gridOptions._childAspectRatio,
            padding: EdgeInsets.all(_gridOptions._padding),
            mainAxisSpacing: _gridOptions._spacing,
            crossAxisSpacing: _gridOptions._spacing,
            children: _kittenTiles);
      }),
      bottomNavigationBar: Container(
          child: Text(_gridOptions.toString()), padding: EdgeInsets.all(20.0)),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showGridOptionsDialog,
        tooltip: 'Try more grid options',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
