import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class Person {
  final String name;
  final String addressLine1;
  final String addressCity;
  final String addressState;
  final List<Person> children;

  const Person(this.name, this.addressLine1, this.addressCity,
      this.addressState, this.children);

  // You write this serialization code.
  Map<String, dynamic> toJson() {
    var map = {
      'name': name,
      'addr': addressLine1,
      'city': addressCity,
      'state': addressState,
      'children': children
    };
    return map;
  }
  // You write this serialization code.

  @override
  String toString() {
    return 'Person{name: $name, addressLine1: $addressLine1, addressCity: $addressCity, addressState: $addressState, children: $children}';
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
  static const Person _grandchild =
      Person("Tracy Brown", "9625 Roberts Avenue", "Birmingham", "AL", []);
  static const Person _adultFather = const Person(
      "John Brown", "9625 Roberts Avenue", "Birmingham", "AL", [_grandchild]);
  static const Person _adultNoChildren =
      const Person("Jill Jones", "100 East Road", "Ocala", "FL", []);
  static const Person _grandfather = Person("John Brown", "9621 Roberts Avenue",
      "Birmingham", "AL", [_adultFather, _adultNoChildren]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recursive Serialization"),
        ),
        body: Center(
          child: Padding(
            child: ListView(
              children: <Widget>[
                Padding(
                    child: Text("Grandfather:\n${_grandfather}"),
                    padding: EdgeInsets.only(top: 0.0)),
                Padding(
                    child: Text("Json Encoded:\n${json.encode(_grandfather)}",
                        style: TextStyle(color: Colors.red)),
                    padding: EdgeInsets.only(top: 10.0)),
                FlatButton(
                    child: Text("Copy"),
                    onPressed: (() {
                      Clipboard.setData(
                          ClipboardData(text: "${json.encode(_grandfather)}"));
                    })),
                Padding(
                    child: Text("Adult Father:\n${_adultFather}"),
                    padding: EdgeInsets.only(top: 30.0)),
                Padding(
                    child: Text("Json Encoded:\n${json.encode(_adultFather)}",
                        style: TextStyle(color: Colors.red)),
                    padding: EdgeInsets.only(top: 10.0)),
                FlatButton(
                    child: Text("Copy"),
                    onPressed: (() {
                      Clipboard.setData(
                          ClipboardData(text: "${json.encode(_adultFather)}"));
                    })),
                Padding(
                    child: Text("Adult No Children:\n${_adultNoChildren}"),
                    padding: EdgeInsets.only(top: 30.0)),
                Padding(
                    child: Text(
                        "Json Encoded:\n${json.encode(_adultNoChildren)}",
                        style: TextStyle(color: Colors.red)),
                    padding: EdgeInsets.only(top: 10.0)),
                FlatButton(
                    child: Text("Copy"),
                    onPressed: (() {
                      Clipboard.setData(ClipboardData(
                          text: "${json.encode(_adultNoChildren)}"));
                    })),
                Padding(
                    child: Text("Grandchild:\n${_grandchild}"),
                    padding: EdgeInsets.only(top: 30.0)),
                Padding(
                    child: Text("Json Encoded:\n${json.encode(_grandchild)}",
                        style: TextStyle(color: Colors.red)),
                    padding: EdgeInsets.only(top: 10.0)),
                FlatButton(
                    child: Text("Copy"),
                    onPressed: (() {
                      Clipboard.setData(
                          ClipboardData(text: "${json.encode(_grandchild)}"));
                    })),
              ],
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ));
  }
}
