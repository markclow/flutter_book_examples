import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef OnProgressListener = void Function(double percentage);
typedef OnLocationWeatherLoadedListener = void Function(
    LocationWeather weatherResult);
typedef OnErrorListener = void Function(dynamic error);

// -----------------------------------------------
// -----------------------------------------------
// Remember to add HTTP dependency to pubspec.yaml
// -----------------------------------------------
// -----------------------------------------------
void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherHomeWidget(title: 'Weather'),
    );
  }
}

class WeatherHomeWidget extends StatefulWidget {
  WeatherHomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WeatherHomeWidgetState createState() => _WeatherHomeWidgetState();
}

class _WeatherHomeWidgetState extends State<WeatherHomeWidget> {
  LocationWeatherLoaderManager _weatherLoaderManager;
  String _error = null;
  double _percentageComplete = null;
  Map<String, dynamic> _locationWeatherMap = {
    'atlanta': null,
    'new york': null,
    'chicago': null,
    'los angeles': null,
    'london': null,
    'tokyo': null,
    'sydney': null
  };

  _WeatherHomeWidgetState() {
    _weatherLoaderManager = new LocationWeatherLoaderManager(
        onProgressListener: handleProgress,
        onLocationWeatherLoadedListener: handleCompleted,
        onErrorListener: handleError);
  }

  // Click handler.
  void _loadWeather() {
    List<String> weatherLocationList = List.from(_locationWeatherMap.keys);
    _weatherLoaderManager.start(weatherLocationList);
  }

  // Handles progress callbacks from weather loader manager.
  void handleProgress(double percentage) {
    setState(() {
      _percentageComplete = percentage;
    });
  }

  // Handles completion from weather loader manager.
  void handleCompleted(LocationWeather locationWeather) {
    setState(() {
      _locationWeatherMap[locationWeather.location] = locationWeather.weather;
    });
  }

  // Handles error from weather loader manager.
  void handleError(err) {
    setState(() {
      _error = ('An unexpected error occurred: ${err}.');
      _percentageComplete = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    // Decide on what content to show to the user.
    if (_error != null) {
      mainContent = WeatherErrorWidget(_error);
    } else if (_percentageComplete == null) {
      mainContent = WeatherNotLoadedWidget();
    } else if (_percentageComplete < 1.0) {
      mainContent = WeatherLoadingWidget(_percentageComplete);
    } else {
      mainContent = WeatherLoadedWidget(_locationWeatherMap);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: mainContent,
      floatingActionButton: FloatingActionButton(
        onPressed: _loadWeather,
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WeatherErrorWidget extends StatelessWidget {
  String _error;

  WeatherErrorWidget(this._error);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("An unexpected error occurred: ${_error}",
          style: TextStyle(color: Colors.red)),
    );
  }
}

class WeatherNotLoadedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hit refresh to load the weather"),
    );
  }
}

class WeatherLoadedWidget extends StatelessWidget {
  // This widget is the root of your application.

  Map<String, dynamic> _locationWeatherMap;

  WeatherLoadedWidget(this._locationWeatherMap);

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    Iterator<String> it = _locationWeatherMap.keys.iterator;
    while (it.moveNext()) {
      String location = it.current;
      var weather = _locationWeatherMap[location];
      var firstWeatherReport = weather['consolidated_weather'][0];
      String description = firstWeatherReport['weather_state_name'];
      String windDirection = firstWeatherReport['wind_direction_compass'];
      double minTemp = firstWeatherReport['min_temp'];
      double maxTemp = firstWeatherReport['max_temp'];
      int humidity = firstWeatherReport['humidity'];
      tiles.add(GridTile(
          child: Column(children: [
        Spacer(),
        Text(location.toUpperCase(),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        Text(description,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        Text(
            "Wind Direction: ${windDirection}\n" +
                "Temp:${minTemp.toStringAsFixed(2)} - ${maxTemp.toStringAsFixed(2)}\n" +
                "Humidity: ${humidity}%",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        Spacer(),
      ])));
    }
    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        children: tiles);
  }
}

class WeatherLoadingWidget extends StatelessWidget {
  double _percentageComplete;

  WeatherLoadingWidget(this._percentageComplete);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            constraints: BoxConstraints.loose(Size(200, 50)),
            child: LinearProgressIndicator(
                value: _percentageComplete,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
      ],
    ));
  }
}

// Data object to store location and weather.
// Used to pass back location weather after it has been retrieved.
class LocationWeather {
  String location;
  dynamic weather;

  LocationWeather(this.location, this.weather);
}

// Isolate used to load all weather for each location.
// Note how the callbacks are passed to the constructor so they
// can be invoked later.
class LocationWeatherLoaderIsolate {
  LocationWeatherLoaderIsolate(
      {@required this.onProgressListener,
      @required this.onLocationWeatherLoadedListener,
      @required this.locationNames})
      : assert(onProgressListener != null),
        assert(onLocationWeatherLoadedListener != null),
        assert(locationNames != null);

  final OnProgressListener onProgressListener;
  final OnLocationWeatherLoadedListener onLocationWeatherLoadedListener;
  final List<String> locationNames;
  int _progress = 0;
  int _progressCount = 0;

  void run() {
    _progress = 0;
    _progressCount = locationNames.length * 3;
    for (int idx = 0, count = locationNames.length; idx < count; idx++) {
      loadLocationWeather(idx, count, locationNames[idx]);
    }
  }

  // Loads the weather for a specified location.
  //
  // This takes two http calls:
  // 1. Location lookup to get location identifier for location name.
  // 2. Location weather to get weather for location identifier.
  //
  Future<void> loadLocationWeather(int idx, int count, String location) async {
    _sendProgress();
    // change url below to test exception handling
    var url =
        'https://www.metaweather.com/api/location/search/?query=${location}';
    final locationLookupResponse =
        await http.get(url).timeout(Duration(seconds: 10));
    if (locationLookupResponse.statusCode == 200) {
      _sendProgress();
      final parsedLocationLookupResponse =
          json.decode(locationLookupResponse.body);
      final locationIdentifier =
          parsedLocationLookupResponse[0]['woeid']; //TODO Check nulls.
      // change url below to test exception handling
      var url =
          'https://www.metaweather.com/api/location/${locationIdentifier}/';
      final locationWeatherResponse =
          await http.get(url).timeout(Duration(seconds: 10));
      _sendProgress();
      if (locationWeatherResponse.statusCode == 200) {
        final parsedLocationWeatherResponse =
            json.decode(locationWeatherResponse.body);
        onLocationWeatherLoadedListener(
            LocationWeather(location, parsedLocationWeatherResponse));
      } else {
        throw Exception('Location weather failed');
      }
    } else {
      throw Exception('Location lookup failed');
    }
  }

  // Invoke progress update callback to move progress bar to the right.
  void _sendProgress() {
    _progress++;
    onProgressListener(_progress / _progressCount);
  }
}

// Data used to spawn isolate.
class IsolateEntryPointArgument {
  IsolateEntryPointArgument(this.cityNames, this.dataPort);

  List<String> cityNames;
  SendPort dataPort;
}

//
// Intermediary class between WeatherHomeWidget & LocationWeatherLoaderIsolate.
//
// Receives callbacks in constructor.
// Fires callbacks as required.
// Call 'start' method to get the ball rolling.
//
class LocationWeatherLoaderManager {
  LocationWeatherLoaderManager({
    @required this.onProgressListener,
    @required this.onLocationWeatherLoadedListener,
    @required this.onErrorListener,
  })  : assert(onProgressListener != null),
        assert(onLocationWeatherLoadedListener != null),
        _dataPort = ReceivePort(),
        _errorPort = ReceivePort() {
    _dataPort.listen(_handleDataMessage);
    _errorPort.listen(_handleError);
  }

  final OnProgressListener onProgressListener;
  final OnLocationWeatherLoadedListener onLocationWeatherLoadedListener;
  final OnErrorListener onErrorListener;
  final ReceivePort _dataPort; // Port of data communication with isolate.
  final ReceivePort _errorPort; // Port of error communication with isolate.

  start(List<String> cityNames) {
    final IsolateEntryPointArgument entryPointArgument =
        IsolateEntryPointArgument(cityNames, _dataPort.sendPort);
    Isolate.spawn<IsolateEntryPointArgument>(entryPoint, entryPointArgument,
            errorsAreFatal: true, onError: _errorPort.sendPort)
        .then<void>((Isolate isolate) {});
  }

  // Entrypoint in isolate.
  static void entryPoint(IsolateEntryPointArgument message) {
    final SendPort dataPort = message.dataPort;
    // Construct isolate with callbacks.
    final LocationWeatherLoaderIsolate dataLoader =
        LocationWeatherLoaderIsolate(
            onProgressListener: (double progress) {
              dataPort.send(progress);
            },
            onLocationWeatherLoadedListener: (LocationWeather weather) {
              dataPort.send(weather);
            },
            locationNames: message.cityNames);
    // Run isolate.
    dataLoader.run();
  }

  // Callback. Handles data message from isolate.
  void _handleDataMessage(dynamic message) {
    if (message is double) {
      onProgressListener(message);
    } else {
      onLocationWeatherLoadedListener(message);
    }
  }

  // Callback. Handles error message from isolate.
  void _handleError(dynamic error) {
    onErrorListener(error);
  }
}
