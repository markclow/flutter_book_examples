import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const Person(
      this.name, this.addressLine1, this.addressCity, this.addressState);

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

class HomeWidget extends StatelessWidget {
  static const Person _person =
      Person("John Brown", "9621 Roberts Avenue", "Birmingham", "AL");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Serialization"),
        ),
        body: Center(
          child: Padding(
            child: ListView(
              children: <Widget>[
                Padding(
                    child: Text("Grandfather:\n${_person}"),
                    padding: EdgeInsets.only(top: 0.0)),
                Padding(
                    child: Text("Json Encoded:\n${json.encode(_person)}",
                        style: TextStyle(color: Colors.red)),
                    padding: EdgeInsets.only(top: 10.0)),
                FlatButton(
                    child: Text("Copy"),
                    onPressed: (() {
                      Clipboard.setData(
                          ClipboardData(text: "${json.encode(_person)}"));
                    })),
              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ));
  }
}
