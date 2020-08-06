import 'package:flutter/material.dart';
import '../../complex/tools/cus_widget.dart';
import '../../complex/tools/cus_function.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 11:22
// usage ：首页
// ------------------------------------------------------

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tc;

  @override
  void initState() {
    _tc = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyCtr(),
        backgroundColor: Colors.white60,
      ),
    );
  }

  Widget _appBar() {
    return CusAppBar(
      showLeading: false,
      bottom: TabBar(
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: CusColors.text,
        labelPadding: EdgeInsets.only(bottom: 10),
        unselectedLabelColor: Colors.white,
        labelColor: CusColors.text,
        tabs: <Widget>[
          Text('每日运势', style: TextStyle(fontSize: 16)),
          Text('免费测算', style: TextStyle(fontSize: 16)),
        ],
        controller: _tc,
        onTap: (index) {
          print(">>>当前index:$index");
        },
      ),
    );
  }

  Widget _bodyCtr() {
    return TabBarView(controller: _tc, children: <Widget>[
      Center(child: Text('每日运势')),
      Center(child: Text('免费测算')),
    ]);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }
}
