import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() => runApp(new MyApp());

class PersonInfo {
  String _fname = "";
  String _lname = "";
  String _sex = "m";
  String _addr1 = "";
  String _addr2 = "";
  String _city = "";
  String _state = "";
  String _zip = "";
  bool _fiveYears = false;
  DateTime _dob;

  PersonInfo(this._fname, this._lname, this._sex, this._addr1, this._addr2,
      this._city, this._state, this._zip, this._fiveYears, this._dob);

  PersonInfo.empty();

  String get fname => _fname;
  String get lname => _lname;
  String get sex => _sex;
  String get addr1 => _addr1;
  String get addr2 => _addr2;
  String get city => _city;
  String get state => _state;
  String get zip => _zip;
  bool get fiveYears => _fiveYears;
  DateTime get dob => _dob;

  @override
  String toString() {
    return 'PersonInfo{_fname: $_fname, _lname: $_lname, _sex: $_sex, _addr1: $_addr1, _addr2: $_addr2, _city: $_city, _state: $_state, _zip: $_zip, _fiveYears: $_fiveYears, _dob: $_dob}';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  PersonInfo _address = PersonInfo.empty();

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(_address);
}

class _HomePageState extends State<HomePage> {
  PersonInfo _address;

  _HomePageState(this._address);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Please enter your Details"),
        ),
        body: new Center(
            child: new ListView(children: [
          Padding(
              padding: EdgeInsets.all(20.0),
              child: AddressWidget(address: _address, onSaved: _onSaved))
        ])));
  }

  _onSaved(PersonInfo address) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Address'),
            content: Text(address.toString()),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }
}

class AddressWidget extends StatefulWidget {
  PersonInfo _address;
  ValueChanged<PersonInfo> _onSaved;

  AddressWidget(
      {Key key,
      @required PersonInfo address,
      @required ValueChanged<PersonInfo> onSaved})
      : super(key: key) {
    this._address = address;
    this._onSaved = onSaved;
  }

  @override
  _AddressWidgetState createState() => new _AddressWidgetState(_address);
}

class _AddressWidgetState extends State<AddressWidget> {
  static const STATE_DROPDOWN_MENU_ITEMS = [
    DropdownMenuItem(value: "AL", child: const Text("Alabama")),
    DropdownMenuItem(value: "AK", child: const Text("Alaska")),
    DropdownMenuItem(value: "AZ", child: const Text("Arizona")),
    DropdownMenuItem(value: "AR", child: const Text("Arkansas")),
    DropdownMenuItem(value: "CA", child: const Text("California")),
    DropdownMenuItem(value: "CO", child: const Text("Colorado")),
    DropdownMenuItem(value: "CT", child: const Text("Connecticut")),
    DropdownMenuItem(value: "DE", child: const Text("Delaware")),
    DropdownMenuItem(value: "DC", child: const Text("District Of Columbia")),
    DropdownMenuItem(value: "FL", child: const Text("Florida")),
    DropdownMenuItem(value: "GA", child: const Text("Georgia")),
    DropdownMenuItem(value: "HI", child: const Text("Hawaii")),
    DropdownMenuItem(value: "ID", child: const Text("Idaho")),
    DropdownMenuItem(value: "IL", child: const Text("Illinois")),
    DropdownMenuItem(value: "IN", child: const Text("Indiana")),
    DropdownMenuItem(value: "IA", child: const Text("Iowa")),
    DropdownMenuItem(value: "KS", child: const Text("Kansas")),
    DropdownMenuItem(value: "KY", child: const Text("Kentucky")),
    DropdownMenuItem(value: "LA", child: const Text("Louisiana")),
    DropdownMenuItem(value: "ME", child: const Text("Maine")),
    DropdownMenuItem(value: "MD", child: const Text("Maryland")),
    DropdownMenuItem(value: "MA", child: const Text("Massachusetts")),
    DropdownMenuItem(value: "MI", child: const Text("Michigan")),
    DropdownMenuItem(value: "MN", child: const Text("Minnesota")),
    DropdownMenuItem(value: "MS", child: const Text("Mississippi")),
    DropdownMenuItem(value: "MO", child: const Text("Missouri")),
    DropdownMenuItem(value: "MT", child: const Text("Montana")),
    DropdownMenuItem(value: "NE", child: const Text("Nebraska")),
    DropdownMenuItem(value: "NV", child: const Text("Nevada")),
    DropdownMenuItem(value: "NH", child: const Text("New Hampshire")),
    DropdownMenuItem(value: "NJ", child: const Text("New Jersey")),
    DropdownMenuItem(value: "NM", child: const Text("New Mexico")),
    DropdownMenuItem(value: "NY", child: const Text("New York")),
    DropdownMenuItem(value: "NC", child: const Text("North Carolina")),
    DropdownMenuItem(value: "ND", child: const Text("North Dakota")),
    DropdownMenuItem(value: "OH", child: const Text("Ohio")),
    DropdownMenuItem(value: "OK", child: const Text("Oklahoma")),
    DropdownMenuItem(value: "OR", child: const Text("Oregon")),
    DropdownMenuItem(value: "PA", child: const Text("Pennsylvania")),
    DropdownMenuItem(value: "RI", child: const Text("Rhode Island")),
    DropdownMenuItem(value: "SC", child: const Text("South Carolina")),
    DropdownMenuItem(value: "SD", child: const Text("South Dakota")),
    DropdownMenuItem(value: "TN", child: const Text("Tennessee")),
    DropdownMenuItem(value: "TX", child: const Text("Texas")),
    DropdownMenuItem(value: "UT", child: const Text("Utah")),
    DropdownMenuItem(value: "VT", child: const Text("Vermont")),
    DropdownMenuItem(value: "VA", child: const Text("Virginia")),
    DropdownMenuItem(value: "WA", child: const Text("Washington")),
    DropdownMenuItem(value: "WV", child: const Text("West Virginia")),
    DropdownMenuItem(value: "WI", child: const Text("Wisconsin")),
    DropdownMenuItem(value: "WY", child: const Text("Wyoming"))
  ];

  final _formKey = GlobalKey<FormState>();
  String _state = STATE_DROPDOWN_MENU_ITEMS[0].value;
  TextEditingController _fnameTextController;
  TextEditingController _lnameTextController;
  String _sex = "m";
  TextEditingController _addr1TextController;
  TextEditingController _addr2TextController;
  TextEditingController _cityTextController;
  TextEditingController _zipTextController;
  bool _fiveYears = false;
  DateFormat _dateFormat = DateFormat("MMM d yyyy");
  TextEditingController _dobTextController;

  _AddressWidgetState(final PersonInfo address) {
    _fnameTextController = TextEditingController(text: address.fname);
    _lnameTextController = TextEditingController(text: address.lname);
    _sex = address.sex;
    _addr1TextController = TextEditingController(text: address.addr1);
    _addr2TextController = TextEditingController(text: address.addr2);
    _cityTextController = TextEditingController(text: address.city);
    _zipTextController = TextEditingController(text: address.state);
    _fiveYears = address.fiveYears;
    _dobTextController = TextEditingController(
        text: address.dob != null ? _dateFormat.format(address.dob) : "");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgetList = new List();
    formWidgetList.add(createFNameWidget());
    formWidgetList.add(createLNameWidget());
    formWidgetList.add(createSexWidget());
    formWidgetList.add(createAddr1Widget());
    formWidgetList.add(createAddr2Widget());
    formWidgetList.add(createCityWidget());
    formWidgetList.add(createStateWidget());
    formWidgetList.add(createZipWidget());
    formWidgetList.add(createFiveYearsWidget());
    formWidgetList.add(createDobWidget());
    formWidgetList.add(RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          PersonInfo address = createDataObjectFromFormData();
          widget._onSaved(address);
        }
      },
      child: new Text('Save'),
    ));

    return Form(key: _formKey, child: Column(children: formWidgetList));
  }

  TextFormField createFNameWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your first name.';
        }
      },
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'First name',
          labelText: 'Enter your first name'),
      onSaved: (String value) {},
      controller: _fnameTextController,
      autofocus: true,
    );
  }

  TextFormField createLNameWidget() {
    return new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your last name.';
          }
        },
        decoration: InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Last name',
            labelText: 'Enter your last name'),
        onSaved: (String value) {},
        controller: _lnameTextController);
  }

  void _handleSexRadioChanged(String value) {
    setState(() {
      _sex = value;
    });
  }

  InputDecorator createSexWidget() {
    List<Widget> radioWidgets = [
      Text("Male"),
      Radio(
          value: "m",
          groupValue: _sex,
          onChanged: (s) => _handleSexRadioChanged(s)),
      Text("Female"),
      Radio(
          value: "f",
          groupValue: _sex,
          onChanged: (s) => _handleSexRadioChanged(s)),
    ];
    return InputDecorator(
        decoration: const InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Been at address 5 years?',
          labelText: '5 years?',
        ),
        child: new DropdownButtonHideUnderline(
            child: Row(children: radioWidgets)));
  }

  TextFormField createAddr1Widget() {
    return new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the first line of your address.';
          }
        },
        decoration: InputDecoration(
            icon: const Icon(Icons.location_city),
            hintText: 'Address 1',
            labelText: 'Enter the first line of address'),
        onSaved: (String value) {},
        controller: _addr1TextController);
  }

  TextFormField createAddr2Widget() {
    return new TextFormField(
        decoration: InputDecoration(
            icon: const Icon(Icons.location_city),
            hintText: 'Address 2',
            labelText: 'Enter the second line of address'),
        onSaved: (String value) {},
        controller: _addr2TextController);
  }

  TextFormField createCityWidget() {
    return new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your city.';
          }
        },
        decoration: InputDecoration(
            icon: const Icon(Icons.location_city),
            hintText: 'City',
            labelText: 'Enter the city name'),
        onSaved: (String value) {},
        controller: _cityTextController);
  }

  InputDecorator createStateWidget() {
    DropdownButton<String> stateDropdownButton = DropdownButton<String>(
        items: STATE_DROPDOWN_MENU_ITEMS,
        value: _state,
        isDense: true,
        onChanged: (String value) {
          setState(() {
            this._state = value;
          });
        });
    return InputDecorator(
        decoration: const InputDecoration(
          icon: const Icon(Icons.location_city),
          hintText: 'Select the State',
          labelText: 'Select the State',
        ),
        child: new DropdownButtonHideUnderline(child: stateDropdownButton));
  }

  TextFormField createZipWidget() {
    return new TextFormField(
        validator: (value) {
          if ((value.isEmpty) || (value.length < 5)) {
            return 'Please enter your 5 digit zip.';
          }
        },
        maxLength: 5,
        maxLengthEnforced: true,
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            icon: const Icon(Icons.location_city),
            hintText: 'Zip',
            labelText: 'Enter your zip'),
        onSaved: (String value) {},
        controller: _zipTextController);
  }

  InputDecorator createFiveYearsWidget() {
    Checkbox fiveYearsCheckbox = Checkbox(
        value: this._fiveYears,
        onChanged: (value) {
          setState(() {
            this._fiveYears = value;
          });
        });
    return InputDecorator(
        decoration: const InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Been at address 5 years?',
          labelText: '5 years?',
        ),
        child: new DropdownButtonHideUnderline(
            child: Row(children: [
          fiveYearsCheckbox,
          Text("Been at address 5 years?")
        ])));
  }

  DateTimePickerFormField createDobWidget() {
    return new DateTimePickerFormField(
        validator: (value) {
          if ((value == null)) {
            return 'Please enter your date of birth.';
          }
        },
        dateOnly: true,
        format: _dateFormat,
        decoration: InputDecoration(
            icon: const Icon(Icons.date_range),
            hintText: 'Date',
            labelText: 'Select the Date'),
        controller: _dobTextController);
  }

  PersonInfo createDataObjectFromFormData() {
    return new PersonInfo(
        _fnameTextController.text,
        _lnameTextController.text,
        _sex,
        _addr1TextController.text,
        _addr2TextController.text,
        _cityTextController.text,
        _state,
        _zipTextController.text,
        _fiveYears,
        _dateFormat.parse(_dobTextController.text));
  }
}
