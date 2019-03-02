import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new CarAppWidget());

class Car {
  String _make;
  String _model;
  String _imageSrc;

  Car(this._make, this._model, this._imageSrc);

  operator ==(other) =>
      (other is Car) && (_make == other._make) && (_model == other._model);

  int get hashCode => _make.hashCode ^ _model.hashCode ^ _imageSrc.hashCode;
}

class CarListModel extends Model {
  List<Car> _carList = [
    Car(
      "Bmw",
      "M3",
      "https://media.ed.edmunds-media.com/bmw/m3/2018/oem/2018_bmw_m3_sedan_base_fq_oem_4_150.jpg",
    ),
    Car(
      "Nissan",
      "GTR",
      "https://media.ed.edmunds-media.com/nissan/gt-r/2018/oem/2018_nissan_gt-r_coupe_nismo_fq_oem_1_150.jpg",
    ),
    Car(
      "Nissan",
      "Sentra",
      "https://media.ed.edmunds-media.com/nissan/sentra/2017/oem/2017_nissan_sentra_sedan_sr-turbo_fq_oem_4_150.jpg",
    )
  ];

  List<Car> get carList => _carList;

  void add(String make, String model, String imageSrc) {
    _carList.add(Car(make, model, imageSrc));
    notifyListeners();
  }
}

class CarSelectionModel extends Model {
  Car _selectedCar;

  Car get selectedCar => _selectedCar;

  void set selectedCar(Car selectedCar) {
    _selectedCar = selectedCar;
    notifyListeners();
  }

  bool isSelected(Car car) {
    if (_selectedCar == null) {
      return false;
    } else {
      return car == _selectedCar;
    }
  }
}

class CarAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Car App',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScopedModel<CarListModel>(
            model: CarListModel(),
            child: ScopedModel<CarSelectionModel>(
                model: CarSelectionModel(),
                child: CarAppLayoutWidget(title: 'Cars'))));
  }
}

class CarAppLayoutWidget extends StatelessWidget {
  CarAppLayoutWidget({Key key, this.title}) : super(key: key);
  final String title;

  _addCar(BuildContext context) {
    ScopedModel.of<CarListModel>(context, rebuildOnChange: true).add(
        "Subaru",
        "WRX",
        "https://media.ed.edmunds-media"
        ".com/subaru/wrx/2018/oem/2018_subaru_wrx_sedan_sti-limited_s_oem_1_150"
        ".jpg");
  }

  String _calculateSelectedCarName(BuildContext context) {
    Car selectedCar =
        ScopedModel.of<CarSelectionModel>(context, rebuildOnChange: true)
            .selectedCar;

    if (selectedCar == null) {
      return "No car selected.";
    } else {
      return "Selected: ${selectedCar._make} ${selectedCar._model}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: Center(child: CarListWidget()),
        persistentFooterButtons: <Widget>[
          Text(_calculateSelectedCarName(context)),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addCar(context);
              }),
        ]);
  }
}

class CarListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carList =
        ScopedModel.of<CarListModel>(context, rebuildOnChange: true).carList;
    List<CarWidget> carWidgets = carList.map((Car car) {
      return CarWidget(car);
    }).toList();
    return new ListView(children: carWidgets);
  }
}

class CarWidget extends StatelessWidget {
  CarWidget(this._car) : super();

  final Car _car;

  _buildCarWidget(context, child, CarSelectionModel selectionModel) {
    return GestureDetector(
        onTap: () => selectionModel.selectedCar = _car,
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: selectionModel.isSelected(_car)
                        ? Colors.blue
                        : Colors.white),
                padding: EdgeInsets.all(20.0),
                child: Center(
                    child: Column(children: <Widget>[
                  Text('${_car._make} ${_car._model}',
                      style: TextStyle(fontSize: 24.0)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Image.network(_car._imageSrc))
                ])))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarSelectionModel>(
        builder: (context, child, selectionModel) =>
            _buildCarWidget(context, child, selectionModel));
  }
}
