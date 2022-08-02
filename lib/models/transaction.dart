import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Transaction extends Equatable {
  int id;
  String title;
  DateTime time;
  double amount;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.time,
    @required this.amount,
  });

  Transaction.fromJson(Map<String, Object> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.time = DateTime.parse(json['time']);
    this.amount = json['amount'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'time': this.time.toIso8601String(),
        'amount': this.amount,
      };

  @override
  List<Object> get props => [id];
}
