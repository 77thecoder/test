import 'dart:typed_data';

import 'package:epub_test/table_of_contents.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final EpubController _epubController;

  Future<Uint8List> _loadFromAssets(String assetName) async {
    final bytes = await rootBundle.load(assetName);
    return bytes.buffer.asUint8List();
  }

  @override
  void initState() {
    _epubController = EpubController(
      // Load document
      document: EpubReader.readBook(_loadFromAssets('assets/1.epub')),
      // Set start point
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );

    super.initState();
  }

  void readBook() {
    print('test');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: EpubView(
          controller: _epubController,
          onDocumentLoaded: (document) {
            print('isLoaded: $document');
          },
          dividerBuilder: (_) => Divider(),
          textStyle: TextStyle(
            // color: Colors.red,
            height: 1.25,
            fontSize: 14,
            // backgroundColor: Colors.yellow,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: readBook,
        child: Icon(Icons.book),
      ),
      drawer: Drawer(
        child: TableOfContents(
          controller: _epubController,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
