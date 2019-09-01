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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build');
    var appBar = AppBar(title: Text("Responsive UI"));
    var scaffold = Scaffold(
        appBar: appBar,
        body: OrientationBuilder(
          builder: (context, orientation) {
            print('orientation builder');
            var screenHeight = MediaQuery.of(context).size.height;
            var statusBarHeight = MediaQuery.of(context).padding.top;
            var appBarHeight = appBar.preferredSize.height;
            var availableScreenHeight =
                screenHeight - statusBarHeight - appBarHeight;
            var remainderText =
                "Remaining Area\n(${orientation == Orientation.portrait ? "Portrait" : "Landscape"})";
            return Column(children: <Widget>[
              // columns are vertical
              Container(
                color: Colors.red,
                child: Center(
                    child: Text('10% height full width',
                        style: TextStyle(color: Colors.white))),
                height: availableScreenHeight / 10,
              ),
              Expanded(
                  // use the remaining height
                  child: Container(
                      color: Colors.red,
                      child: Row(children: [
                        // rows are horizontal
                        Container(
                          color: Colors.green,
                          child: Center(
                              child: Text('10% width\nfull height',
                                  style: TextStyle(color: Colors.white))),
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        Expanded(
                            // use the remaining width
                            child: Container(
                          color: Colors.yellow,
                          child: Center(
                              child: Text(
                            remainderText,
                            style: TextStyle(fontSize: 20.0),
                          )),
                        ))
                      ])))
            ]);
          },
        ));
    return scaffold;
  }
}
