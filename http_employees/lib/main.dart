import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() => runApp(new MyApp());

class Employee {
  String id;
  String employeeName;
  String employeeSalary;
  String employeeAge;
  String profileImage;

  Employee(this.id, this.employeeName, this.employeeSalary, this.employeeAge,
      this.profileImage);

  Employee.empty() {
    id = "";
    employeeName = "";
    employeeSalary = "";
    employeeAge = "";
    profileImage = "";
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    return Employee(json['id'], json['employee_name'], json['employee_salary'],
        json['employee_age'], json['profile_image']);
  }

  Map<String, dynamic> toJson() {
    var map = {
      'name': employeeName,
      'salary': employeeSalary,
      'age': employeeAge
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    if (profileImage.isNotEmpty) {
      map['profileImage'] = profileImage;
    }
    return map;
  }

  get hasEmptyId {
    return id.isEmpty;
  }
}

class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({
    Key key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        color: Colors.white.withOpacity(0.8));
  }
}

class ApiWidget extends InheritedWidget {
  static final String _BASE_URL = "http://dummy.restapiexample.com/api/v1";
  static const _TIMEOUT = Duration(seconds: 10);

  ApiWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static ApiWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ApiWidget) as ApiWidget;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  Future<List<Employee>> loadAndParseEmployees() async {
    var url = '${_BASE_URL}/employees';
    final response = await http.get(url).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      var list =
          parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
      return list;
    } else {
      badStatusCode(response);
    }
  }

  Future<Employee> loadEmployee(String id) async {
    var url = '${_BASE_URL}/employee/${id}';
    final response = await http.get(url).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Employee.fromJson(parsed);
    } else {
      badStatusCode(response);
    }
  }

  Future<dynamic> saveEmployee(Employee employee) async {
    bool isUpdate = employee.id.isNotEmpty;
    final uri = _BASE_URL + (isUpdate ? '/update/${employee.id}' : '/create');
    // profile image does not seem to update
    final response = isUpdate
        ? await http.put(uri, body: json.encode(employee)).timeout(_TIMEOUT)
        : await http.post(uri, body: json.encode(employee)).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      badStatusCode(response);
    }
  }

  Future<dynamic> deleteEmployee(String id) async {
    final uri = '${_BASE_URL}/delete/${id}';
    final response = await http.delete(uri).timeout(_TIMEOUT);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      badStatusCode(response);
    }
  }

  badStatusCode(Response response) {
    debugPrint("Bad status code ${response.statusCode} returned from server.");
    debugPrint("Response body ${response.body} returned from server.");
    throw Exception(
        'Bad status code ${response.statusCode} returned from server.');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ApiWidget(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new EmployeeListWidget()));
  }
}

class EmployeeListWidget extends StatefulWidget {
  @override
  _EmployeeListWidgetState createState() => new _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));

  bool _refresh = true;
  List<Employee> _employees;
  bool _pleaseWait = false;

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text('${error ? "An unexpected error occurred: " : ""}${content}'),
    ));
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  _navigateToEmployee(BuildContext context, String employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeDetailWidget(employeeId)),
    ).then((result) {
      if ((result != null) && (result is bool) && (result == true)) {
        _showSnackBar('Employee saved.');
        _refreshEmployees();
      }
    });
  }

  _deleteEmployee(BuildContext context, Employee employee) async {
    _showDeleteConfirmDialog(employee).then((result) {
      if ((result != null) && (result is bool) && (result == true)) {
        _showPleaseWait(true);
        try {
          ApiWidget.of(context).deleteEmployee(employee.id).then((employee) {
            _showPleaseWait(false);
            _showSnackBar('Employee deleted.');
            _refreshEmployees();
          }).catchError((error) {
            _showPleaseWait(false);
            _showSnackBar(error.toString(), error: true);
          });
        } catch (e) {
          _showPleaseWait(false);
          _showSnackBar(e.toString(), error: true);
        }
      }
    });
  }

  Future<bool> _showDeleteConfirmDialog(Employee employee) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Employee'),
            content: Text(
                'Are you sure you want to delete ${employee.employeeName}?'),
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

  _refreshEmployees() {
    setState(() {
      _refresh = true;
    });
  }

  _loadEmployees(BuildContext context) {
    _showPleaseWait(true);
    try {
      ApiWidget.of(context).loadAndParseEmployees().then((employees) {
        // Sort first.
        employees.sort((a, b) => a.employeeName
            .toLowerCase()
            .compareTo(b.employeeName.toLowerCase()));
        setState(() {
          _employees = employees;
        });
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_refresh) {
      _refresh = false;
      _loadEmployees(context);
    }

    ListView builder = ListView.builder(
        itemCount: _employees != null ? _employees.length : 0,
        itemBuilder: (context, index) {
          Employee employee = _employees[index];
          return ListTile(
              title: Text('${employee.employeeName}'),
              subtitle: Text('Age: ${employee.employeeAge}'),
              trailing: Icon(Icons.arrow_right),
              onTap: () => _navigateToEmployee(context, employee.id),
              onLongPress: () => _deleteEmployee(context, employee));
        });

    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Employees"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add',
                onPressed: () {
                  _navigateToEmployee(context, null);
                }),
            IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _refreshEmployees();
                })
          ],
        ),
        body: new Center(
          child: bodyWidget,
        ));
  }
}

class EmployeeDetailWidget extends StatefulWidget {
  String _employeeId;

  EmployeeDetailWidget(this._employeeId);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState(this._employeeId);
}

class _EmployeeDetailState extends State<EmployeeDetailWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));

  String _employeeId;
  bool _loaded = false;
  bool _pleaseWait = false;
  Employee _employee;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _salaryTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _profileImageTextController = TextEditingController();

  _EmployeeDetailState(this._employeeId);

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text('${error ? "An unexpected error occurred: " : ""}${content}'),
    ));
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  TextFormField _createNameWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the name.';
        }
      },
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Name',
          labelText: 'Enter the name'),
      onSaved: (String value) {
        this._employee.employeeName = value;
      },
      controller: _nameTextController,
      autofocus: true,
    );
  }

  TextFormField _createSalaryWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the salary.';
        }
        int salary = int.parse(value);
        if (salary == null) {
          return 'Please enter the salary as a number.';
        }
        if ((salary < 10000) || (salary > 500000)) {
          return 'Please enter an age between 10000 and 50000.';
        }
      },
      maxLength: 6,
      maxLengthEnforced: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Salary',
          labelText: 'Enter the salary'),
      onSaved: (String value) {
        this._employee.employeeSalary = value;
      },
      controller: _salaryTextController,
    );
  }

  TextFormField _createAgeWidget() {
    return new TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the age.';
        }
        int age = int.parse(value);
        if (age == null) {
          return 'Please enter the age as a number.';
        }
        if ((age < 1) || (age > 114)) {
          return 'Please enter an age between 1 and 114.';
        }
      },
      maxLength: 3,
      maxLengthEnforced: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Age',
          labelText: 'Enter the age'),
      onSaved: (String value) {
        this._employee.employeeAge = value;
      },
      controller: _ageTextController,
    );
  }

  TextFormField _createProfileImageWidget() {
    return new TextFormField(
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Profile image',
          labelText: 'Enter the profile image'),
      onSaved: (String value) {
        this._employee.profileImage = value;
      },
      controller: _profileImageTextController,
    );
  }

  _loadEmployee(BuildContext context) {
    _showPleaseWait(true);
    try {
      ApiWidget.of(context).loadEmployee(_employeeId).then((employee) {
        setState(() {
          _employee = employee;
          _nameTextController.text = employee.employeeName;
          _salaryTextController.text = employee.employeeSalary;
          _ageTextController.text = employee.employeeAge;
          _profileImageTextController.text = employee.profileImage;
        });
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
    }
  }

  _saveEmployee(BuildContext context) {
    _showPleaseWait(true);
    try {
      ApiWidget.of(context).saveEmployee(_employee).then((employee) {
        _showPleaseWait(false);
        Navigator.pop(context, true);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      if (_employeeId == null) {
        _employee = Employee.empty();
      } else {
        _loadEmployee(context);
      }
    }

    List<Widget> formWidgetList = [
      _createNameWidget(),
      _createSalaryWidget(),
      _createAgeWidget(),
      _createProfileImageWidget(),
      RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _saveEmployee(context);
          }
        },
        child: new Text('Save'),
      )
    ];
    Form form = Form(key: _formKey, child: ListView(children: formWidgetList));

    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, form])
        : Stack(key: ObjectKey("stack"), children: [form]);

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Row(children: [
            Text("Back"),
            Spacer(),
            Text(_employeeId == null ? "Create Employee" : "Edit Employee")
          ]),
        ),
        body: new Padding(padding: EdgeInsets.all(20.0), child: bodyWidget));
  }
}
