import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  test('Test Plant API endpoint', () async {
    const String apiUrl = 'https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/plants_database.json';
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      expect(response.statusCode, 200);
      
      final List<dynamic> jsonData = json.decode(response.body);
      expect(jsonData, isA<List>());
      expect(jsonData.isNotEmpty, true);
      
      print('API test successful: Found ${jsonData.length} plants');
      
      // Print first plant structure for debugging
      if (jsonData.isNotEmpty) {
        print('Sample plant data: ${jsonData.first}');
      }
    } catch (e) {
      print('API test failed: $e');
      fail('API endpoint is not accessible');
    }
  });
}