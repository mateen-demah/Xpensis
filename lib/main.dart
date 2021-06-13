import 'package:intl/intl.dart';
import "package:flutter/material.dart";

import "./models/transaction.dart";

import "./widgets/chart.dart";
import './widgets/userTransactions.dart';
import './widgets/newTransactionDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Xpensis",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    Transaction(
      id: DateTime.now().toString(),
      name: "item 1",
      date: DateTime.now(),
      amount: 54.99,
    ),
  ];

  void deleteTransaction(id) {
    setState(() => transactions.removeWhere((tx) => tx.id == id));
  }

  void addTransaction({title, amount, selectedDate}) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        name: title,
        amount: amount,
        date: selectedDate);
    setState(() => transactions.insert(0, newTransaction));
  }

  List<Transaction> get recentTransactions {
    return transactions
        .where((transaction) => transaction.date
            .isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void startNewTransactionDialog() {
    showModalBottomSheet(
      elevation: 6,
      //barrierColor: Theme.of(context).accentColor,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (BuildContext context) => NewTransactionDialog(addTransaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        '${MediaQuery.of(context).size.height} ${MediaQuery.of(context).size.width}');

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Xpensis"),
        ),
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: startNewTransactionDialog,
          ),
        ],
      ),
      body: transactions.isEmpty
          ? Column(
              children: [
                Chart(recentTransactions),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            )
          : Column(children: <Widget>[
              Chart(recentTransactions),
              UserTransactions(transactions, deleteTransaction),
            ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "add transaction",
        onPressed: startNewTransactionDialog,
      ),
    );
  }
}
