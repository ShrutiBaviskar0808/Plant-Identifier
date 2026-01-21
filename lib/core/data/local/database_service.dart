import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/plant.dart';
import '../models/plant_identification.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'plant_identifier.db';
  static const int _databaseVersion = 1;

  static Future<void> initialize() async {
    if (_database != null) return;

    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, _databaseName);

      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _createTables,
      );

      print('Database initialized successfully');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  static Future<void> _createTables(Database db, int version) async {
    // Plants table
    await db.execute('''
      CREATE TABLE plants (
        id TEXT PRIMARY KEY,
        common_name TEXT NOT NULL,
        scientific_name TEXT NOT NULL,
        family TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        care_requirements TEXT NOT NULL,
        image_urls TEXT NOT NULL,
        tags TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // User plants table
    await db.execute('''
      CREATE TABLE user_plants (
        id TEXT PRIMARY KEY,
        plant_data TEXT NOT NULL,
        custom_name TEXT,
        notes TEXT,
        group_name TEXT,
        date_added TEXT NOT NULL,
        image_path TEXT
      )
    ''');

    // Plant identifications table
    await db.execute('''
      CREATE TABLE plant_identifications (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        results TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Plant operations
  static Future<void> insertPlant(Plant plant) async {
    if (_database == null) return;

    await _database!.insert(
      'plants',
      {
        'id': plant.id,
        'common_name': plant.commonName,
        'scientific_name': plant.scientificName,
        'family': plant.family,
        'category': plant.category,
        'description': plant.description,
        'care_requirements': jsonEncode(plant.careRequirements.toJson()),
        'image_urls': jsonEncode(plant.imageUrls),
        'tags': jsonEncode(plant.tags),
        'created_at': plant.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Plant>> getAllPlants() async {
    if (_database == null) return [];

    final maps = await _database!.query('plants');
    return maps.map((map) => _plantFromMap(map)).toList();
  }

  static Future<Plant?> getPlantById(String id) async {
    if (_database == null) return null;

    final maps = await _database!.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _plantFromMap(maps.first);
    }
    return null;
  }

  // User plant operations
  static Future<void> insertUserPlant(UserPlant userPlant) async {
    if (_database == null) return;

    await _database!.insert(
      'user_plants',
      {
        'id': userPlant.id,
        'plant_data': jsonEncode(userPlant.plant.toJson()),
        'custom_name': userPlant.customName,
        'notes': userPlant.notes,
        'group_name': userPlant.group,
        'date_added': userPlant.dateAdded.toIso8601String(),
        'image_path': userPlant.imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserPlant>> getUserPlants() async {
    if (_database == null) return [];

    final maps = await _database!.query('user_plants');
    return maps.map((map) => _userPlantFromMap(map)).toList();
  }

  static Future<void> deleteUserPlant(String id) async {
    if (_database == null) return;

    await _database!.delete(
      'user_plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Plant identification operations
  static Future<void> insertPlantIdentification(PlantIdentification identification) async {
    if (_database == null) return;

    await _database!.insert(
      'plant_identifications',
      {
        'id': identification.id,
        'image_path': identification.imagePath,
        'results': jsonEncode(identification.results.map((r) => r.toJson()).toList()),
        'timestamp': identification.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PlantIdentification>> getPlantIdentifications() async {
    if (_database == null) return [];

    final maps = await _database!.query('plant_identifications', orderBy: 'timestamp DESC');
    return maps.map((map) => _identificationFromMap(map)).toList();
  }

  static Future<void> deletePlantIdentification(String id) async {
    if (_database == null) return;

    await _database!.delete(
      'plant_identifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper methods
  static Plant _plantFromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as String,
      commonName: map['common_name'] as String,
      scientificName: map['scientific_name'] as String,
      family: map['family'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      careRequirements: PlantCareRequirements.fromJson(
        jsonDecode(map['care_requirements'] as String)
      ),
      imageUrls: List<String>.from(jsonDecode(map['image_urls'] as String)),
      tags: List<String>.from(jsonDecode(map['tags'] as String)),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  static UserPlant _userPlantFromMap(Map<String, dynamic> map) {
    return UserPlant(
      id: map['id'] as String,
      plant: Plant.fromJson(jsonDecode(map['plant_data'] as String)),
      customName: map['custom_name'] as String?,
      notes: map['notes'] as String?,
      group: map['group_name'] as String?,
      dateAdded: DateTime.parse(map['date_added'] as String),
      imagePath: map['image_path'] as String?,
    );
  }

  static PlantIdentification _identificationFromMap(Map<String, dynamic> map) {
    final resultsJson = jsonDecode(map['results'] as String) as List<dynamic>;
    final results = resultsJson.map((r) => IdentificationResult.fromJson(r as Map<String, dynamic>)).toList();
    
    return PlantIdentification(
      id: map['id'] as String,
      imagePath: map['image_path'] as String,
      results: results,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}