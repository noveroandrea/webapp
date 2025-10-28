import 'package:flutter/material.dart';
import '../services/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List topics = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  Future loadTopics() async {
    setState(() => loading = true);
    final res = await Api.getTopics();
    setState(() {
      topics = res;
      loading = false;
    });
  }

  void openAnswerDialog(int topicId) async {
    final TextEditingController ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Post an answer'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Your answer')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('Post')),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      await Api.postAnswer(topicId, result.trim());
      loadTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opinions')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, i) {
                final t = topics[i];
                return ListTile(
                  title: Text(t['title']),
                  subtitle: Text(t['description'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.reply),
                    onPressed: () => openAnswerDialog(t['id']),
                  ),
                );
              },
            ),
    );
  }
}
