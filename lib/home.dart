import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

var apikey = '';
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
      'Authorization': apikey,
    };
    final response = await http.post(
        "https://run.glot.io/languages/" + selectedLang + "/latest",
        body: data,
        headers: head);
    final responseJson = json.decode(response.body);
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
      'Authorization': apikey,
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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.blueGrey[900],
                      contentPadding: EdgeInsets.all(8.0),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter your input here (if any)"),
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
    filePath = await FilePicker.getFilePath(type: FileType.any);
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: new Text(
          "CodeX",
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: DropdownButton<String>(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              dropdownColor: Colors.blueGrey[900],
              value: defaultLangValue == "c" ? 'c' : defaultLangValue,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                    style: TextStyle(color: Colors.blue[200]),
                  ),
                );
              }).toList(),
            ),
          ),
          Ink(
            decoration: ShapeDecoration(
              color: Colors.blueGrey[900],
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 30.0,
              icon: Icon(
                Icons.add,
                color: Colors.grey,
                size: 23,
              ),
              onPressed: () {
                getFile();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 150,
              child: TextField(
                cursorColor: Colors.greenAccent[400],
                cursorRadius: Radius.circular(10.0),
                cursorWidth: 5.0,
                controller: textController,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.multiline,
                maxLines: 99,
                style: TextStyle(color: Colors.blue[50]),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.blueGrey[800],
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: "Enter your code here."),
              ),
            ),
          ),
          RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.blue,
            onPressed: () {
              code = textController.text;
              debugPrint(code);
              openInputSheet(context);
            },
            child: Text(
              "RUN",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.0),
            ),
          ),
        ],
      ),
    );
  }
}
