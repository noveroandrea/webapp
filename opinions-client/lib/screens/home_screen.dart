import 'package:flutter/material.dart';
import '../services/api.dart'; //class Api

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () => Api.postAnswer(t['id'], '1'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () => Api.postAnswer(t['id'], '-1'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.grey),
                        onPressed: () => Api.postAnswer(t['id'], '0'),
                      ),
                    ],
                  ),
                );

              },
            ),
    );
  }
}
