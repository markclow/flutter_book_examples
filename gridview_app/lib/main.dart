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
      home: new HomeWidget(title: 'Flutter Demo Home Page'),
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
  List<Widget> _kittenTiles = [];
  int _gridOptionsIndex = 0;
  List<GridOptions> _gridOptions = [
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(3, 4, 1.0, 10.0, 10.0),
    GridOptions(4, 5, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 10.0, 10.0),
    GridOptions(2, 3, 2.0, 10.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 20.0, 10.0),
    GridOptions(2, 3, 2.0, 30.0, 10.0),
    GridOptions(2, 3, 1.0, 10.0, 10.0),
    GridOptions(2, 3, 1.5, 10.0, 20.0),
    GridOptions(2, 3, 2.0, 10.0, 30.0),
  ];

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

  void _tryMoreGridOptions() {
    setState(() {
      _gridOptionsIndex++;
      if (_gridOptionsIndex >= (_gridOptions.length - 1)) {
        _gridOptionsIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GridOptions options = _gridOptions[_gridOptionsIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait)
                ? options._crossAxisCountPortrait
                : options._crossAxisCountLandscape,
            childAspectRatio: options._childAspectRatio,
            padding: EdgeInsets.all(options._padding),
            mainAxisSpacing: options._spacing,
            crossAxisSpacing: options._spacing,
            children: _kittenTiles);
      }),
      bottomNavigationBar: Container(
          child: Text(options.toString()), padding: EdgeInsets.all(20.0)),
      floatingActionButton: new FloatingActionButton(
        onPressed: _tryMoreGridOptions,
        tooltip: 'Try more grid options',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
