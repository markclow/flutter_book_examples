import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: const TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ),
      home: new HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _textEditingControllers = [];
  List<Widget> _widgets = [];

  HomeWidget({Key key}) : super(key: key) {
    List<String> fieldNames = [
      "First Name",
      "Last Name",
      "Address 1",
      "Address 2",
      "City",
      "State",
      "Zip"
    ];
    for (int i = 0, ii = fieldNames.length; i < ii; i++) {
      String fieldName = fieldNames[i];
      TextEditingController textEditingController =
          new TextEditingController(text: "");
      _textEditingControllers.add(textEditingController);
      _widgets.add(Padding(
        child: _createTextFormField(fieldName, i > 1, textEditingController),
        padding: EdgeInsets.all(10.0),
      ));
    }
    _widgets.add(RaisedButton(
      onPressed: () {
        _formKey.currentState.validate();
      },
      child: new Text('Save'),
    ));
  }

  TextFormField _createTextFormField(
      String fieldName, bool enabled, TextEditingController controller) {
    return new TextFormField(
        enabled: enabled,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter ${fieldName}.';
          }
        },
        decoration: InputDecoration(
            icon: const Icon(Icons.person),
            hintText: fieldName,
            labelText: 'Enter ${fieldName}'),
        controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Input Decoration Themes"),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: _widgets,
                ))));
  }
}
