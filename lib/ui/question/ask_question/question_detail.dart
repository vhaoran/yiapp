import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/util/math_util.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/bbs/question_res.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/mine/fund_account/recharge_page.dart';
import 'post_liuyao.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 下午3:39
// usage ：问命结果详情（将悬赏金额单独设置到一个页面，方便后期对不同金额增加内容）
// ------------------------------------------------------

class QueDetailPage extends StatefulWidget {
  final QuestionRes data;
  final String barName;
  final String timeStr;
  final PostLiuYaoCtr liuYaoView;

  QueDetailPage({
    this.barName,
    this.data,
    this.timeStr,
    this.liuYaoView,
    Key key,
  }) : super(key: key);

  @override
  _QueDetailPageState createState() => _QueDetailPageState();
}

class _QueDetailPageState extends State<QueDetailPage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商悬赏帖标准
  List<num> _prices = []; // 价格降序
  num _score = 0; // 选择的悬赏金额
  int _select = -1; // 当前选择的第几个悬赏帖标准
  var _selectPrice = PriceLevelRes(); // 选择的悬赏帖标准详情
  var _data = QuestionRes(); // 帖子详情

  @override
  void initState() {
    _data = widget.data;
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = CusRole.isFlash
          ? await ApiBo.brokerPriceLevelVieUserList()
          : await ApiBo.brokerPriceLevelPrizeUserList();
      if (res != null) {
        _l = res;
        if (res.isNotEmpty) {
          List<num> l = res.map((e) => e.price).toList();
          _prices = MathUtil.listSort(l, up: false);
        }
      }
    } catch (e) {
      Log.error("获取运营商悬赏帖标准出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: widget.barName),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
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
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (widget.liuYaoView != null) // 六爻排盘信息
                      widget.liuYaoView,
                    SizedBox(height: 15),
                    _titleCtr("基本信息"),
                    Row(
                      children: <Widget>[
                        _subtitleCtr("${_data.content.name}"), // 姓名
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: _subtitleCtr("${widget.timeStr}"),
                        ), // 出生日期
                        _subtitleCtr(
                            "${_data.content.is_male ? '男' : '女'}"), // 性别
                      ],
                    ),
                    CusDivider(),
                    _titleCtr("帖子标题"),
                    _subtitleCtr("${_data.title}"),
                    _titleCtr("帖子内容"),
                    _subtitleCtr("${_data.brief}"),
                  ],
                ),
                CusDivider(),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    _l.isEmpty ? "运营商暂未设置悬赏金额" : "请选择您的悬赏金额",
                    style: TextStyle(fontSize: 18, color: t_primary),
                  ),
                ),
                // 运营商如果已经设置了悬赏金额，用户才可以看到下面这些
                if (_l.isNotEmpty) ...[
                  // 选择悬赏金额
                  Wrap(
                    children: List.generate(
                      _prices.length,
                      (i) => _priceItem(_prices[i], i),
                    ),
                  ),
                ],
                SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: CusRaisedBtn(
              text: "完成，发${CusRole.isFlash ? '闪断' : '悬赏'}帖",
              minWidth: double.infinity,
              backgroundColor: Colors.blueGrey,
              onPressed: _doPost,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  /// 悬赏帖标准
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
          "${val} 元宝",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  /// 满足发帖条件
  void _doPost() async {
    if (_score == 0) {
      CusToast.toast(context, text: "未选择悬赏金额", milliseconds: 1500);
      return;
    }
//    BalancePay(context);
    _data.amt = _score;
    _data.level_id = _selectPrice.price_level_id;
    var m = _data.toJson();
    Log.info("发帖详情：$m");
    SpinKit.threeBounce(context);
    try {
      var data;
      data = CusRole.isFlash
          ? await ApiBBSVie.bbsVieAdd(m)
          : await ApiBBSPrize.bbsPrizeAdd(m);
      if (data != null) {
        Navigator.pop(context);
        CusToast.toast(context, text: "发帖成功");
        CusRoute.pushReplacement(context, HomePage());
      }
    } catch (e) {
      if (e.toString().contains("余额")) {
        CusDialog.normal(
          context,
          title: "余额不足，请充值",
          textAgree: "充值",
          onApproval: () => CusRoute.push(
            context,
            RechargePage(amt: _data.amt),
          ),
        );
      }
      Log.error("我要提问出现异常：$e");
    }
  }

  /// 标题组件
  Widget _titleCtr(String text) {
    return Text(
      text,
      style: TextStyle(color: t_primary, fontSize: 18),
    );
  }

  /// 内容组件
  Widget _subtitleCtr(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(color: t_gray, fontSize: 16),
      ),
    );
  }
}
