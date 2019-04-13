import 'package:flutter/material.dart';

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
        actions: <Widget>[new Text("Login")
        ],
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
                new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: new Text("Clear"),
                  onPressed: () => debugPrint("Clear Pressed"),
                ),
                new RaisedButton(
                  shape: RoundedRectangleBorder(),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text("Execute"),
                  onPressed: () => debugPrint("Submit Pressed"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

String defaultLangValue = 'C';

class dropdownWidget extends StatefulWidget {
  @override
  _dropdownWidgetState createState() => _dropdownWidgetState();
}

class _dropdownWidgetState extends State<dropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: DropdownButton<String>(
          value: defaultLangValue,
          onChanged: (String newValue) {
            setState(() {
              defaultLangValue = newValue;
            });
          },
          items: <String>['C', 'C++', 'Python', 'Java']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
              style: TextStyle(
                color: Colors.black
              ),),
            );
          }).toList(),
        ),
      ),
    );
  }
}
