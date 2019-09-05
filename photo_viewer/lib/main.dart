import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Photo Viewer',
        theme: CupertinoThemeData(
        ),
        home: MyHomePage(title: 'Photo Viewer'),
      );
    }else {
      return MaterialApp(
        title: 'Photo Viewer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Photo Viewer'),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _selectedImageFile = null;

  void _selectPhoto() async {
    try {
      File file = await FilePicker.getFile(type: FileType.IMAGE);
      if (file == null) {
        return;
      }
      setState(() {
        this._selectedImageFile = file;
      });
    } on Exception catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var contentWidgets = <Widget>[];
    if (_selectedImageFile == null) {
      contentWidgets.add(Text(
        'Please select an image',
        style: Theme.of(context).textTheme.headline,
      ));
    } else {
      contentWidgets.add(Text(
        'Selected Image: ${_selectedImageFile.path}',
        style: Theme.of(context).textTheme.body1,
      ));
      contentWidgets.add(Image.file(_selectedImageFile));
    }

    var content = Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: contentWidgets,
          ),
          padding: EdgeInsets.all(20.0),
        );
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Text(widget.title),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Tooltip(
                message: 'Select Image',
                child: Text('Select...'),
                excludeFromSemantics: true,
              ),
              onPressed: _selectPhoto,
            )),
        child: content,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: _selectPhoto,
          tooltip: 'Select',
          child: Icon(Icons.select_all),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
