import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(AppWidget());

class AppWidget extends StatefulWidget {
  AppWidget() {
    debugPrint("AppWidget - constructor - " + hashCode.toString());
  }

  @override
  _AppWidgetState createState() {
    debugPrint("AppWidget - createState - " + hashCode.toString());
    return _AppWidgetState();
  }
}

class _AppWidgetState extends State<AppWidget> {
  bool _bright = false;

  _brightnessCallback() {
    setState(() => _bright = !_bright);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_AppWidgetState - build - " + hashCode.toString());
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: _bright ? Brightness.light : Brightness.dark),
        home: FlowerWidget(
            imageSrc: _bright
                ? "https://www.viewbug.com/media/mediafiles/" +
                    "2015/07/05/56234977_large1300.jpg"
                : "https://images.unsplash.com/" +
                    "photo-1531603071569-0dd65ad72d53?ixlib=rb-1.2.1&ixid=" +
                    "eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
            brightnessCallback: _brightnessCallback));
  }
}

class FlowerWidget extends StatefulWidget {
  final String imageSrc;
  final VoidCallback brightnessCallback;

  FlowerWidget({Key key, this.imageSrc, this.brightnessCallback})
      : super(key: key) {
    debugPrint("FlowerWidget - constructor - " + hashCode.toString());
  }

  @override
  _FlowerWidgetState createState() {
    debugPrint("FlowerWidget - createState - " + hashCode.toString());
    return _FlowerWidgetState();
  }
}

class _FlowerWidgetState extends State<FlowerWidget> {
  double _blur = 0;

  _FlowerWidgetState() {
    debugPrint("_FlowerWidgetState - constructor - " + hashCode.toString());
  }

  @override
  initState() {
    debugPrint("_FlowerWidgetState - initState - " + hashCode.toString());
  }

  /**
   * Fired when Flutter detects that the data from another source has changed,
   * possibly affecting the UI and causing a call to ‘build’.
   * In this case it is when the Theme changes (its an InheritedWidget).
   */
  @override
  void didChangeDependencies() {
    debugPrint(
        "_FlowerWidgetState - didChangeDependencies - " + hashCode.toString());
  }

  @override
  /**
   * Fired when the widget is reconstructed as its widget data has changed,
   * In this case it is when a new FlowerWidget is created with a different
   * imageSrc.
   */
  void didUpdateWidget(Widget oldWidget) {
    debugPrint("_FlowerWidgetState - didUpdateWidget - " + hashCode.toString());

    // The flower image has changed, so reset the blur.
    _blur = 0;
  }

  void _blurMore() {
    setState(() {
      _blur += 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_FlowerWidgetState - build - " + hashCode.toString());
    return Scaffold(
      appBar: AppBar(title: Text("Flower"), actions: [
        new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              widget.brightnessCallback();
            })
      ]),
      body: new Container(
        decoration: new BoxDecoration(
            // dependency on inherited widget - start
            color: Theme.of(context).backgroundColor,
            // dependency on inherited widget - end
            image: new DecorationImage(
                // dependency on data from widget - start
                image: NetworkImage(widget.imageSrc),
                // dependency on data from widget - end
                fit: BoxFit.cover)),
        child: new BackdropFilter(
          // dependency on state data - start
          filter: new ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
          // dependency on state data - end
          child: new Container(
            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _blurMore,
        tooltip: 'Blur More',
        child: Icon(Icons.add),
      ),
    );
  }
}
