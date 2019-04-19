import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

var API_Key = 'Token b2361d9e-2412-47f0-aa08-cb8045063130';
String defaultLangValue = 'c';
String finalUrl;
String filePath;
File file;
final textController = TextEditingController();
final inputtextController = TextEditingController();
var code;
var input;
var output;
var stderr;
var toShow;
var error;
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
    } else if (selectedLang == 'typescript') {
      return "ts";
    } else if (selectedLang == 'assembly') {
      return "asm";
    } else if (selectedLang == 'bash') {
      return "sh";
    } else if (selectedLang == 'clojure') {
      return "clj";
    } else if (selectedLang == 'cobol') {
      return "cbl";
    } else if (selectedLang == 'csharp') {
      return "cs";
    } else if (selectedLang == 'javascript') {
      return "js";
    } else if (selectedLang == 'elixir') {
      return "ex";
    } else
      return selectedLang.toString();
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
    //print(responseJson);
    getOutput(responseJson);
  }

  Future getResponseInp(selectedLang) async {
    var data = json.encode({
      "stdin": input,
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
    getOutput(responseJson);
  }

  void getOutput(responseJson) {
    output = responseJson['stdout'];
    stderr = responseJson['stderr'];
    error = responseJson['error'];

    //print(responseJson);
    if (output != '') {
      print(output);
      toShow = output;
    } else if (stderr != '') {
      print(stderr);
      toShow = stderr;
    } else if (error != '') {
      print(error);
      toShow = error;
    }
    openOutputSheet(context);
  }

  openInputSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  controller: inputtextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: "Enter your input here (if any)."),
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  input = inputtextController.text;
                  if (input != '') {
                    getResponseInp(defaultLangValue);
                  } else {
                    getResponse(defaultLangValue);
                  }
                },
                textColor: Colors.black,
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Execute",
                ),
              ),
            ],
          );
        });
  }

  openOutputSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.fromLTRB(16, 38, 16, 38),
            child: Text(toShow),
          );
        });
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
  void getFile() async {
    filePath = await FilePicker.getFilePath(type: FileType.ANY);
    Future<String> getFileData(String path) async {
      return await rootBundle.loadString(path);
    }
    String data = await getFileData(filePath);
    setState(() {
      textController.text = data;
    });
    debugPrint(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "CodeX",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.all(8),
              child: DropdownButton<String>(
                value: defaultLangValue == "c" ? 'c' : defaultLangValue,
                style: TextStyle(),
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
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              )),
          Ink(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 30.0,
              icon: Icon(Icons.add),
              color: Colors.black54,
              onPressed: () {
                getFile();
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        maxLines: 99,
        style: TextStyle(color: Colors.black),
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
          openInputSheet(context);
        },
        label: Text(
          "Next",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
