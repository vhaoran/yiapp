import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/complex/zhou_gong_res.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/fortune/free_calculate/zhou_gong_detail.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 09:49
// usage ：周公解梦页面
// ------------------------------------------------------

class ZhouGongPage extends StatefulWidget {
  ZhouGongPage({Key key}) : super(key: key);

  @override
  _ZhouGongPageState createState() => _ZhouGongPageState();
}

class _ZhouGongPageState extends State<ZhouGongPage> {
  var _searchCtrl = TextEditingController();
  List<ZhouGongRes> _l = []; // 周公解梦数据列表
  bool _searching = false; // 是否处于搜索状态

  /// 开始搜索
  void _doSearch() async {
    if (_searchCtrl.text.isEmpty) return;
    _searching = true;
    try {
      var res = await ApiFree.dreamSearch(_searchCtrl.text.trim());
      if (res != null) {
        _l = res;
        setState(() {});
      }
    } catch (e) {
      _l = [];
      setState(() {});
      Debug.logError("搜索周公解梦时出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "周公解梦"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
            child: _searchInput(), // 搜索输入框
          ),
          if (_searchCtrl.text.isNotEmpty && _l.isEmpty && _searching)
            Text("没有搜索到与【${_searchCtrl.text}】相关的梦境信息",
                style: TextStyle(color: t_primary, fontSize: Adapt.px(32))),
          Expanded(
            child: ScrollConfiguration(
              behavior: CusBehavior(),
              child: ListView(
                children: <Widget>[
                  ..._l.map((e) => _searchItem(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索输入框
  Widget _searchInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: Adapt.px(85),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15),
            color: Colors.grey,
            child: CusText("梦见", Colors.black, 30),
          ),
          Expanded(
            child: Container(
              height: Adapt.px(85),
              color: fif_primary,
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(color: Colors.grey, fontSize: Adapt.px(32)),
                decoration: InputDecoration(
                  hintText: "请输入汉字",
                  hintStyle:
                      TextStyle(color: Colors.grey, fontSize: Adapt.px(32)),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(left: 20),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp(r"[\u4e00-\u9fa5]"))
                ],
                onChanged: (val) {
                  _searching = false;
                  _l.clear();
                  setState(() {});
                },
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: Adapt.px(85),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color(0xFF89562D),
              child: CusText("开始解梦", t_gray, 30),
            ),
            onTap: _doSearch,
          ),
        ],
      ),
    );
  }

  /// 显示单个搜索结果封面
  Widget _searchItem(ZhouGongRes e) {
    return InkWell(
      onTap: () => CusRoute.push(context, ZhouGongDetail(res: e)),
      child: Card(
        color: t_gray,
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(20)),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              SizedBox(width: Adapt.px(30)),
              Expanded(
                child: Text(
                  e.title,
                  style: TextStyle(fontSize: Adapt.px(28)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
