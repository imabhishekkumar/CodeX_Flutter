import 'package:flutter/material.dart';

class inputBody extends StatefulWidget {
  @override
  _inputBodyState createState() => _inputBodyState();
}

class _inputBodyState extends State<inputBody> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
      body: Container(
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
    ) ;
  }
}