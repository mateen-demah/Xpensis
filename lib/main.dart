import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:xpensis/providers/transactionListProvider.dart';
import 'package:xpensis/widgets/homePage.dart';

import 'database/transactionsDB.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TransactionListProvider(TransactionsDb())),
      ],
      child: MaterialApp(
        title: "Xpensis",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
