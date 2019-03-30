import 'package:flutter/material.dart';

void main() => runApp(new ListViewListTileApp());

class ListViewListTileApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeWidget(title: 'ListView & ListTile'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  static const TEXT_STYLE_NORMAL = const TextStyle(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.normal);
  static const TEXT_STYLE_SELECTED = const TextStyle(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);
  final TextFormField _fontSizeTextField = TextFormField(
      decoration: InputDecoration(
          icon: const Icon(Icons.format_size),
          hintText: 'Font Size',
          labelText: 'Enter the font size'));
  final TextFormField _historyTextFormField = TextFormField(
      decoration: InputDecoration(
          icon: const Icon(Icons.history),
          hintText: 'Days',
          labelText: 'Enter days'));
  final TextFormField _languageTextFormField = TextFormField(
      decoration: InputDecoration(
          icon: const Icon(Icons.language),
          hintText: 'Language',
          labelText: 'Enter your language'));

  select(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ListTile accessibilityListTile = ListTile(
        leading: Icon(Icons.accessibility),
        title: Text("Accessibility",
            style:
                _selectedIndex == 0 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL),
        subtitle: const Text("Accesibility Settings"),
        trailing: Icon(Icons.settings),
        onTap: () => select(0));

    final ListTile historyListTile = ListTile(
        leading: Icon(Icons.history),
        title: Text("History",
            style:
                _selectedIndex == 1 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL),
        subtitle: const Text("History Settings"),
        trailing: Icon(Icons.settings),
        onTap: () => select(1));

    final ListTile languageListTile = ListTile(
        leading: Icon(Icons.language),
        title: Text("Language",
            style:
                _selectedIndex == 2 ? TEXT_STYLE_SELECTED : TEXT_STYLE_NORMAL),
        subtitle: const Text("Language Settings"),
        trailing: Icon(Icons.settings),
        onTap: () => select(2));

    final String selectionTitle = (_selectedIndex == 0
            ? "Accessibility"
            : _selectedIndex == 1 ? "History" : "Language") +
        " Settings";

    final TextFormField selectionTextFormField = _selectedIndex == 0
        ? _fontSizeTextField
        : _selectedIndex == 1 ? _historyTextFormField : _languageTextFormField;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: ListView(children: <Widget>[
          accessibilityListTile,
          historyListTile,
          languageListTile
        ]),
        bottomSheet: Container(
            color: Color(0xFFB3E5FC),
            padding: EdgeInsets.all(20.0),
            child: Container(
                constraints: BoxConstraints(maxHeight: 200.0),
                child: Column(children: <Widget>[
                  Icon(Icons.settings),
                  Text(selectionTitle),
                  Expanded(child: selectionTextFormField)
                ]))));
  }
}
