import 'dart:convert';
import 'dart:typed_data';

import '../utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('log'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              child: Icon(Icons.clear_all).onTap(() {
                logstring.clear();
                toast('cleared',
                    gravity: ToastGravity.TOP, bgColor: Colors.transparent);
                setState(() {});
              }),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: logstring.isEmpty
                ? [Text('No log')]
                : logstring.reversed.map((log) {
                    return SelectableText("$log\n$line");
                  }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: Icon(Icons.file_download_done),
      ),
    );
  }

  _save() async {
    final now = DateTime.now();
    try {
      Uint8List bytes = utf8.encode(logstring.toString());

      // Pick a file
      final result = await FilePicker.platform.saveFile(
          type: FileType.custom,
          fileName:
              '${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}.log',
          bytes: bytes);

      toast('file saved at $result');
    } catch (e) {
      toast(e.toString());
    }
  }
}
