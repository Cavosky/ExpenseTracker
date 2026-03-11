import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Unica istanza di classe (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  //Costruttore Privato
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // 1. Recupera la directory dei documenti specifica per questa App
    final dbPath = await getDatabasesPath();

    // 2. Unisce il percorso della cartella con il nome del file (come Path.Combine in C#)
    final path = join(dbPath, filePath);

    // 3. Apre il database (lo crea se non esiste)
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Definizione dello schema (DDL)
    await db.execute('''
    CREATE TABLE products(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE category(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE finance_transaction (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE transaction_category(
      id_transaction INTEGER,
      id_category INTEGER,
      PRIMARY KEY (id_transaction, id_category),
      FOREIGN KEY (id_transaction) REFERENCES finance_transaction(id) ON DELETE CASCADE,
      FOREIGN KEY (id_category) REFERENCES category(id) ON DELETE CASCADE
    )
  ''');
  }

  Future<double> getBalance() async {
    final db = await instance.database;
    // Somma tutti gli importi.
    // Nota: se gestisci entrate/uscite, le uscite dovrebbero essere numeri negativi nel DB
    // oppure devi avere una colonna 'type' (ENTRATA/USCITA).
    var result = await db
        .rawQuery('SELECT SUM(amount) AS total FROM finance_transaction');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
