import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class ApiService {
  static const String baseUrl = 'https://api.jamendo.com/v3.0';
  static const String clientId = 'bc66595a';

  static Future<List<Track>> getTracks({int offset = 0, int limit = 20, String query = ''}) async {
    final String endpoint = query.isEmpty
        ? '$baseUrl/tracks/?client_id=$clientId&format=json&limit=$limit&offset=$offset'
        : '$baseUrl/tracks/?client_id=$clientId&format=json&namesearch=${Uri.encodeComponent(query)}&limit=$limit&offset=$offset';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.map((trackJson) => Track.fromJson(trackJson)).toList();
    } else {
      throw Exception('Failed to load tracks: ${response.statusCode}');
    }
  }
}