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
      home: new MyHomePage(title: 'Cars'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
        ),
        body: new ListView(children: <Widget>[
          CarWidget("Bmw", "M3",
              "https://media.ed.edmunds-media.com/bmw/m3/2018/oem/2018_bmw_m3_sedan_base_fq_oem_4_150.jpg"),
          CarWidget("Nissan", "GTR",
              "https://media.ed.edmunds-media.com/nissan/gt-r/2018/oem/2018_nissan_gt-r_coupe_nismo_fq_oem_1_150.jpg"),
          CarWidget("Nissan", "Sentra",
              "https://media.ed.edmunds-media.com/nissan/sentra/2017/oem/2017_nissan_sentra_sedan_sr-turbo_fq_oem_4_150.jpg"),
        ]));
  }
}

class CarWidget extends StatelessWidget {
  CarWidget(this.make, this.model, this.imageSrc) : super();

  final String make;
  final String model;
  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Column(children: <Widget>[
              Text('${make} ${model}', style: TextStyle(fontSize: 24.0)),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.network(imageSrc))
            ]))));
  }
}
