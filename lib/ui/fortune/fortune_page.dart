import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/api_state.dart';
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
  List<String> _tabs = [];

  @override
  void initState() {
    Debug.log("进了【运势】首页");
    _tabs = ApiState.is_guest ? ["免费测算"] : ["每日运势", "免费测算"];
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
              if (!ApiState.is_guest) DailyFortune(),
              FreeCalculate(),
            ],
          ),
        ),
        backgroundColor: fif_primary,
      ),
    );
  }

  Widget _appBar() {
    bool guest = ApiState.is_guest;
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
