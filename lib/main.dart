import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String text = '';
  String link = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.green,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Share Plus',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('MAD Practical'),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Text:',
                      hintText: 'Enter anything to share',
                    ),
                    maxLines: 2,
                    onChanged: (String value) => setState(() {
                      text = value;
                    }),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Subject:',
                      hintText: 'Enter subject to share',
                    ),
                    maxLines: 2,
                    onChanged: (String value) => setState(() {
                      link = value;
                    }),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed:
                            text.isEmpty ? null : () => _onShare(context),
                        child: const Text('Share'),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Pick document Files and share it'),
                    onPressed: () {
                      shareFile(context);
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(text,
        subject: link,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}

void shareFile(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;

  final result = await FilePicker.platform.pickFiles();
  List<String>? files =
      result?.files.map((file) => file.path).cast<String>().toList();
  if (files == null) {
    return;
  }

  await Share.shareFiles(files,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}
