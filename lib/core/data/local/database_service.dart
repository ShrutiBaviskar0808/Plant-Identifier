import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/plant.dart';
import '../models/user_plant.dart';
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

      await _insertInitialData();
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
        image_url TEXT NOT NULL,
        care_data TEXT NOT NULL,
        tags TEXT NOT NULL
      )
    ''');

    // User plants table
    await db.execute('''
      CREATE TABLE user_plants (
        id TEXT PRIMARY KEY,
        plant_data TEXT NOT NULL,
        custom_name TEXT,
        notes TEXT NOT NULL,
        date_added TEXT NOT NULL,
        location TEXT,
        photos TEXT NOT NULL
      )
    ''');

    // Plant identifications table
    await db.execute('''
      CREATE TABLE plant_identifications (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        results_data TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _insertInitialData() async {
    if (_database == null) return;

    // Check if data already exists
    final count = Sqflite.firstIntValue(
      await _database!.rawQuery('SELECT COUNT(*) FROM plants')
    );

    if (count != null && count > 0) return;

    // Insert sample plants
    final samplePlants = _getSamplePlants();
    for (final plant in samplePlants) {
      await insertPlant(plant);
    }
  }

  static List<Plant> _getSamplePlants() {
    return [
      Plant(
        id: 'rose_001',
        commonName: 'Rose',
        scientificName: 'Rosa rubiginosa',
        family: 'Rosaceae',
        category: 'Flowering Plant',
        description: 'A classic flowering plant known for its beauty and fragrance.',
        imageUrl: 'assets/images/plants/rose.jpg',
        care: const CareRequirements(
          waterFrequency: 'Twice weekly',
          lightRequirement: 'Full sun',
          soilType: 'Well-draining, fertile',
          temperature: '15-25°C',
          humidity: '40-70%',
          fertilizer: 'Monthly during growing season',
        ),
        tags: ['outdoor', 'flowering', 'fragrant'],
      ),
      Plant(
        id: 'monstera_001',
        commonName: 'Monstera Deliciosa',
        scientificName: 'Monstera deliciosa',
        family: 'Araceae',
        category: 'Houseplant',
        description: 'Popular indoor plant with distinctive split leaves.',
        imageUrl: 'assets/images/plants/monstera.jpg',
        care: const CareRequirements(
          waterFrequency: 'Weekly',
          lightRequirement: 'Bright indirect light',
          soilType: 'Well-draining potting mix',
          temperature: '18-27°C',
          humidity: '50-80%',
          fertilizer: 'Monthly in spring/summer',
        ),
        tags: ['indoor', 'tropical', 'easy-care'],
      ),
    ];
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
        'image_url': plant.imageUrl,
        'care_data': jsonEncode(plant.care.toJson()),
        'tags': jsonEncode(plant.tags),
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

  static Future<List<Plant>> searchPlants(String query) async {
    if (_database == null) return [];

    final maps = await _database!.query(
      'plants',
      where: 'common_name LIKE ? OR scientific_name LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return maps.map((map) => _plantFromMap(map)).toList();
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
        'notes': jsonEncode(userPlant.notes),
        'date_added': userPlant.dateAdded.toIso8601String(),
        'location': userPlant.location,
        'photos': jsonEncode(userPlant.photos),
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
        'results_data': jsonEncode(identification.results.map((r) => r.toJson()).toList()),
        'timestamp': identification.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PlantIdentification>> getPlantIdentifications() async {
    if (_database == null) return [];

    final maps = await _database!.query(
      'plant_identifications',
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => _identificationFromMap(map)).toList();
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
      imageUrl: map['image_url'] as String,
      care: CareRequirements.fromJson(jsonDecode(map['care_data'] as String)),
      tags: List<String>.from(jsonDecode(map['tags'] as String)),
    );
  }

  static UserPlant _userPlantFromMap(Map<String, dynamic> map) {
    return UserPlant(
      id: map['id'] as String,
      plant: Plant.fromJson(jsonDecode(map['plant_data'] as String)),
      customName: map['custom_name'] as String?,
      notes: List<String>.from(jsonDecode(map['notes'] as String)),
      dateAdded: DateTime.parse(map['date_added'] as String),
      location: map['location'] as String?,
      photos: List<String>.from(jsonDecode(map['photos'] as String)),
    );
  }

  static PlantIdentification _identificationFromMap(Map<String, dynamic> map) {
    final resultsData = jsonDecode(map['results_data'] as String) as List;
    final results = resultsData
        .map((r) => IdentificationResult.fromJson(r as Map<String, dynamic>))
        .toList();

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