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

  // selection values: '1' = yes, '-1' = no, '0' = torn, null = none
  List<String?> selections = [];
  List<TextEditingController> commentControllers = [];

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  @override
  void dispose() {
    for (final c in commentControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future loadTopics() async {
    setState(() => loading = true);
    final res = await Api.getTopics();

    // dispose old controllers if any
    for (final c in commentControllers) {
      c.dispose();
    }

    setState(() {
      topics = res;
      selections = List<String?>.filled(topics.length, null);
      commentControllers =
          List.generate(topics.length, (_) => TextEditingController());
      loading = false;
    });
  }

  void setSelection(int index, String value) {
    setState(() {
      selections[index] = value;
    });
  }

  Future<void> submitAnswer(int index) async {
    final t = topics[index];
    final sel = selections[index];
    if (sel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an answer.')));
      return;
    }

    // Call existing API (keeps same signature as before).
    // Note: comment is available in commentControllers[index].text if you want to send it.
    await Api.postAnswer(t['id'], sel);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer submitted.')));
  }

  Widget answerButton(
      {required String label,
      required String value,
      required bool selected,
      required VoidCallback onPressed}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? Colors.blue.shade100 : null,
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.blue.shade800 : null,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opinions')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: topics.length,
              itemBuilder: (context, i) {
                final t = topics[i];
                final selected = selections[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['title'] ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        if ((t['description'] ?? '').isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(t['description'] ?? '',
                              style: const TextStyle(color: Colors.black54)),
                        ],
                        const SizedBox(height: 12),
                        // Answer selection buttons: Yes, No, Torn
                        Row(
                          children: [
                            answerButton(
                              label: 'Yes',
                              value: '1',
                              selected: selected == '1',
                              onPressed: () => setSelection(i, '1'),
                            ),
                            const SizedBox(width: 8),
                            answerButton(
                              label: 'No',
                              value: '-1',
                              selected: selected == '-1',
                              onPressed: () => setSelection(i, '-1'),
                            ),
                            const SizedBox(width: 8),
                            answerButton(
                              label: 'Torn',
                              value: '0',
                              selected: selected == '0',
                              onPressed: () => setSelection(i, '0'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Comment input
                        TextField(
                          controller: commentControllers[i],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Comment',
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  selected == null ? null : () => submitAnswer(i),
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
