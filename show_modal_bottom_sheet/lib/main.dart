import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Name {
  String firstName = "";
  String lastName = "";

  Name({@required this.firstName, @required this.lastName});
}

class NameWidget extends StatefulWidget {
  Name _name;

  NameWidget(this._name) : super() {}

  @override
  State<StatefulWidget> createState() {
    return NameWidgetState(this._name);
  }
}

class NameWidgetState extends State<NameWidget> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  NameWidgetState(Name name) {
    this._firstNameController = TextEditingController(text: name.firstName);
    this._lastNameController = TextEditingController(text: name.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, (MediaQuery.of(context).viewInsets.bottom) + 20.0),
        child: ListView(children: <Widget>[
          TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: "First Name")),
          TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: "Last Name")),
          FlatButton(
            child: Text("Apply"),
            onPressed: () {
              if ((!_firstNameController.text.isEmpty) &&
                  (!_lastNameController.text.isEmpty)) {
                Navigator.pop(
                    context,
                    Name(
                        firstName: this._firstNameController.text,
                        lastName: this._lastNameController.text));
              }
            },
          )
        ]));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Name _name = Name(firstName: "", lastName: "");

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<Name>(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
              // gesture detector stops bottom sheet from closing when tapped
              onTap: () {},
              child: NameWidget(_name),
              behavior: HitTestBehavior.opaque);
        }).then((Name name) {
      if (name != null) {
        setState(() {
          this._name.firstName = name.firstName;
          this._name.lastName = name.lastName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Modal Bottom Sheet"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your First Name: ${_name.firstName}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text('Your Last Name: ${_name.lastName}',
                style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showModalBottomSheet(context),
        label: Text("Specify Name", style: TextStyle(fontSize: 16.0)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
