import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

enum Language { english, spanish }

class Word {
  final int _id;
  final String _english;
  final String _spanish;

  Word(this._id, this._english, this._spanish);

  Map<String, dynamic> toMap() {
    return {'id': _id, 'english': _english, 'spanish': _spanish};
  }

  String get spanish => _spanish;

  String get english => _english;

  int get id => _id;

  operator ==(other) =>
      (other != null) && (other is Word) && (_id == other._id);

  int get hashCode => _id.hashCode;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DbWidget(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomeWidget()));
  }
}

class DbWidget extends InheritedWidget {
  final _random = new Random();
  Database _database;
  String _databasesPath;

  DbWidget({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  Future<bool> loadDatabasesPath() async {
    _databasesPath = await getDatabasesPath();
    return true;
  }

  Future<bool> openAndInitDatabase() async {
    _database = await openDatabase(
      join(_databasesPath, 'vocabulary.db'),
      onCreate: (db, version) {
        debugPrint("creating database...");
        db.execute("CREATE TABLE word(id INTEGER PRIMARY KEY, english TEXT, "
            "spanish TEXT, correct INTEGER, incorrect INTEGER)");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('uncle', 'tio')");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('reader', 'lector')");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('to keep vigil over', 'velar')");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('to remove', 'quitar')");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('to continue', 'reanudar')");
        db.execute("INSERT INTO word(english, spanish) "
            "VALUES ('until', 'hasta')");
        debugPrint("done");
      },
      version: 1,
    );
    return true;
  }

  Future<Word> loadNextWord(Word priorWord) async {
    final List<Map<String, dynamic>> words = await _database.query('word');
    final List<Word> list = List.generate(words.length, (i) {
      return Word(words[i]['id'], words[i]['english'], words[i]['spanish']);
    });

    Word nextWord = null;
    do {
      int nextWordIndex = _nextRandom(0, list.length);
      nextWord = list[nextWordIndex];
    } while (nextWord == priorWord);
    return nextWord;
  }

  Future<int> addWord(Word word) async {
    return await _database.insert(
      'word',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWord(Word word) async {
    return await _database.delete(
      'word',
      where: "id = ?",
      whereArgs: [word.id],
    );
  }

  static DbWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DbWidget) as DbWidget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  int _nextRandom(int min, int max) => min + _random.nextInt(max - min);
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loadedDatabasePath = false;
  bool _openedDatabase = false;
  Language _language = Language.spanish;
  Word _priorWord;
  Word _word;

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text('${error ? "An unexpected error occurred: " : ""}${content}'),
    ));
  }

  _loadDatabasesPath(BuildContext context) {
    try {
      DbWidget.of(context).loadDatabasesPath().then((b) {
        setState(() {
          _loadedDatabasePath = true;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  _openAndInitDatabase(BuildContext context) {
    try {
      DbWidget.of(context).openAndInitDatabase().then((b) {
        setState(() {
          _openedDatabase = true;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  _loadWord(BuildContext context) {
    try {
      DbWidget.of(context).loadNextWord(_priorWord).then((word) {
        setState(() {
          _word = word;
        });
      }).catchError((error) {
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showSnackBar(e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadedDatabasePath) {
      _loadDatabasesPath(context);
    } else if (!_openedDatabase) {
      _openAndInitDatabase(context);
    } else if (_word == null) {
      _loadWord(context);
    }

    WordWidget englishWordWidget =
        WordWidget(Language.english, _language, _word);
    WordWidget spanishWordWidget =
        WordWidget(Language.spanish, _language, _word);

    Column wordWidgets = _language == Language.spanish
        ? Column(children: [englishWordWidget, spanishWordWidget])
        : Column(children: [spanishWordWidget, englishWordWidget]);

    AppBar appBar = AppBar(title: Text("Vocabulary"), actions: <Widget>[
      IconButton(icon: Icon(Icons.shuffle), onPressed: () => _switchLanguage()),
      IconButton(icon: Icon(Icons.add), onPressed: () => _addWord(context)),
      IconButton(
          icon: Icon(Icons.remove), onPressed: () => _deleteWord(context))
    ]);

    return Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        body: wordWidgets,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh), onPressed: () => _loadNextWord()));
  }

  _loadNextWord() {
    setState(() {
      _priorWord = _word;
      _word = null;
    });
  }

  _switchLanguage() {
    Language newLanguage =
        _language == Language.spanish ? Language.english : Language.spanish;
    setState(() => _language = newLanguage);
  }

  _addWord(BuildContext context) async {
    Word word = await showDialog<Word>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child: AddDialogWidget());
        });
    if (word != null) {
      try {
        DbWidget.of(context).addWord(word).then((_) {
          _loadNextWord();
          _showSnackBar("Added word.");
        }).catchError((e) => _showSnackBar(e.toString(), error: true));
      } catch (e) {
        _showSnackBar(e.toString(), error: true);
      }
    }
  }

  _deleteWord(BuildContext context) {
    _showConfirmDialog(context, _word).then((result) {
      if (result == true) {
        try {
          DbWidget.of(context).deleteWord(_word).then((_) {
            _loadNextWord();
            _showSnackBar("Deleted word.");
          }).catchError((e) => _showSnackBar(e.toString(), error: true));
        } catch (e) {
          _showSnackBar(e.toString(), error: true);
        }
      }
    });
  }
}

class WordWidget extends StatefulWidget {
  WordWidget(this._widgetLanguage, this._language, this._word) {}

  final Language _widgetLanguage;
  final Language _language;
  final Word _word;

  @override
  _WordWidgetState createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget> {
  bool _revealed = false;

  _WordWidgetState() {}

  @override
  void didUpdateWidget(Widget oldWidget) {
    _revealed = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isReveal = widget._widgetLanguage == widget._language;

    List<Widget> widgets = [];

    String titleText = isReveal
        ? "What's the word in ${getLanguageName(widget._widgetLanguage)}?"
        : "Word in ${getLanguageName(widget._widgetLanguage)} is:";

    widgets.add(Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Text(titleText,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center)));

    if ((isReveal) && (!_revealed)) {
      widgets.add(FloatingActionButton(
          child: Icon(Icons.remove_red_eye),
          onPressed: () => {setState(() => _revealed = true)}));
    } else {
      String word = widget._word == null
          ? ""
          : widget._widgetLanguage == Language.english
              ? widget._word._english
              : widget._word._spanish;
      widgets.add(Text(
        word,
        style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ));
    }

    return Expanded(
        child: Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.white.withOpacity(0.3), BlendMode.dstATop),
          image: NetworkImage(widget._widgetLanguage == Language.english
              ? "https://upload.wikimedia.org/wikipedia/en/thumb/a/ae/" +
                  "Flag_of_the_United_Kingdom.svg/" +
                  "510px-Flag_of_the_United_Kingdom.svg.png"
              : "https://upload.wikimedia.org/wikipedia/en/thumb/9/9a/" +
                  "Flag_of_Spain.svg/400px-Flag_of_Spain.svg.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(10.0),
    ));
  }

  String getLanguageName(Language language) {
    return widget._widgetLanguage == Language.spanish ? "Spanish" : "English";
  }
}

class AddDialogWidget extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController _englishTextController =
      new TextEditingController();
  static final TextEditingController _spanishTextController =
      new TextEditingController();

  AddDialogWidget() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 260.0,
        width: 250.0,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Add Word",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the word in English.';
                            }
                          },
                          decoration: InputDecoration(
                              icon: const Icon(Icons.location_city),
                              hintText: 'English',
                              labelText: 'Enter the word in English'),
                          onSaved: (String value) {},
                          controller: _englishTextController),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the word in Spanish.';
                            }
                          },
                          decoration: InputDecoration(
                              icon: const Icon(Icons.location_city),
                              hintText: 'Spanish',
                              labelText: 'Enter the word in Spanish'),
                          onSaved: (String value) {},
                          controller: _spanishTextController),
                      FlatButton(
                          child: Text("Add"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.pop(
                                  context,
                                  Word(null, _englishTextController.text,
                                      _spanishTextController.text));
                              _englishTextController.text = "";
                              _spanishTextController.text = "";
                            }
                          })
                    ]))));
  }
}

Future<bool> _showConfirmDialog(BuildContext context, Word word) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(
              'Are you sure you want to delete the word "${word.english}?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            )
          ],
        );
      });
}
