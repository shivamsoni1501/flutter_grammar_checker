import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NLP Demo',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'NLP Project : Grammar Checker'),
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
  TextEditingController _text = TextEditingController();
  TextEditingController _cText = TextEditingController();

  _checkText(String text) async {
    // var newUri = Uri.parse('http://192.168.29.38/hi');
    var uri = Uri.parse('https://api.languagetool.org/v2/check');
    try {
      var res = await http.post(
        uri,
        body: {'language': 'en-US', 'text': text},
      );
      // var res = await http.get(uri);
      print(res);
      print(res.body);
      var data = jsonDecode(res.body) as Map<String, dynamic>;
      print(data);
      String newText = '';
      int i = 0;
      // String newText = '';
      var matches = data["matches"] as List<dynamic>;
      matches.forEach((element) {
        print(element);
        if (element.containsKey('replacements')) {
          // print(element['replacements']);
          // print(element['offset']);
          int off = element['offset'] as int;
          int len = element['length'] as int;
          // print(len);
          // print(off);
          if (i < off) {
            newText = newText + text.substring(i, off);
          }
          newText += element['replacements'][0]['value'] as String;
          // print(newText);
          i = off + len;
        }
      });
      if (i < text.length) {
        newText = newText + text.substring(i, text.length);
      }
      print(newText);
      return newText;
    } catch (e) {
      print('Error in parsing');
      return "Error in Parsing";
    }
  }

  @override
  void dispose() {
    _text.dispose();
    _cText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Center(
              child: SizedBox(
                width: 500,
                child: Text(
                  'This project is the simulation of advanced Natural Language Processing on Grammatically Incorrect sentence as well as misplaced words. In this project, we have used some advanced machine learning algorithms such as BERT Model to generate our results.',
                  textAlign: TextAlign.center,
                ),
              ),
            )),
            Container(
              constraints: BoxConstraints(
                minWidth: 200,
                maxWidth: 400,
              ),
              child: TextFormField(
                controller: _text,
                maxLength: 500,
                maxLines: 8,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 20,
                      ),
                      onPressed: () {
                        _text.clear();
                        _cText.clear();
                      },
                    ),
                    labelText: 'Enter Text Here'),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            ElevatedButton(
              onPressed: () async {
                var text = await _checkText(_text.text);
                _cText.text = text;
              },
              child: Text('Check'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 200,
                maxWidth: 400,
              ),
              child: TextFormField(
                controller: _cText,
                enabled: false,
                maxLines: 8,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Corrected Text'),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      border: Border.all(color: Colors.black87, width: 3),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 30,
                            spreadRadius: 0,
                            color: Colors.black54,
                            blurStyle: BlurStyle.outer)
                      ],
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'developed with ❤️ by ',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Color(0x90FFFFFF),
                            fontSize: 16),
                      ),
                      Text(
                        'Shivam',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
