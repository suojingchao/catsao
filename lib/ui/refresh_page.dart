import 'package:flutter/material.dart';
import 'package:catsao/util/stirngs_helper.dart';

/**
 * this page used to display some information about the error of loading, and lead to refresh.
 */
class RefreshPage extends StatelessWidget {

  Function onTap = null;

  RefreshPage({this.onTap});

  _generateBody() {
    return new GestureDetector(
      child: new Container(
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: new Image.asset('assets/refresh.png')
              ),
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: new Text(
                    StringResources.REFRESH,
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey
                    ),
                  )
              )
            ]
          ),
        )
      ),
      onTap: onTap
    );
  }

  @override
  Widget build(BuildContext context) {
    return _generateBody();
  }

}