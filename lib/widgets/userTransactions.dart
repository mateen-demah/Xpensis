import 'package:flutter/material.dart';

import '../models/transaction.dart';

import './transactionList.dart';

class UserTransactions extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  UserTransactions(this.transactions, this.deleteTransaction);

  @override
  UserTransactionsState createState() => new UserTransactionsState();
}

class UserTransactionsState extends State<UserTransactions> {
  @override
  Widget build(BuildContext context) {
    return TransactionList(widget.transactions, widget.deleteTransaction);
  }
}
