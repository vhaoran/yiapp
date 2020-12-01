import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
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
  List<String> _tabs = [];

  @override
  void initState() {
    Log.info("进了【运势】首页");
    _tabs = CusRole.is_guest ? ["免费测算"] : ["每日运势", "免费测算"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: _appBar(),
        body: ScrollConfiguration(
          behavior: CusBehavior(),
          child: TabBarView(
            children: <Widget>[
              if (!CusRole.is_guest) DailyFortune(),
              FreeCalculate(),
            ],
          ),
        ),
        backgroundColor: fif_primary,
      ),
    );
  }

  Widget _appBar() {
    bool guest = CusRole.is_guest;
    return CusAppBar(
      showLeading: false,
      textColor: t_primary,
      bottom: TabBar(
        indicatorWeight: Adapt.px(guest ? 0.01 : 6),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: guest ? primary : t_primary,
        labelPadding: EdgeInsets.only(bottom: Adapt.px(guest ? 12 : 18)),
        labelColor: t_primary,
        unselectedLabelColor: t_gray,
        tabs: List.generate(
          _tabs.length,
          (i) => Text(_tabs[i], style: TextStyle(fontSize: Adapt.px(34))),
        ),
        onTap: (index) {},
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
