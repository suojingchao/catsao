import 'package:flutter/material.dart';

class DrawerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset("assets/flutter_bg.png"),
            new Row(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Text("where"),
                    new Text("temperature")
                  ],
                ),
                new Image.asset("assets/weather-sunny.png")
              ]
            )
          ],
        )
      )
    );
  }

}