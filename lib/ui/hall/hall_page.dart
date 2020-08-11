import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_appbar.dart';
import 'package:yiapp/ui/hall/daily_fortune/daily_fortune.dart';
import 'package:yiapp/ui/hall/free_calculate/free_calculate.dart';

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

class _HallPageState extends State<HallPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print(">>>进了大厅");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), // 注释该属性，滑动屏幕也能切换页面
          children: <Widget>[DailyFortune(), FreeCalculate()],
        ),
        backgroundColor: fif_primary,
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
        onTap: (index) {},
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
