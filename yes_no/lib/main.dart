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
          scaffoldBackgroundColor: Colors.teal),
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

  _yesOnTap() {
    print('yes');
  }

  _noOnTap() {
    print('no');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Do you want to\nbuy this item?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w200)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                SelectButton(text: "YES", onTap: _yesOnTap),
                Spacer(),
                SelectButton(text: "NO", onTap: _noOnTap),
                Spacer(flex: 2),
              ],
            )
          ]),
    );
  }
}

class SelectButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  SelectButton({@required this.text, @required this.onTap});

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _circleTween;
  Animation<Color> _textTween;

  @override
  void initState() {
    // Create animation controller.
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..addListener(() {
            setState(() {
              // Force build.
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              waitThenReset();
            }
          });

    // Create tweens.
    _circleTween = new ColorTween(
      begin: Colors.teal,
      end: Colors.white,
    ).animate(_controller);

    _textTween = new ColorTween(
      begin: Colors.white,
      end: Colors.teal,
    ).animate(_controller);
  }

  Future waitThenReset() async {
    await new Future.delayed(new Duration(milliseconds: 1000), () {
      _controller.reverse(from: 0.9);
      widget.onTap();
    });
  }

  _onTap() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    double leftPos = widget.text.length == 3 ? 22.0 : 27.0;
    return GestureDetector(
      onTap: _onTap,
      child: Material(
          type: MaterialType.transparency,
          child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                color: _circleTween.value,
                shape: BoxShape.circle,
              ),
              width: 100.0,
              height: 100.0,
              child: Padding(
                  padding: EdgeInsets.only(left: leftPos, top: 32.0),
                  child: Text(widget.text,
                      style: TextStyle(
                          color: _textTween.value,
                          fontSize: 28.0,
                          fontWeight:
                              _controller.status == AnimationStatus.completed
                                  ? FontWeight.w500
                                  : FontWeight.w200))))),
    );
  }
}
