import 'package:flutter/material.dart';

class Change extends StatelessWidget {
  final Function selectHandler;

  Change(this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: RaisedButton(
        color: Colors.brown,
        textColor: Colors.black,
        child: Text('Change!'),
        onPressed: selectHandler,
      ),
    );
  }
}
