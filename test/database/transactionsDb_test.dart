import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:xpensis/database/transactionsDB.dart';
import 'package:xpensis/models/transaction.dart';

class MockTransaction extends Mock implements Transaction {}

Future main() async {
  MockTransaction mockTransaction;
  TransactionsDb sut;
  String tableName;

  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(
    () {
      sut = TransactionsDb();
      mockTransaction = MockTransaction();
      tableName = 'transactions';
      when(() => mockTransaction.toJson()).thenReturn({
        'amount': 23,
        'time': DateTime.now().toIso8601String(),
        'title': 'test'
      });
    },
  );

  test(
    "initial values are correct",
    () {
      expect(TransactionsDb.tableName, tableName);
      expect(TransactionsDb.transactionsDb, null);
    },
  );
  test(
    "db initialisation, may involve creation",
    () async {
      // act
      final db = await sut.initialiseDb("test.db");
      // assert
      expectLater(await db.isOpen, true);
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'", null);
      expect(tables.any((element) => element['name'] == tableName), true);
    },
  );

  test(
    "getter for database",
    () async {
      final db = await sut.database;
      expect(db, isA<Database>());
    },
  );

  test(
    "insert transaction into database",
    () async {
      // act
      final newId = await sut.insert(mockTransaction.toJson());
      // assert
      expect(newId, isA<int>());
    },
  );

  test(
    "readAll entries in transactions table",
    () async {
      // arrange mock
      // insert must have already being tested for this test to be valid
      await sut.insert(mockTransaction.toJson());
      await sut.insert(mockTransaction.toJson());
      await sut.insert(mockTransaction.toJson());
      // act
      final txList = await sut.readAll();
      // assert
      expect(txList, isA<List<Map<String, Object>>>());
      expect(txList.length >= 3, true);
    },
  );

  test(
    "delete database entries",
    () async {
      // arrange mock
      final id = await sut.insert(mockTransaction.toJson());
      // assert
      expectLater(await sut.delete(id), true);
    },
  );

  test(
    "close database",
    () async {
      final db = await sut.database;
      // act
      await db.close();
      // assert
      expect(db.isOpen, false);
    },
  );

  test('Simple test', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
    });
    // Insert some data
    await db.insert('Test', {'value': 'my_value'});
    // Check content
    expect(await db.query('Test'), [
      {'id': 1, 'value': 'my_value'}
    ]);

    await db.close();
  });
}
