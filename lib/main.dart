import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'copy_images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Transfer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Express Copy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  Future<String?> _selectDirectory() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  void _goButtonPressed() {
    copyImages(_sourceController.text, _destinationController.text);
    _doneDialog();
  }

  Future<void> _doneDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Done'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Copy complete!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, 'OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Select the source and destination folders below, then click Go! The files in the source folder will be copied to the destination folder '
                  'with sub folders created for each date.'),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                readOnly: true,
                controller: _sourceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Source'
                ),
                  onTap: () async {
                    String? dir = await _selectDirectory();
                    if (dir != null) {
                      _sourceController.text = dir;
                    }
                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                readOnly: true,
                controller: _destinationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Destination'
                ),
                onTap: () async {
                  String? dir = await _selectDirectory();
                  if (dir != null) {
                    _destinationController.text = dir;
                  }
                }
              ),
            ),

            ElevatedButton(
                onPressed: _goButtonPressed,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Go!')
                )
            ),

          ],
        ),
      ),
    );
  }
}
