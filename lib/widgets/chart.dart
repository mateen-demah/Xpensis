import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatefulWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  double get spendingForPastWeek {
    return widget.recentTransactions
        .fold(0.0, (previousSum, trans) => trans.amount + previousSum);
  }

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      final daySpending = widget.recentTransactions.fold(
        0.0,
        (prev, trans) {
          final transAmount = trans.date.day == date.day ? trans.amount : 0;
          return transAmount + prev;
        },
      );
      return {
        'day': date,
        'amount': daySpending,
        'fractionOfWeekSpending': widget.recentTransactions.length > 0
            ? daySpending / spendingForPastWeek
            : 0.0,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final portrait =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 7,
      ),
      child: Container(
        height: portrait
            ? MediaQuery.of(context).size.height * 0.2
            : double.infinity,
        width: portrait
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: groupedTransactions.map((transForDay) {
            return Flexible(
              flex: DateTime.now().weekday ==
                      (transForDay['day'] as DateTime).weekday
                  ? 4
                  : 3,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 25,
                      child: FittedBox(
                        child: Text(
                            "\$${(transForDay['amount'] as double).toStringAsFixed(2)}"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: !portrait
                          ? MediaQuery.of(context).size.height * 0.5
                          : MediaQuery.of(context).size.height * 0.1,
                      width: 10,
                      child: FractionallySizedBox(
                        alignment: Alignment.bottomCenter,
                        heightFactor: transForDay['fractionOfWeekSpending'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      DateTime.now().weekday ==
                              (transForDay['day'] as DateTime).weekday
                          ? 'Today'
                          : DateFormat.E()
                              .format(transForDay['day'])
                              .toString(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
