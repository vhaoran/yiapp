import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'daily_fortune/daily_fortune.dart';
import 'free_calculate/free_calculate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 18:58
// usage ：底部导航栏 - 运势
// ------------------------------------------------------

class FortunePage extends StatefulWidget {
  FortunePage({Key key}) : super(key: key);

  @override
  _FortunePageState createState() => _FortunePageState();
}

class _FortunePageState extends State<FortunePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Debug.log("进了【运势】首页");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: ScrollConfiguration(
          behavior: CusBehavior(),
          child: TabBarView(
            children: <Widget>[DailyFortune(), FreeCalculate()],
          ),
        ),
        backgroundColor: fif_primary,
      ),
    );
  }

  Widget _appBar() {
    return CusAppBar(
      showLeading: false,
      bottom: TabBar(
        indicatorWeight: Adapt.px(6),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: t_primary,
        labelPadding: EdgeInsets.only(bottom: Adapt.px(18)),
        labelColor: t_primary,
        unselectedLabelColor: t_gray,
        tabs: <Widget>[
          Text('每日运势', style: TextStyle(fontSize: Adapt.px(34))),
          Text('免费测算', style: TextStyle(fontSize: Adapt.px(34))),
        ],
        onTap: (index) {},
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
