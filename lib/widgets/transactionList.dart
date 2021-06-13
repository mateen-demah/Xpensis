import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  State<StatefulWidget> createState() => TransactionListState();
}

class TransactionListState extends State<TransactionList> {
  void addTransaction({String title, double amount, DateTime selectedDate}) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        name: title,
        amount: amount,
        date: selectedDate);
    setState(() {
      widget.transactions.insert(0, newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300,
        child: ListView.builder(
          itemCount: widget.transactions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: FittedBox(
                    child: Text(
                      widget.transactions[index].amount.toStringAsFixed(2),
                    ),
                  ),
                ),
                title: Text(
                  widget.transactions[index].name,
                ),
                subtitle: Text(
                  DateFormat.MMMMEEEEd()
                      .format(widget.transactions[index].date),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () =>
                      widget.deleteTransaction(widget.transactions[index].id),
                ),
              ),
              elevation: 5,
            );
          },
        ),
      ),
    );
  }
}
