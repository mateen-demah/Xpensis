import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionsDb {
  static final TransactionsDb _instance = TransactionsDb();
  static Database transactionsDb;
  static final tableName = 'transactions';

  TransactionsDb();

  Future<Database> get database async {
    if (transactionsDb != null) return transactionsDb;
    transactionsDb = await initialiseDb('transactions.db');
    return transactionsDb;
  }

  Future<Database> initialiseDb(String dbFileName) async {
    final dir = await getDatabasesPath();
    final dbPath = join(dir, dbFileName);
    return await openDatabase(dbPath, version: 1, onCreate: createDb);
  }

  Future createDb(Database db, int version) async {
    await db.execute('''CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      time TEXT NOT NULL,
      amount FLOAT(5,2),
      notes TEXT)''');
  }

  Future<int> insert(Map<String, Object> transaction) async {
    final db = await _instance.database;
    final id = await db.insert(
      tableName,
      transaction,
    );
    return id;
  }

  Future<List<Map<String, Object>>> readAll() async {
    final db = await _instance.database;
    final txList = await db.query(tableName, orderBy: 'time DESC');
    return txList;
  }

  Future<bool> delete(int id) async {
    final db = await _instance.database;
    final rowsDeleted = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsDeleted == 1;
  }

  Future<void> close() async {
    final db = await _instance.database;
    db.close();
  }
}
