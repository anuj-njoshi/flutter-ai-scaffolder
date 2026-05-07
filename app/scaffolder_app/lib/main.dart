import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Home()));
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  bool auth = true;
  bool darkMode = true;

  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: step == 0
          ? Column(
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "App Name")),
                TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
                ElevatedButton(onPressed: () => setState(() => step = 1), child: Text("Next"))
              ],
            )
          : step == 1
              ? Column(
                  children: [
                    SwitchListTile(
                      title: Text("Auth"),
                      value: auth,
                      onChanged: (v) => setState(() => auth = v),
                    ),
                    SwitchListTile(
                      title: Text("Dark Mode"),
                      value: darkMode,
                      onChanged: (v) => setState(() => darkMode = v),
                    ),
                    ElevatedButton(onPressed: () => setState(() => step = 2), child: Text("Next"))
                  ],
                )
              : Column(
                  children: [
                    Text("Ready to generate"),
                   ElevatedButton(
  onPressed: () async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/generate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
      }),
    );

    print(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Project Generated")),
    );
  },
  child: Text("Generate"),
),
                  ],
                ),
    );
  }
}