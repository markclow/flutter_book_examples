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
      home: new HomeWidget(title: 'Button Enablement'),
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
  bool _checked = false;

  void _onCheck(val) {
    setState(() {
      _checked = val;
    });
  }

  void _onSubmit() {
    debugPrint("_onSubmit");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text('Please check below to agree to the terms.',
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Checkbox(value: _checked, onChanged: (val) => _onCheck(val)),
                Text("I agree")
              ]),
              OutlineButton(
                onPressed: _checked ? () => _onSubmit() : null,
                child: const Text('Register'),
              )
            ],
          ),
        ));
  }
}
