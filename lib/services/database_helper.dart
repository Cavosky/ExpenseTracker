import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // 2. Unisce il percorso della cartella con il nome del file (come Path.Combine in C#)
    final path = join(documentsDirectory.path, filePath);

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
      );
      CREATE TABLE category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
      CREATE TABLE finance_transaction (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
      CREATE TABLE transaction_category(
        id_transaction INTEGER,
        id_category INTEGER,
        PRIMARY KEY (id_transaction, id_category),
        FOREIGN KEY (id_transaction)
          REFERENCES finance_transaction(id)
          ON UPDATE CASCADE
          ON DELETE CASCADE,
        FOREIGN KEY (id_category)
          REFERENCES category(id)
          ON UPDATE CASCADE
          ON DELETE CASCADE
      )
    ''');
  }
}
