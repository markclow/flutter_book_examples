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
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const List<dynamic> LIST_DATA = [
    {
      "Name": "Mach 6, High Reynolds Number Facility",
      "Address": "1864 4th St",
      "City": "Wright-Patterson AFB",
      "State": "OH",
      "ZIP": "45433-7541",
      "Country": "US"
    },
    {
      "Name": "Subsonic Aerodynamic Research Laboratory",
      "Address": "1864 4th St",
      "City": "Wright-Patterson AFB",
      "State": "OH",
      "ZIP": "45433-7541",
      "Country": "US"
    },
    {
      "Name": "Trisonic Gasdynamics Facility",
      "Address": "1864 4th St",
      "City": "Wright-Patterson AFB",
      "State": "OH",
      "ZIP": "45433-7541",
      "Country": "US"
    },
    {
      "Name": "N221A - 20-G AND HUMAN POWER CENTRIFUGE (PAPAC)",
      "Address": "Code RC",
      "City": "Moffett Field",
      "State": "CA",
      "ZIP": "94035",
      "Country": "US"
    },
    {
      "Name":
          "N229 - EXPER. AEROTHERMODYNAMIC FAC.: ELECTRIC ARC SHOCK TUBE FACILITY (PAPAC)",
      "Address": "Code RC",
      "City": "Moffett Field",
      "State": "CA",
      "ZIP": "94035",
      "Country": "US"
    }
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    var searchContainer = Expanded(
        child: Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Search by name:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(),
            RaisedButton(child: Text("Search"))
          ],
        ),
      ),
      padding: EdgeInsets.all(10.0),
    ));
    var listContainer = Expanded(
        child: Container(
          child: ListView.builder(
              itemCount: LIST_DATA.length,
              itemBuilder: (context, index) {
                print('invoking itemBuilder for row ${index}');
                var nasaOffice = LIST_DATA[index];
                return ListTile(
                    leading: const Icon(Icons.explore),
                    title: Text('${nasaOffice['Name']}'),
                    subtitle:
                        Text('${nasaOffice['Address']}, ${nasaOffice['City']},'
                            '${nasaOffice['State']}, ${nasaOffice['ZIP']},'
                            '${nasaOffice['Country']}'),
                    trailing: Icon(Icons.arrow_right));
              }),
            padding: EdgeInsets.all(10.0)
        ),
        flex: 2);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Responsive"),
        ),
        body: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          debugPrint('layout builder max width: ${constraints.maxWidth}');
          if (constraints.maxWidth > 600.0) {
            return Row(children: <Widget>[searchContainer, listContainer]);
          } else {
            return Column(children: <Widget>[searchContainer, listContainer]);
          }
        }));
  }
}
