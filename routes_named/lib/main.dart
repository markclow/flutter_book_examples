import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class Order {
  DateTime _dt;
  String _description;
  double _total;

  Order(this._dt, this._description, this._total);

  double get total => _total;

  String get description => _description;

  DateTime get dt => _dt;
}

class Customer {
  String _name;
  String _location;
  List<Order> _orders;

  Customer(this._name, this._location, this._orders);

  List<Order> get orders => _orders;

  String get location => _location;

  String get name => _name;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePageWidget(),
      routes: <String, WidgetBuilder>{
        '/customer': (context) => CustomerWidget(), // only simple routes work
        '/order': (context) => OrderWidget(), // only simple routes work
      },
    );
  }
}

class HomePageWidget extends StatelessWidget {
  List<Customer> _customerList = [
    Customer("Bike Corp", "Atlanta", []),
    Customer("Trust Corp", "Atlanta", []),
    Customer("Jilly Boutique", "Birmingham", []),
  ];

  HomePageWidget({Key key}) : super(key: key);

  void navigateToCustomer(BuildContext context, Customer customer) {
    Navigator.pushNamed(context, "/customer"); // only simple routes work
  }

  ListTile createCustomerWidget(BuildContext context, Customer customer) {
    return new ListTile(
        title: Text(customer.name),
        subtitle: Text(customer.location),
        trailing: Icon(Icons.arrow_right),
        onTap: () => navigateToCustomer(context, customer));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> customerList = List.from(_customerList
        .map((Customer customer) => createCustomerWidget(context, customer)));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Customers"),
        ),
        body: new Center(
          child: new ListView(
            children: customerList,
          ),
        ));
  }
}

class CustomerWidget extends StatelessWidget {
  List<Order> _orderList = [
    Order(DateTime(2018, 11, 17), "Bicycle parts", 197.00),
    Order(DateTime(2018, 12, 1), "Bicycle parts", 107.45),
  ];

  CustomerWidget({Key key}) : super(key: key);

  void navigateToOrder(BuildContext context, Order order) {
    Navigator.pushNamed(context, "/order"); // only simple routes work
  }

  ListTile createOrderWidget(BuildContext context, Order order) {
    return new ListTile(
        title: Text(order.description),
        subtitle: Text("${order.dt.month}/${order.dt.day}/${order.dt.year}: "
            "\$${order.total}"),
        trailing: Icon(Icons.arrow_right),
        onTap: () => navigateToOrder(context, order));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List.from(
        _orderList.map((Order order) => createOrderWidget(context, order)));
    widgetList.insert(
        0,
        Container(
            child: Column(
              children: <Widget>[
                Text(
                  "BikeCorp",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Atlanta",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "2 Orders",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
            padding: EdgeInsets.all(20.0)));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Customers"),
        ),
        body: new Center(
          child: new ListView(
            children: widgetList,
          ),
        ));
  }
}

class OrderWidget extends StatelessWidget {
  OrderWidget();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Order Info"),
        ),
        body: new Padding(
          padding: EdgeInsets.all(20.0),
          child: new ListView(
            children: <Widget>[
              Text("BikeCorp",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              Text("Atlanta",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text(""),
              Text("Bicycle Parts",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text("12/1/2019 \$123.23",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
            ],
          ),
        ));
  }
}
