import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  TextStyle textStyle1 = const TextStyle(color: Colors.blue, fontSize: 40.0, fontWeight: FontWeight.w200);
  TextStyle textStyle2 = const TextStyle(color: Colors.green, fontSize: 40.0, fontWeight: FontWeight.w600);
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _counter % 2 == 0 ? textStyle1 : textStyle2;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedDefaultTextStyle(
                child: Text('You have pushed', textAlign: TextAlign.center,),
                    duration: Duration(seconds: 1),style: textStyle),
            AnimatedDefaultTextStyle(
                child: Text('the button this', textAlign: TextAlign.center,),
                duration: Duration(seconds: 1),style: textStyle),
            AnimatedDefaultTextStyle(
                child: Text('many times:', textAlign: TextAlign.center,),
                duration: Duration(seconds: 1),style: textStyle),
            AnimatedDefaultTextStyle(
                child: Text('$_counter', textAlign: TextAlign.center),
                duration: Duration(seconds: 1), style: textStyle),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
