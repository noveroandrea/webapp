import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static const base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:4000/api');
  static const storage = FlutterSecureStorage();

  static Future<List> getTopics() async {
    final r = await http.get(Uri.parse('$base/topics'));
    if (r.statusCode == 200) return json.decode(r.body) as List;
    throw Exception('Failed to load topics');
  }

  static Future postAnswer(int topicId, String answer) async {
    // This client doesn't have answers table — we'll map answer to vote for demo
    final token=await storage.read(key: 'access_token');
    final r = await http.post(Uri.parse('$base/vote'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'}, body: json.encode({'user_id': 1, 'topic_id': topicId, 'vote': 1}));
    if (r.statusCode == 200) return;
    throw Exception('Failed to post answer');
  }

  static Future<String> login(String email, String password) async {
    final r = await http.post(Uri.parse('$base/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    if (r.statusCode == 200) {
      final body = json.decode(r.body);
      var token = body['token'];
      await Api.saveToken(body['token']);
      return token;
    }
    throw Exception('Login failed');
  }

  static Future<void> register(String name, String email, String password) async {
    final r = await http.post(Uri.parse('$base/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}));
    if (r.statusCode != 200) {
      throw Exception('Registration failed');
    }
  }
  
  static Future<void> saveToken(body) async {
    if (body != null) {
      // Store securely (Flutter)
      await storage.write(key: 'access_token', value: body);
    }
  }
}
