import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDBHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 2;

  static const table_creditCards = "credit_cards";
  static const table_paymentHistory = "payment_history";

  LocalDBHelper._privateConstructor();
  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table_creditCards (
          card_id TEXT primary key,
          user_id TEXT,
          number TEXT,
          holder_name TEXT,
          expiration_date TEXT,
          security_code TEXT,
          brand TEXT,
          last_digits TEXT,
          document TEXT,
          validation_number TEXT)
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table_paymentHistory (
          payment_id TEXT primary key,
          user_id TEXT,
          data TEXT)
          ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    db.execute('''DROP TABLE IF EXISTS $table_creditCards''');
    db.execute('''DROP TABLE IF EXISTS $table_paymentHistory''');
    _onCreate(db, newVersion);
  }

  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table, String currentUserId) async {
    Database db = await instance.database;

    String whereString = 'user_id = ?';
    List<dynamic> whereArguments = [currentUserId];

    return await db.query(table, where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> querySingleCard(String table, String currentUserId, String cardId) async {
    Database db = await instance.database;

    String whereString = 'user_id = ? and card_id = ?';
    List<dynamic> whereArguments = [currentUserId, cardId];

    return await db.query(table, where: whereString, whereArgs: whereArguments);
  }

  Future<int> queryRowCount(String table, String currentUserId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE user_id = $currentUserId'));
  }

  Future<int> deleteCreditCard(String cardId) async {
    Database db = await instance.database;
    return await db.delete(table_creditCards, where: 'card_id = ?', whereArgs: [cardId]);
  }

  Future<int> insertPaymentHistory(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_paymentHistory, row);
  }

  Future<List<Map<String, dynamic>>> queryAllPayments(String currentUserId) async {
    Database db = await instance.database;

    String whereString = 'user_id = ?';
    List<dynamic> whereArguments = [currentUserId];

    return await db.query(table_paymentHistory, where: whereString, whereArgs: whereArguments);
  }

  Future<int> deleteAllPayments(String userID) async {
    Database db = await instance.database;
    return await db.delete(table_paymentHistory, where: 'user_id = ?', whereArgs: [userID]);
  }
}
