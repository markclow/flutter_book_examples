import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Cat {
  String imageSrc;
  String name;
  int age;
  int votes;

  Cat(this.imageSrc, this.name, this.age, this.votes);

  operator ==(other) => (other is Cat) && (imageSrc == other.imageSrc);

  int get hashCode => imageSrc.hashCode;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'The Cat List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
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

  _MyHomePageState() : super() {
    for (int i = 200; i < 250; i += 10) {
      _cats.add(Cat("http://placekitten.com/200/${i}", CAT_NAMES[next(0, 6)],
          next(1, 32), 0));
    }
  }

  _buildItem(Cat cat, {int index = -1}) {
    return ListTile(
      key: Key("ListTile:${cat.hashCode.toString()}"),
      leading: CircleAvatar(
          backgroundImage: NetworkImage(cat.imageSrc), radius: 32.0),
      title: Text(cat.name, style: TextStyle(fontSize: 25.0)),
      subtitle: Text("This little thug is ${cat.age} year(s) old.",
          style: TextStyle(fontSize: 15.0)),
        onLongPress: index != null ? () => _remove(index) : null
    );
  }

  _add() {
    setState(() {
      _cats.add(Cat("http://placekitten.com/200/${next(200, 300)}",
          CAT_NAMES[next(0, 6)], next(1, 32), 0));
      _listKey.currentState
          .insertItem(_cats.length - 1, duration: Duration(seconds: 2));
      ;
    });
  }

  _remove(int index) {
    setState(() {
      Cat cat = _cats[index];
      _cats.remove(cat);
      _listKey.currentState.removeItem(
        index,
            (BuildContext context, Animation<double> animation) {
          return FadeTransition(
            opacity:
            CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
            child: SizeTransition(
              sizeFactor:
              CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              axisAlignment: 0.0,
              child: _buildItem(cat),
            ),
          );
        },
        duration: Duration(milliseconds: 600),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _cats.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: _buildItem(_cats[index], index: index), //Change
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
