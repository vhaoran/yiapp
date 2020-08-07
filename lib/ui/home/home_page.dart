import 'package:flutter/material.dart';
import '../../complex/const/const_color.dart';
import '../../complex/widgets/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 11:22
// usage ：首页(运势)
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
    return Scaffold(
      appBar: _appBar(),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _appBar() {
    return CusAppBar(
      showLeading: false,
      bottom: TabBar(
        controller: _tc,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: t_primary,
        labelPadding: EdgeInsets.only(bottom: 10),
        labelColor: t_primary,
        unselectedLabelColor: t_gray,
        tabs: <Widget>[
          Text('每日运势', style: TextStyle(fontSize: 16)),
          Text('免费测算', style: TextStyle(fontSize: 16)),
        ],
        onTap: (index) {
          print(">>>当前index:$index");
        },
      ),
    );
  }

  Widget _bodyCtr() {
    return TabBarView(controller: _tc, children: <Widget>[
      Center(
        child: Text('每日运势', style: TextStyle(fontSize: 16, color: t_gray)),
      ),
      Center(
        child: Text('免费测算', style: TextStyle(fontSize: 16, color: t_gray)),
      ),
    ]);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }
}
