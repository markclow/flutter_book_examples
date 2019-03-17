import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

void main() => runApp(MyApp());

@JsonSerializable()
class Person extends Object with _$PersonSerializerMixin {
  final String name;
  @JsonKey(name: "addr1")
  final String addressLine1;
  @JsonKey(name: "city")
  final String addressCity;
  @JsonKey(name: "state")
  final String addressState;

  Person(this.name, this.addressLine1, this.addressCity, this.addressState);

  @override
  String toString() {
    return 'Person{name: $name, addressLine1: $addressLine1, addressCity: $addressCity, addressState: $addressState}';
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _jsonTextController = TextEditingController();
  Person _person;
  String _error;

  _HomeWidgetState() {
    final String person =
        "{\"name\":\"Tracy Brown\", \"addr1\":\"9625 Roberts Avenue\"," +
            "\"city\":\"Birmingham\", \"state\":\"AL\"}";

    _jsonTextController.text = person;
  }

  TextFormField _createJsonTextFormField() {
    return new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the json.';
          }
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Json',
            labelText: 'Enter the json for a person.'),
        controller: _jsonTextController,
        autofocus: true,
        maxLines: 8,
        keyboardType: TextInputType.multiline);
  }

  _convertJsonToPerson() {
    _error = null;
    _person = null;
    setState(() {
      try {
        final String jsonText = _jsonTextController.text;
        debugPrint("JSON TEXT: ${jsonText}");
        var decoded = json.decode(jsonText); // text to map
        debugPrint("DECODED:  type: ${decoded.runtimeType} value: ${decoded}");
        _person = _$PersonFromJson(decoded); // map to object
        debugPrint("PERSON OBJECT: type: ${_person.runtimeType} value: "
            "${_person}");
      } catch (e) {
        debugPrint("ERROR: ${e}");
        _error = e.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deserialization"),
      ),
      body: Center(
        child: Padding(
          child: ListView(
            children: <Widget>[
              _createJsonTextFormField(),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                      _error == null ? '' : 'An error occurred:\n\n${_error}',
                      style: TextStyle(color: Colors.red))),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(_person == null
                      ? 'Person is null'
                      : 'Converted to Person object:\n\n${_person}'))
            ],
          ),
          padding: EdgeInsets.all(10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _convertJsonToPerson,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
