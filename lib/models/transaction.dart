import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  int id;
  String title;
  DateTime time;
  String notes;
  double amount;

  Transaction({this.id, this.title, this.time, this.notes, this.amount});

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

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is Transaction &&
  //         runtimeType == other.runtimeType &&
  //         id == other.id;

  // @override
  // int get hashCode => id.hashCode;

  @override
  List<Object> get props => [id];
}
