import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(new GridViewApp());
}

class Cat {
  String imageSrc;
  String name;
  int age;
  int votes;

  Cat(this.imageSrc, this.name, this.age, this.votes);

  operator ==(other) => (other is Cat) && (imageSrc == other.imageSrc);

  int get hashCode => imageSrc.hashCode;
}

class GridViewApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cat Voting',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(title: 'Cat Voting Home Page'),
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
  List<String> CAT_NAMES = [
    "Tom",
    "Oliver",
    "Ginger",
    "Pontouf",
    "Madison",
    "Bubblita",
    "Bubbles"
  ];
  Random _random = Random();
  List<Cat> _cats = [];
  int next(int min, int max) => min + _random.nextInt(max - min);

  _HomeWidgetState() : super() {
    // Generate list of Cat objects once.
    for (int i = 200; i < 300; i += 10) {
      _cats.add(Cat("http://placekitten.com/200/${i}", CAT_NAMES[next(0, 6)],
          next(1, 32), 0));
    }
  }

  void _shuffle() {
    // Shuffle the list of Cat objects.
    setState(() {
      _cats.shuffle(_random);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GridView"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return new GridView.builder(
            itemCount: _cats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return CatTile(_cats[index]);
            });
      }),
      floatingActionButton: new FloatingActionButton(
        onPressed: _shuffle,
        tooltip: 'Try more grid options',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CatTile extends StatefulWidget {
  Cat _cat;
  CatTile(this._cat); // Shuffle doesnt work.
  //CatTile(this._cat): super(key: ObjectKey(_cat.imageSrc)); // Shuffle works.

  @override
  _CatTileState createState() => new _CatTileState(_cat);
}

class _CatTileState extends State<CatTile> {
  Cat _cat;

  _CatTileState(this._cat);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: GridTile(
            header: GridTileBar(
              title: Text("${_cat.name} ${_cat.age} years old.",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
            ),
            footer: GridTileBar(
                title: Text(
                    _cat.votes == 0 ? "No votes" : "${_cat.votes} votes.",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            child: Image.network(_cat.imageSrc, fit: BoxFit.cover)),
        onTap: () => _vote());
  }

  _vote() {
    setState(() => _cat.votes++);
  }
}
