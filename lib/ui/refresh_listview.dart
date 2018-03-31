import 'package:flutter/material.dart';


// TODO
// A ListView implements refresh feature. contains :
// 1.pull to refresh.
// 2.scroll to bottom of listview to refresh.
class RefreshListView extends StatefulWidget {

  int dataRawCount = 0;
  int dataCount = 0;
  IndexedWidgetBuilder generateItem = null;
  Function onRefreshByHeader = null;
  RefreshFooterWidget footerWidget = null;

  RefreshListView({
    Key key,
    this.dataRawCount,
    this.generateItem,
    this.onRefreshByHeader,
    Function onRefreshByFooter,
    Widget footerCustomWidget
  }): dataCount = dataRawCount + 1,
      footerWidget = new RefreshFooterWidget(
        footerCustomWidget: footerCustomWidget,
        onRefreshByFooter: onRefreshByFooter
      ),
      super(key: key);


  @override
  State<RefreshListView> createState() => new RefreshListViewState();

}

class RefreshListViewState extends State<RefreshListView> {




  _generateItem(BuildContext context, int position) {
    if (position == widget.dataCount - 1) {
      return new RefreshFooterWidget();
    } else {
      return widget.generateItem(context, position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ListView.builder(
          itemCount: widget.dataCount,
          itemBuilder: _generateItem,
      ),
      onRefresh: () async {
        await widget.onRefreshByHeader;
      },
    );
  }

}

class RefreshFooterWidget extends StatefulWidget {

  Widget footerCustomWidget = null;
  Function onRefreshByFooter = null;

  RefreshFooterWidget({
    this.footerCustomWidget,
    this.onRefreshByFooter
  });

  @override
  State<RefreshFooterWidget> createState() => new RefreshFooterWidgetState();

}

class RefreshFooterWidgetState extends State<RefreshFooterWidget> {

  @override
  void initState() {
    super.initState();
    widget.onRefreshByFooter();
  }

  @override
  Widget build(BuildContext context) {
    return widget.footerCustomWidget;
  }

}