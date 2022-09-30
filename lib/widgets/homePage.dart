import 'package:flutter/material.dart';
import 'package:xpensis/widgets/transactionList.dart';

import 'chart.dart';
import 'newTransactionDialog.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startNewTransactionDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 6,
      //barrierColor: Theme.of(context).accentColor,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: NewTransactionDialog(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final portrait =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;

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
      body: portrait
          ? Column(
              children: [
                Chart(),
                TransactionList(),
              ],
            )
          : Row(
              children: [
                Chart(),
                TransactionList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "add transaction",
        onPressed: startNewTransactionDialog,
      ),
    );
  }
}
