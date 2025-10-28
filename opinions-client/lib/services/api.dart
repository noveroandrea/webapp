import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:4000/api');

  static Future<List> getTopics() async {
    final r = await http.get(Uri.parse('$base/topics'));
    if (r.statusCode == 200) return json.decode(r.body) as List;
    throw Exception('Failed to load topics');
  }

  static Future postAnswer(int topicId, String answer) async {
    // This client doesn't have answers table — we'll map answer to vote for demo
    final r = await http.post(Uri.parse('$base/vote'),
        headers: {'Content-Type': 'application/json'}, body: json.encode({'user_id': 1, 'topic_id': topicId, 'vote': 1}));
    if (r.statusCode == 200) return;
    throw Exception('Failed to post answer');
  }
}
