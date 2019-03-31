import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey _counterWidgetGlobalKey = GlobalKey();
  bool _widget1 = true;

  _selectPage() {
    setState(() => _widget1 = !_widget1);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _widget1
                ? Widget1(_counterWidgetGlobalKey, _selectPage)
                : Widget2(_counterWidgetGlobalKey, _selectPage));
  }
}

class Widget1 extends StatelessWidget {
  final GlobalKey _counterWidgetGlobalKey;
  final VoidCallback _selectPageCallback;

  Widget1(this._counterWidgetGlobalKey, this._selectPageCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Widget 1"),
          actions: <Widget>[
            IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () => _selectPageCallback())
          ],
        ),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Widget 1", textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
            CounterWidget(_counterWidgetGlobalKey)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ));
  }
}

class Widget2 extends StatelessWidget {
  final GlobalKey _counterWidgetGlobalKey;
  final VoidCallback _selectPageCallback;

  Widget2(this._counterWidgetGlobalKey, this._selectPageCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () => _selectPageCallback())
        ],
        title: Text("Widget 2"),
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Widget 2", textAlign: TextAlign.center, style: Theme.of(context).textTheme.display2),
          CounterWidget(_counterWidgetGlobalKey)
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  CounterWidget(Key key) : super(key: key);
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'CounterWidget',
            style: Theme.of(context).textTheme.display2,
          ),
          Text('You have:', style: Theme.of(context).textTheme.display1),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.display1,
          ),
          IconButton(
              iconSize: 36.0,
              icon: new Icon(Icons.add), onPressed: () => _incrementCounter()),
        ]);
  }
}
