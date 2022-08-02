import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xpensis/database/transactionsDB.dart';
import 'package:xpensis/models/transaction.dart';
import 'package:xpensis/providers/transactionListProvider.dart';

class MockTransactionsDb extends Mock implements TransactionsDb {}

void main() {
  TransactionListProvider sut;
  MockTransactionsDb mockTransactionsDb;

  setUp(() {
    mockTransactionsDb = MockTransactionsDb();
    // sut = system under test
    sut = TransactionListProvider(mockTransactionsDb);
  });

  test(
    "initial values are correct",
    () {
      expect(sut.transactions, []);
      expect(sut.firstBuild, true);
    },
  );

  group(
    "getter and setter for firstBuild",
    () {
      test(
        "getter for firstBuild",
        () {
          expect(sut.gfirstbuild, sut.firstBuild);
        },
      );
      test(
        "setter for firstBuild",
        () {
          var mockStatus = false;
          sut.sfirstbuild = mockStatus;
          expect(sut.firstBuild, mockStatus);
        },
      );
    },
  );

  group(
    "initialiseList",
    () {
      test(
        "gets list of all transactions from database",
        () async {
          // arrange mocks
          List<Map<String, Object>> mockTransactionList = [];
          when(() => mockTransactionsDb.readAll())
              .thenAnswer((invocation) async => mockTransactionList);
          // act
          await sut.initialiseList();
          // assert
          verify(() => mockTransactionsDb.readAll()).called(1);
          expect(sut.transactions, mockTransactionList);
        },
      );
    },
  );

  group(
    "deleteTransaction",
    () {
      setUp(
        () {
          sut.transactions.add(Transaction(id: 10));
        },
      );

      test(
        "deletes transaction from database",
        () async {
          when(() => mockTransactionsDb.delete(10))
              .thenAnswer((_) async => true);
          // act
          await sut.deleteTransaction(10);
          // assert
          verify(() => mockTransactionsDb.delete(10)).called(1);
          expect(sut.transactions.contains(Transaction(id: 10)), false);
        },
      );
      test(
        "fails to delete transaction from database",
        () async {
          // arrange mocks
          when(() => mockTransactionsDb.delete(10))
              .thenAnswer((_) async => false);
          // act
          var future = sut.deleteTransaction(10);
          // assert
          await expectLater(() => future, throwsA(isA<Exception>()));
          verify(() => mockTransactionsDb.delete(10)).called(1);
        },
      );
    },
  );

  group(
    "addTransaction",
    () {
      test(
        """adds a transaction to database, 
    and updates list of transactions""",
        () async {
          //arrange mocks
          var mockTransaction = Transaction(
            title: 'title test',
            time: DateTime.now(),
            amount: 55,
          );
          var mockTxAsJson = mockTransaction.toJson();
          mockTxAsJson.remove('id');
          when(() => mockTransactionsDb.insert(mockTxAsJson))
              .thenAnswer((invocation) async => 30);
          mockTransaction.id = 30;

          // act
          await sut.addTransaction(mockTxAsJson);
          // assert
          verify(() => mockTransactionsDb.insert(mockTxAsJson)).called(1);
          expect(sut.transactions[0], mockTransaction);
        },
      );
    },
  );

  group(
    "recentTransactions",
    () {
      Transaction aMockTx(DateTime time) {
        return Transaction(
          id: int.parse(time.toString().substring(time.toString().length - 3)),
          title: 'title test',
          time: time,
          amount: 55,
        );
      }

      test(
        "returns transactions that occured within last 7 days",
        () {
          // arrange mocks
          var currentTime = DateTime.now();
          var nowMinus8Days = DateTime.now().subtract(Duration(days: 8));
          var nowMinus7Days =
              DateTime.now().subtract(Duration(days: 6, hours: 20));
          var mocTx1 = aMockTx(currentTime);
          var mocTx2 = aMockTx(nowMinus7Days);
          var mocTx3 = aMockTx(nowMinus8Days);
          sut.transactions = [mocTx1, mocTx2, mocTx3];

          // act
          var recents = sut.recentTransactions;
          // assert
          expect(listEquals(recents, [mocTx1, mocTx2]), true);
        },
      );
    },
  );
}
