import 'package:code_x/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var API_Key = 'Token b2361d9e-2412-47f0-aa08-cb8045063130';
String defaultLangValue = 'c';
String finalUrl;
final textController = TextEditingController();
var code;
final String runBaseUrl = "https://run.glot.io/languages/";
int pos = 0;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getExtension(selectedLang) {
    if (selectedLang == 'python') {
      return "py";
    } else if (selectedLang == 'kotlin') {
      return "kt";
    } else
      return selectedLang;
  }

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
    return responseJson;
  }

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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: new Text(
          "CodeX",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
          child: DropdownButton<String>(
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
                  value.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black 
                  ),
                ),
              );
            }).toList(),
          )
          ),
          Ink(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 30.0,
              icon: Icon(Icons.account_circle),
              color: Colors.black26,
              onPressed: () {
                debugPrint("Icon Pressed");
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: TextField(
        autofocus: true,
        controller: textController,
        keyboardType: TextInputType.multiline,
        maxLines: 99,
        style: TextStyle(color: Colors.greenAccent),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(8.0),
            hintText: "Enter your code here."),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.done,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          code = textController.text;
          debugPrint(code);
          getResponse(defaultLangValue);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => inputBody()),
          );
        },
        label: Text(
          "Execute",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
