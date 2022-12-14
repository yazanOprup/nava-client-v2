import 'package:flutter/material.dart';
class TextFieldAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField AlertDemo'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('SUBMIT'),
                onPressed: () {print("hgfhdhghf");
                Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField AlertDialog Demo'),
      ),
      body: Center(
        child: TextButton(
          child: Text(
            'Show Alert',
            style: TextStyle(fontSize: 20.0),),
          // padding: EdgeInsets.fromLTRB(20.0,12.0,20.0,12.0),
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8.0)
          // ),
          // color: Colors.green,
          onPressed: () => _displayDialog(context),
        ),
      ),
    );
  }
}