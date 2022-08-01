class Transaction {
  int id;
  String title;
  DateTime date;
  String notes;
  double amount;

  Transaction({this.id, this.title, this.date, this.notes, this.amount});

  Transaction.fromJson(Map<String, Object> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.date = DateTime.parse(json['time']);
    this.amount = json['amount'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'title': this.title,
        'date': this.date.toIso8601String(),
        'amount': this.amount,
      };
}
