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
      ),
      home: new NewsfeedWidget(title: 'News Feed'),
    );
  }
}

class News {
  DateTime _dt;
  String _title;
  String _text;

  News(this._dt, this._title, this._text);
}

class NewsCard extends StatelessWidget {
  News _news;

  NewsCard(this._news);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network("https://www.bbc.co"
                        ".uk/news/special/2015/newsspec_10857/bbc_news_logo.png?cb=1"),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text(
                          "${_news._dt.month}//${_news._dt.day}/${_news._dt.year}",
                          style: TextStyle(
                              fontSize: 10.0, fontStyle: FontStyle.italic),
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text("${_news._title}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold))),
                    Text(
                      "${_news._text}",
                      maxLines: 2,
                      style: TextStyle(fontSize: 14.0),
                      overflow: TextOverflow.fade,
                    ),
                    Row(children: [
                      FlatButton(child: Text("Share"), onPressed: () => {}),
                      FlatButton(child: Text("Bookmark"), onPressed: () => {}),
                      FlatButton(child: Text("Link"), onPressed: () => {})
                    ])
                  ],
                ))));
  }
}

class NewsfeedWidget extends StatelessWidget {
  NewsfeedWidget({Key key, this.title}) : super(key: key);

  final String title;
  List<News> _newsList = [
    News(
        DateTime(2018, 12, 1),
        "Mass shooting in Atlanta",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet " +
            "tortor pretium, interdum magna sed, pulvinar ligula."),
    News(
        DateTime(2019, 1, 12),
        "Carnival clown found drunk in Misisippi",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet " +
            "tortor pretium, interdum magna sed, pulvinar ligula."),
    News(
        DateTime(2019, 2, 12),
        "Walrus found in family pool in Florida",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin sit amet " +
            "tortor pretium, interdum magna sed, pulvinar ligula."),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> newsCards = _newsList.map((news) => NewsCard(news)).toList();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("News Feed"),
        ),
        body: new ListView(padding: EdgeInsets.all(20.0), children: newsCards));
  }
}
