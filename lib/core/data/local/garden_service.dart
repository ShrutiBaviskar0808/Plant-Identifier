import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class GardenService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'garden.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE plants(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            scientific_name TEXT,
            confidence REAL,
            image_path TEXT,
            disease_info TEXT,
            health_status TEXT,
            date_added TEXT,
            analysis_data TEXT
          )
        ''');
      },
    );
  }

  static Future<int> savePlant({
    required String name,
    String? scientificName,
    required double confidence,
    required String imagePath,
    String? diseaseInfo,
    required String healthStatus,
    required Map<String, dynamic> analysisData,
  }) async {
    final db = await database;
    
    return await db.insert('plants', {
      'name': name,
      'scientific_name': scientificName,
      'confidence': confidence,
      'image_path': imagePath,
      'disease_info': diseaseInfo,
      'health_status': healthStatus,
      'date_added': DateTime.now().toIso8601String(),
      'analysis_data': json.encode(analysisData),
    });
  }

  static Future<List<Map<String, dynamic>>> getAllPlants() async {
    final db = await database;
    return await db.query('plants', orderBy: 'date_added DESC');
  }

  static Future<void> deletePlant(int id) async {
    final db = await database;
    await db.delete('plants', where: 'id = ?', whereArgs: [id]);
  }
}