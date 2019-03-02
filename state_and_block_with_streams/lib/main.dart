import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Customer {
  String _firstName;
  String _lastName;
  bool _upButton;
  bool _downButton;

  Customer(this._firstName, this._lastName) {
    _upButton = false;
    _downButton = false;
  }

  String get name => _firstName + " " + _lastName;

  bool get upButton => _upButton;

  set upButton(bool value) {
    _upButton = value;
  }

  bool get downButton => _downButton;

  set downButton(bool value) {
    _downButton = value;
  }

  operator ==(other) =>
      (other is Customer) &&
      (_firstName == other._firstName) &&
      (_lastName == other._lastName);

  int get hashCode => _firstName.hashCode ^ _lastName.hashCode;
}

class Bloc {
  // BLoC stands for Business Logic Component.
  List<Customer> _customerList = [];

  Bloc() {
    _upActionStreamController.stream.listen(_handleUp);
    _downActionStreamController.stream.listen(_handleDown);
  }

  List<Customer> initCustomerList() {
    _customerList = [
      new Customer("Fred", "Smith"),
      new Customer("Brian", "Johnson"),
      new Customer("James", "McGirt"),
      new Customer("John", "Brown")
    ];
    updateUpDownButtons();
    return _customerList;
  }

  void dispose() {
    _upActionStreamController.close();
    _downActionStreamController.close();
  }

  void _handleUp(Customer customer) {
    swap(customer, true);
    updateUpDownButtons();

    _customerListSubject.add(_customerList);
    _messageSubject.add(customer.name + " moved up");
  }

  void _handleDown(Customer customer) {
    swap(customer, false);
    updateUpDownButtons();

    _customerListSubject.add(_customerList);
    _messageSubject.add(customer.name + " moved down");
  }

  void swap(Customer customer, bool up) {
    int idx = _customerList.indexOf(customer);
    _customerList.remove(customer);
    _customerList.insert(up ? idx - 1 : idx + 1, customer);
  }

  void updateUpDownButtons() {
    //TODO We dont really need to update them all, but this is just an example.
    for (int idx = 0, lastIdx = _customerList.length - 1;
        idx <= lastIdx;
        idx++) {
      Customer customer = _customerList[idx];
      customer.upButton = (idx > 0);
      customer.downButton = (idx < lastIdx);
    }
  }

  // Streams for State Updates
  Stream<List<Customer>> get customerListStream => _customerListSubject.stream;
  final _customerListSubject = BehaviorSubject<List<Customer>>();

  Stream<String> get messageStream => _messageSubject.stream;
  final _messageSubject = BehaviorSubject<String>();

  // Sinks for Actions
  Sink<Customer> get upAction => _upActionStreamController.sink;
  final _upActionStreamController = StreamController<Customer>();

  Sink<Customer> get downAction => _downActionStreamController.sink;
  final _downActionStreamController = StreamController<Customer>();
}

class BlocProvider extends InheritedWidget {
  final Bloc bloc;

  BlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Bloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bloc;
}

class CustomerWidget extends StatelessWidget {
  final Customer _customer;

  CustomerWidget(this._customer);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    Text text = Text(_customer.name,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold));
    IconButton upButton = IconButton(
        icon: new Icon(Icons.arrow_drop_up, color: Colors.blue),
        onPressed: () {
          bloc.upAction.add(_customer);
        });
    IconButton downButton = IconButton(
        icon: new Icon(Icons.arrow_drop_down, color: Colors.blue),
        onPressed: () {
          bloc.downAction.add(_customer);
        });
    List<Widget> children = [];
    children.add(Expanded(
        child: Padding(padding: EdgeInsets.only(left: 20.0), child: text)));
    if (_customer.upButton) {
      children.add(upButton);
    }
    if (_customer.downButton) {
      children.add(downButton);
    }
    return Padding(
        padding: EdgeInsets.all(6.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
                decoration: BoxDecoration(color: Colors.cyan[100]),
                child: Row(
                    children: children,
                    mainAxisAlignment: MainAxisAlignment.start))));
  }
}

void main() => runApp(new CustomerAppWidget());

class CustomerAppWidget extends StatelessWidget {
  // This widget is the root of your application.
  final Bloc _bloc = new Bloc();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        bloc: _bloc,
        child: new CustomerListWidget(
          title: 'Flutter '
              'Demo Home Page',
          messageStream: _bloc.messageStream,
        ),
      ),
    );
  }
}

class CustomerListWidget extends StatelessWidget {
  CustomerListWidget({Key key, this.title, Stream<String> this.messageStream})
      : super(key: key) {
    this.messageStream.listen((message) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ));
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  final Stream<String> messageStream;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: StreamBuilder<List<Customer>>(
            stream: bloc.customerListStream,
            initialData: bloc.initCustomerList(),
            builder: (context, snapshot) {
              List<Widget> customerWidgets =
                  snapshot.data.map((Customer customer) {
                return CustomerWidget(customer);
              }).toList();
              return ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: customerWidgets);
            }));
  }
}
