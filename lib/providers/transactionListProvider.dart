import 'package:flutter/cupertino.dart';
import 'package:xpensis/database/transactionsDB.dart';
import 'package:xpensis/models/transaction.dart';

class TransactionListProvider with ChangeNotifier {
  List<Transaction> transactions = [];
  var firstBuild = true;

  bool get gfirstbuild {
    return firstBuild;
  }

  void set sfirstbuild(bool status) {
    firstBuild = status;
  }

  void initialiseList() async {
    final txMaps = await TransactionsDb.instance.readAll();
    transactions.addAll(txMaps.map((txMap) => Transaction.fromJson(txMap)));
    notifyListeners();
  }

  void deleteTransaction(int id) async {
    final successful = await TransactionsDb.instance.delete(id);
    if (successful) {
      transactions.removeWhere((element) => element.id == id);
      notifyListeners();
    } else
      print('deletion doesn\'t work !!!!!!!!111');
  }

  void addTransaction({title, amount, DateTime selectedDate}) async {
    final newTx = {
      'title': title,
      'amount': amount,
      'time': selectedDate.toIso8601String(),
      'notes': ''
    };

    final id = await TransactionsDb.instance.insert(newTx);
    print(
        '================================================the id after insert');
    print(id);
    newTx['id'] = id;
    transactions.insert(0, Transaction.fromJson(newTx));
    notifyListeners();
  }

  List<Transaction> get recentTransactions {
    return transactions
        .where((transaction) => transaction.date
            .isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }
}
