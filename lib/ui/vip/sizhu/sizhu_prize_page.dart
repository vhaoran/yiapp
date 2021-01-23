import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/util/math_util.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午2:14
// usage ：四柱悬赏帖求测
// ------------------------------------------------------

class SiZhuPrizePage extends StatefulWidget {
  final SubmitSiZhuData siZhuData;

  SiZhuPrizePage({this.siZhuData, Key key}) : super(key: key);

  @override
  _SiZhuPrizePageState createState() => _SiZhuPrizePageState();
}

class _SiZhuPrizePageState extends State<SiZhuPrizePage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商悬赏帖标准
  List<num> _prices = []; // 价格降序重新排列
  int _select = -1; // 当前选择的第几个悬赏帖标准
  num _score = 0; // 选择的悬赏金额
  var _selectPrice = PriceLevelRes(); // 选择的悬赏帖标准详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 用户获取运营商设置的悬赏帖和闪断帖的标准
  _fetch() async {
    try {
      var res = await ApiBo.brokerPriceLevelPrizeUserList();
      if (res != null) {
        _l = res;
        if (res.isNotEmpty) {
          List<num> l = res.map((e) => e.price).toList();
          _prices = MathUtil.listSort(l, up: false);
        }
      }
    } catch (e) {
      Log.error("会员获取运营商悬赏帖标准出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "四柱测算"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          SizedBox(height: S.h(15)),
//          PostComDetail(),
          // 四柱基本信息，含姓名、出生日期、性别
          _siZhuInfoWt(),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              _l.isEmpty ? "运营商暂未设置悬赏金" : "请选择你的悬赏金",
              style: TextStyle(fontSize: S.sp(16), color: t_primary),
            ),
          ),
          // 运营商如果已经设置了悬赏金额，用户才可以看到下面这些
          if (_l.isNotEmpty) ...[
            // 选择悬赏金额
            Wrap(
              children: List.generate(
                  _prices.length, (i) => _priceItem(_prices[i], i)),
            ),
          ],
          SizedBox(height: S.h(35)),
          SizedBox(
            width: S.screenW(),
            child: CusRaisedButton(
              child: Text("发悬赏帖"),
              borderRadius: 50,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  /// 单个悬赏帖标准组件
  Widget _priceItem(num val, int select) {
    bool checked = _select == select;
    return InkWell(
      onTap: () {
        _score = val;
        if (_select != select) _select = select;
        // 获取当前选择标准的详情
        _selectPrice = _l.singleWhere(
          (e) => e.price == val,
          orElse: () => null,
        );
        Log.info("选择的标准详情:${_selectPrice.toJson()}");
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: checked ? t_primary : t_gray,
        ),
        child: Text(
          "$val 元宝",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  /// 四柱基本信息，含姓名、出生日期、性别
  Widget _siZhuInfoWt() {
    SiZhuContent content = widget.siZhuData.content;
    String name = content.name.isEmpty ? "匿名" : content.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "姓名：$name",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ), // 姓名
        SizedBox(height: S.h(5)),
        Row(
          children: <Widget>[
            Text(
              "${TimeUtil.YMDHM(date: content.dateTime())}",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ), // 出生日期
            SizedBox(width: S.w(15)),
            // 性别
            Text(
              "${content.is_male ? '男' : '女'}",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ],
        ),
        Divider(thickness: 0.2, height: S.h(10), color: t_gray),
      ],
    );
  }
}
