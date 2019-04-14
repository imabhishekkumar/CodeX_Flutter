import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        actions: <Widget>[new Text("Login")],
        backgroundColor: Colors.blueAccent,
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            dropdownWidget(),
            Container(
              margin: EdgeInsets.all(8.0),
              // hack textfield height
              padding: EdgeInsets.only(bottom: 40.0),
              child: new TextField(
                autofocus: true,
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
                      debugPrint("Execute Pressed");
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String defaultLangValue = ''; //languages[2];

class dropdownWidget extends StatefulWidget {
  @override
  _dropdownWidgetState createState() => _dropdownWidgetState();
}

class _dropdownWidgetState extends State<dropdownWidget> {
  final String langUrl = "https://run.glot.io/languages";
  List<String> languages = [];
  @override
  void initState() {
    super.initState();
    this.apiCall();
  }

  List _data;

  void apiCall() async {
    _data = await getLanguages();
    for (var i = 0; i <= _data.length - 1; i++) {
      this.languages.add(_data[i]["name"]);
    }
    print(languages);
  }

  Future<List> getLanguages() async {
    http.Response langResponse = await http.get(langUrl);
    return json.decode(langResponse.body);
  }

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
            value: defaultLangValue == "" ? 'c' : defaultLangValue,
            onChanged: (String newValue) {
              setState(() {
                defaultLangValue = newValue;
              });
            },
            items: languages // <String>['C', 'C++', 'Python', 'Java']
                .map<DropdownMenuItem<String>>((String value) {
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
