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
  bool b = false;

  void _changeMode() {
    setState(() {
      b = !b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedContainer(
                color: b ? Colors.tealAccent : Colors.blueAccent,
                height: b ? 400.0 : 200.0,
                duration: Duration(seconds: 1),
                child: Center(
                    child: Text('Top',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center))),
            AnimatedContainer(
                color: b ? Colors.redAccent : Colors.orangeAccent,
                height: b ? 200.0 : 400.0,
                duration: Duration(seconds: 1),
                child: Center(
                    child: Text('Bottom',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeMode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
