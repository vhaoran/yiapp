import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/cus_behavior.dart';
import 'package:yiapp/ui/ask_fate/master_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 19:33
// usage ：问命
// ------------------------------------------------------

class AskFatePage extends StatefulWidget {
  AskFatePage({Key key}) : super(key: key);
  @override
  _AskFatePageState createState() => _AskFatePageState();
}

class _AskFatePageState extends State<AskFatePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List<String> _l = ["推荐榜", "好评榜", "资深榜", "订单榜"];

  @override
  void initState() {
    print(">>>进了问命页面");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _l.length,
      child: Scaffold(
        appBar: CusAppBar(title: _searchBar(), showLeading: false),
        body: _lv(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 60,
          color: Colors.grey,
          child: Text("待做区域", style: TextStyle(fontSize: 18)),
        ),
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _l.length,
            (index) => Text(
              _l[index],
              style: TextStyle(fontSize: Adapt.px(28)),
            ),
          ),
        ),
        SizedBox(height: Adapt.px(8)),
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: TabBarView(
              children: List.generate(
                _l.length,
                (index) => MasterList(l: 15),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 搜索框
  Widget _searchBar() {
    double border = 10;
    return Container(
      height: appBarH - border,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: fou_primary,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "搜索",
          hintStyle: TextStyle(color: t_primary),
          prefixIcon: Image.asset("assets/images/b.png"),
          contentPadding: EdgeInsets.only(left: Adapt.px(40)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: t_primary, width: 1),
            borderRadius: BorderRadius.circular(border),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
