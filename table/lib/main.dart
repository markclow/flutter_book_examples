import 'package:flutter/material.dart';

void main() => runApp(new TableApp());

class TableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TableRow tableRow = TableRow(children: [
      const Text("aaaaaaaaaaaaaaaaaaaaa", overflow: TextOverflow.fade),
      const Text("bbbbbbbbbbbbbbbbbbbbb", overflow: TextOverflow.fade),
      const Text("ccccccccccccccccccccc", overflow: TextOverflow.ellipsis)
    ]);
    return new Scaffold(
        appBar: new AppBar(title: new Text("Table")),
        body: new Table(
          children: [
            tableRow,
            tableRow,
            tableRow,
            tableRow,
            tableRow,
            tableRow,
            tableRow,
            tableRow,
            tableRow,
          ],
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(0.1),
            1: FlexColumnWidth(0.3),
            2: FlexColumnWidth(0.6),
          },
          border: TableBorder.all(),
        ) // end table,
        );
  }
}
