import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var API_Key = 'Token b2361d9e-2412-47f0-aa08-cb8045063130';
String defaultLangValue = 'c';
String finalUrl;
final textController = TextEditingController();
var code;
final String runBaseUrl = "https://run.glot.io/languages/";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: new Text("CodeX"),
          actions: <Widget>[
            Ink(
              decoration: ShapeDecoration(
                color: Colors.blue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.account_circle),
                color: Colors.white,
                onPressed: () {
                  debugPrint("Icon Pressed");
                },
              ),
            ),
          ],
          backgroundColor: Colors.blueAccent,
        ),
        body: codeBody());
  }
}

class codeBody extends StatefulWidget {
  @override
  _codeBodyState createState() => _codeBodyState();
}

class _codeBodyState extends State<codeBody> {
  Future getResponse(selectedLang) async {
    var data = json.encode({
      "files": [
        {"name": "codex." + getExtension(selectedLang), "content": code}
      ]
    });
    Map<String, String> head = {
      'Content-type': 'application/json',
      'Authorization': API_Key,
    };
    final response = await http.post(
        "https://run.glot.io/languages/" + selectedLang + "/latest",
        body: data,
        headers: head);
    final responseJson = json.decode(response.body);
    print(responseJson);
  }

  String getExtension(selectedLang) {
    if (selectedLang == 'python') {
      return "py";
    } else if (selectedLang == 'kotlin') {
      return "kt";
    } else
      return selectedLang;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          dropdownWidget(),
          Container(
            margin: EdgeInsets.all(8.0),
            // hack textfield height
            padding: EdgeInsets.only(bottom: 40.0),
            child: new TextField(
              autofocus: true,
              controller: textController,
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  hintText: "Enter your code here."),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    debugPrint("Clear Pressed");
                    textController.clear();
                  },
                ),
              ),
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.done),
                  color: Colors.white,
                  onPressed: () {
                    code = textController.text;
                    debugPrint(code);
                    getResponse(defaultLangValue);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class dropdownWidget extends StatefulWidget {
  @override
  _dropdownWidgetState createState() => _dropdownWidgetState();
}

class _dropdownWidgetState extends State<dropdownWidget> {
  final List<String> languages = [
    'assembly',
    'ats',
    'bash',
    'c',
    'clojure',
    'cobol',
    'coffeescript',
    'cpp',
    'crystal',
    'csharp',
    'd',
    'elixir',
    'elm',
    'erlang',
    'fsharp',
    'go',
    'groovy',
    'haskell',
    'idris',
    'java',
    'javascript',
    'julia',
    'kotlin',
    'lua',
    'mercury',
    'nim',
    'ocaml',
    'perl',
    'perl6',
    'php',
    'python',
    'ruby',
    'rust',
    'scala',
    'swift',
    'typescript'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Choose target language: ",
              style: TextStyle(),
            ),
          ),
          DropdownButton<String>(
            value: defaultLangValue == "c" ? 'c' : defaultLangValue,
            onChanged: (String newValue) {
              setState(() {
                defaultLangValue = newValue;
              });
            },
            items: languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
