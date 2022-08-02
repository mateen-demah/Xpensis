import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xpensis/models/transaction.dart';

void main() {
  // sut = system under test
  Transaction sut1, sut2;
  setUp(() {
    sut1 =
        Transaction(id: 54, amount: 54, title: 'other', time: DateTime.now());
    sut2 = Transaction(id: 54, amount: 45, title: 'this', time: DateTime.now());
  });

  test(
    "value equality of Transaction class if ids are equal",
    () {
      expect(sut1, sut2);
    },
  );

  test(
    "transaction toJSON method",
    () {
      expect(
          mapEquals(sut2.toJson(), {
            'id': 54,
            'title': 'this',
            'time': sut2.time.toIso8601String(),
            'amount': 45,
          }),
          true);
    },
  );

  test(
    "transaction fromJSON constructor",
    () {
      expect(
          Transaction.fromJson({
            'id': 54,
            'title': 'this',
            'time': sut2.time.toIso8601String(),
            'amount': 45.0,
          }),
          sut2);
    },
  );
}
