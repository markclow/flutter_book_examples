import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  DateTime _dt = DateTime.now();
  double _db = 12.456;

  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internationalization"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 1),
            Text(
              'Date ${_dt.month}/${_dt.day}/${_dt.year}',
            ),
            Text(
              'Date (Date Formatter Year Month Day) ${DateFormat.yMd().format(_dt)}',
            ),
            Spacer(flex: 2),
            Text(
              'Number ${_db}',
            ),
            Text(
              'Number (NumberFormat Decimal) ${NumberFormat.decimalPattern().format(_db)}',
            ),
            Text(
              'Number (NumberFormat Decimal Compact) ${NumberFormat.compact().format(_db)}',
            ),
            Text(
              'Number (NumberFormat Currency) ${NumberFormat.currency().format(_db)}',
            ),
            Text(
              'Number (NumberFormat Compact Currency) ${NumberFormat.compactCurrency().format(_db)}',
            ),
            Text(
              'Number (NumberFormat Simple Currency) ${NumberFormat.simpleCurrency().format(_db)}',
            ),
            Text(
              'Number (NumberFormat Simple Currency YEN) ${NumberFormat.simpleCurrency(name:"JPY").format(_db)}',
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
