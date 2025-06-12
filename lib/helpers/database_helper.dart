import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/barang_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (DatabaseFactory == databaseFactoryFfi) {
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barang.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute(''' 
      CREATE TABLE barang (
        id $idType,
        cate $textType,
        nama $textType,
        kode $textType,
        jumlah $integerType,
        deskripsi $textType,
        tanggal $textType
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE barang ADD COLUMN cate TEXT NOT NULL DEFAULT ""',
      );
    }
  }

  Future<int> insertBarang(Barang barang) async {
    final db = await instance.database;
    try {
      final id = await db.insert(
        'barang',
        barang.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Inserted barang: ${barang.nama}, ID: $id');
      return id;
    } catch (e) {
      print('Error inserting barang: $e');
      rethrow;
    }
  }

  Future<List<Barang>> getAllBarang() async {
    final db = await instance.database;
    try {
      final result = await db.query('barang');
      final barangList = result.map((json) => Barang.fromMap(json)).toList();
      print('Loaded ${barangList.length} barang');
      return barangList;
    } catch (e) {
      print('Error loading barang: $e');
      return [];
    }
  }

  Future<int> updateBarang(Barang barang) async {
    final db = await instance.database;
    try {
      final rowsAffected = await db.update(
        'barang',
        barang.toMap(),
        where: 'id = ?',
        whereArgs: [barang.id],
      );
      print('Updated barang: ${barang.nama}, Rows affected: $rowsAffected');
      return rowsAffected;
    } catch (e) {
      print('Error updating barang: $e');
      rethrow;
    }
  }

  Future<int> deleteBarang(int id) async {
    final db = await instance.database;
    try {
      final rowsAffected = await db.delete(
        'barang',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleted barang ID: $id, Rows affected: $rowsAffected');
      return rowsAffected;
    } catch (e) {
      print('Error deleting barang: $e');
      rethrow;
    }
  }

  Future<int> getTotalBarang() async {
    final db = await instance.database;
    final count = await db.rawQuery('SELECT COUNT(*) FROM barang');
    return Sqflite.firstIntValue(count) ?? 0;
  }
}
