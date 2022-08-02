import 'package:flutter/cupertino.dart';
import 'package:xpensis/database/transactionsDB.dart';
import 'package:xpensis/models/transaction.dart';

class TransactionListProvider with ChangeNotifier {
  List<Transaction> transactions = [];
  var firstBuild = true;
  final TransactionsDb database;

  TransactionListProvider(this.database);

  bool get gfirstbuild {
    return firstBuild;
  }

  void set sfirstbuild(bool status) {
    firstBuild = status;
  }

  void initialiseList() async {
    final txMaps = await database.readAll();
    transactions.addAll(txMaps.map((txMap) => Transaction.fromJson(txMap)));
    notifyListeners();
  }

  void deleteTransaction(int id) async {
    final successful = await database.delete(id);
    if (successful) {
      transactions.removeWhere((element) => element.id == id);
      notifyListeners();
    } else
      throw (Exception("Failed to delete from db"));
  }

  void addTransaction(Map<String, Object> newTx) async {
    final id = await database.insert(newTx);
    newTx['id'] = id;
    transactions.insert(0, Transaction.fromJson(newTx));
    notifyListeners();
  }

  List<Transaction> get recentTransactions {
    return transactions
        .where((transaction) => transaction.time
            .isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }
}
