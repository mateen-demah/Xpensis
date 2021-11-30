import 'package:flutter/cupertino.dart';
import 'package:xpensis/models/transaction.dart';

class TransactionListProvider with ChangeNotifier {
  List<Transaction> transactions = [];

  void deleteTransaction(String id) {
    transactions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addTransaction({title, amount, selectedDate}) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        name: title,
        amount: amount,
        date: selectedDate);
    transactions.add(newTransaction);
    notifyListeners();
  }

  List<Transaction> get recentTransactions {
    return transactions
        .where((transaction) => transaction.date
            .isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }
}
