import 'dart:async';

import 'package:cocksize_stats/client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _editingController = TextEditingController();
  final _cocksController = StreamController<List<CockUserDto>?>();

  @override
  void dispose() {
    _editingController.dispose();
    _cocksController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 22),
                const Text(
                  'Лучший кок года',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _editingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Токен из бота',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_editingController.text.isEmpty) return;
          
                        _cocksController.add(null);
          
                        try {
                          final result =
                              await StatsApi().getStats(_editingController.text);
                          _cocksController.add(result);
                          print(result);
                        } catch (e) {
                          _cocksController.addError(e);
                          print(e);
                        }
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: StreamBuilder<List<CockUserDto>?>(
                    stream: _cocksController.stream,
                    builder: (context, snapshot) {
                      final data = snapshot.data;
          
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('А токен-то палёный!'),
                        );
                      }
          
                      if (data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
          
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(data[index].username),
                          trailing: Text(data[index].cocksize.toString()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
