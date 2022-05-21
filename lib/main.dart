import 'package:flutter/material.dart';

void main() => runApp(const EngineeringLogbookApp());

class EngineeringLogbookApp extends StatelessWidget {
  const EngineeringLogbookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchTermController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engineering Logbook')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add log entry',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildSearchRow(),
          ],
        ),
      ),
    );
  }

  Row _buildSearchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _searchTermController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search log entries...',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) async {},
              autofocus: true,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _searchTermController.dispose();
    super.dispose();
  }
}
