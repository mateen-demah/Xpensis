import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpensis/database/transactionsDB.dart';
import 'package:xpensis/providers/transactionListProvider.dart';

class TransactionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionListState();
}

class TransactionListState extends State<TransactionList> {
  TransactionListProvider transactionListProvider;
  //bool firstbuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    TransactionsDb.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    transactionListProvider = Provider.of<TransactionListProvider>(context);
    if (transactionListProvider.gfirstbuild) {
      transactionListProvider.initialiseList();
      transactionListProvider.sfirstbuild = false;
    }
    return transactionListProvider.transactions.isEmpty
        ? Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Container(
              height: 300,
              child: ListView.builder(
                itemCount: transactionListProvider.transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text(
                            transactionListProvider.transactions[index].amount
                                .toStringAsFixed(2),
                          ),
                        ),
                      ),
                      title: Text(
                        transactionListProvider.transactions[index].title,
                      ),
                      subtitle: Text(
                        DateFormat.MMMMEEEEd().format(
                            transactionListProvider.transactions[index].date),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        ),
                        onPressed: () =>
                            transactionListProvider.deleteTransaction(
                                transactionListProvider.transactions[index].id),
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
