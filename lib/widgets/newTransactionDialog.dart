import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionDialog extends StatefulWidget {
  final Function addTx;

  NewTransactionDialog(this.addTx);

  @override
  _NewTransactionDialogState createState() => _NewTransactionDialogState();
}

class _NewTransactionDialogState extends State<NewTransactionDialog> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate;

  void displayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 366 * 3)),
      lastDate: DateTime.now(),
    ).then((datePicked) => setState(() => selectedDate = datePicked));
  }

  void addTransaction() {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedDate == null) {
      return;
    }

    widget.addTx(
      title: titleController.text,
      amount: double.parse(amountController.text),
      selectedDate: selectedDate,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Title of transaction',
            ),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
            keyboardType: TextInputType.number,
            controller: amountController,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      "Date: ${selectedDate == null ? "No date chosen" : DateFormat.yMMMMEEEEd().format(selectedDate)}"),
                ),
                TextButton(
                  onPressed: displayDatePicker,
                  child: Text(
                    'Choose date',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: addTransaction,
            child: Text("Add Transaction"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              elevation: MaterialStateProperty.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
