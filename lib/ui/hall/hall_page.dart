import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 18:58
// usage ：大厅
// ------------------------------------------------------

class HallPage extends StatefulWidget {
  HallPage({Key key}) : super(key: key);

  @override
  _HallPageState createState() => _HallPageState();
}

class _HallPageState extends State<HallPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _appBar() {
    return CusAppBar(
      showLeading: false,
      bottom: TabBar(
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: t_primary,
        labelPadding: EdgeInsets.only(bottom: 8),
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

  Widget _body() {
    return TabBarView(
      children: <Widget>[
        Center(
          child: Text('每日运势页面', style: TextStyle(fontSize: 16, color: t_gray)),
        ),
        Center(
          child: Text('免费测算页面', style: TextStyle(fontSize: 16, color: t_gray)),
        ),
      ],
    );
  }
}
