import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class Car {
  String _make;
  String _model;
  String _imageSrc;

  Car(this._make, this._model, this._imageSrc);

  operator ==(other) =>
      (other is Car) && (_make == other._make) && (_model == other._model);

  int get hashCode => _make.hashCode ^ _model.hashCode ^ _imageSrc.hashCode;
}

class CarsInheritedWidget extends InheritedWidget {
  List<Car> _cars = [
    Car(
      'Bmw',
      'M3',
      'https://media.ed.edmunds-media.com/bmw/m3/2018/oem/2018_bmw_m3_sedan_base_fq_oem_4_150.jpg',
    ),
    Car(
      'Nissan',
      'GTR',
      'https://media.ed.edmunds-media.com/nissan/gt-r/2018/oem/2018_nissan_gt-r_coupe_nismo_fq_oem_1_150.jpg',
    ),
    Car(
      'Nissan',
      'Sentra',
      'https://media.ed.edmunds-media.com/nissan/sentra/2017/oem/2017_nissan_sentra_sedan_sr-turbo_fq_oem_4_150.jpg',
    )
  ];

  CarsInheritedWidget(child) : super(child: child);

  List<Car> get cars {
    return _cars;
  }

  void addNissanSentra() {
    _cars.add(Car(
      'Nissan',
      'Sentra',
      'https://media.ed.edmunds-media.com/nissan/sentra/2017/oem/2017_nissan_sentra_sedan_sr-turbo_fq_oem_4_150.jpg',
    ));
  }

  @override
  bool updateShouldNotify(CarsInheritedWidget old) => true;

  static CarsInheritedWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CarsInheritedWidget));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You’ll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn’t reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: CarsInheritedWidget(MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    List<CarWidget> carWidgets =
        CarsInheritedWidget.of(context).cars.map((Car car) {
      return CarWidget(car);
    }).toList();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Cars'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  CarsInheritedWidget.of(context).addNissanSentra();
                })
          ],
        ),
        body: new ListView(children: carWidgets));
  }
}

class CarWidget extends StatelessWidget {
  CarWidget(this._car) : super();

  final Car _car;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Column(children: <Widget>[
              Text('${_car._make} ${_car._model}',
                  style: TextStyle(fontSize: 24.0)),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.network(_car._imageSrc))
            ]))));
  }
}
