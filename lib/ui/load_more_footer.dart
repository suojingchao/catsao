import 'package:flutter/material.dart';
import 'package:catsao/util/log_helper.dart';
import 'package:catsao/loader/loader.dart';

class LoadmoreFooter extends StatefulWidget {

  static const int MODE_LOADING = 0;
  static const int MODE_NO_MORE = 1;

  Animation animation = null;
  Function loadWorker = null;
  dynamic onLoadFinish = null;
  String text = '';
  int mode = MODE_LOADING;


  LoadmoreFooter({this.text, this.animation, this.loadWorker, this.onLoadFinish, this.mode});

  @override
  State<LoadmoreFooter> createState() => new LoadmoreFooterState();

}

class LoadmoreFooterState extends State<LoadmoreFooter> with SingleTickerProviderStateMixin {
  final TAG = 'LoadmoreFooterState';

  AnimationController controller = null;

  @override
  void initState() {
    Log.i(TAG, 'initState');
    super.initState();
    controller = new AnimationController(duration: new Duration(milliseconds: 1500), vsync: this);
    widget.animation = new Tween<double>(begin: 1.0, end: 0.0).animate(controller)
    ..addListener(() {
      setState(() {
      });
      Log.i(TAG, 'animation.value=${widget.animation.value}');
    });
    widget.animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      Log.i(TAG, 'animation.Status=${status}');
    });

    if (widget.mode == LoadmoreFooter.MODE_LOADING) {
      controller.forward();
      widget.loadWorker(DataSource.DATABASE);
    }
  }


  @override
  void dispose() {
    Log.i(TAG, 'dispose');
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Log.i(TAG, 'build');
    return new Center(
        child: new Opacity(
            opacity: widget.mode == LoadmoreFooter.MODE_LOADING ? widget.animation?.value : 1.0,
            child: new Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: new Container(
                    child: new Text(
                        widget.text,
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue
                        )
                    )
                )
            )
        )
    );
  }

}