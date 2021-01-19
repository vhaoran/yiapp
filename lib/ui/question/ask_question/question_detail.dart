import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/ui/question/post_content.dart';
import 'package:yiapp/util/math_util.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/question_res.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_bo.dart';
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

  QueDetailPage(
      {this.barName, this.data, this.timeStr, this.liuYaoView, Key key})
      : super(key: key);

  @override
  _QueDetailPageState createState() => _QueDetailPageState();
}

class _QueDetailPageState extends State<QueDetailPage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商悬赏帖标准
  List<num> _prices = []; // 价格降序重新排列
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

  /// 用户获取运营商设置的悬赏帖和闪断帖的标准
  _fetch() async {
    try {
      var res = CusRole.isVie
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
      Log.error("用户获取运营商悬赏帖标准出现异常：$e");
    }
  }

  /// 满足发帖条件
  void _doPost() async {
    if (_score == 0) {
      CusToast.toast(context, text: "未选择悬赏金额", milliseconds: 1500);
      return;
    }
    _data.amt = _score;
    _data.level_id = _selectPrice.price_level_id;
    var m = _data.toJson();
    Log.info("发帖详情：$m");
    try {
      var data;
      data = CusRole.isVie
          ? await ApiBBSVie.bbsVieAdd(m)
          : await ApiBBSPrize.bbsPrizeAdd(m);
      if (data != null) {
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        String bType = CusRole.isVie ? b_bbs_vie : b_bbs_prize;
        BalancePay(
          context,
          data: PayData(amt: _data.amt, b_type: bType, id: data.id),
          onSuccess: () {
            CusRoute.push(
              context,
              PostContent(
                post: Post(is_vie: CusRole.isVie, is_ing: true),
                id: data.id,
                backData: true,
              ),
            ).then((value) {
              if (value != null) {
                Navigator.of(context).pop("");
              }
            });
          },
        );
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
      Log.error("我要提问${widget.barName}出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: widget.barName),
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
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: <Widget>[
                _postInfo(), // 帖子基本信息
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    CusRole.is_guest
                        ? ""
                        : _l.isEmpty
                            ? "运营商暂未设置悬赏金额"
                            : "请选择你的悬赏金额",
                    style: TextStyle(fontSize: S.sp(17), color: t_primary),
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
                SizedBox(height: S.h(20)),
              ],
            ),
          ),
          SizedBox(
            width: S.screenW(),
            child: CusRaisedButton(
              child: Text("完成，发${CusRole.isVie ? '闪断' : '悬赏'}帖"),
              borderRadius: 50,
              onPressed: _doPost,
            ),
          ),
          SizedBox(height: S.h(8)),
        ],
      ),
    );
  }

  /// 帖子基本信息
  Widget _postInfo() {
    TextStyle style1 = TextStyle(color: t_primary, fontSize: S.sp(17));
    TextStyle style2 = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.liuYaoView != null) // 六爻排盘信息
          widget.liuYaoView,
        SizedBox(height: S.h(10)),
        Text("基本信息", style: style1),
        Text("${_data.content.name}", style: style2), // 姓名
        Row(
          children: <Widget>[
            Text("${widget.timeStr}", style: style2), // 出生日期
            SizedBox(width: S.w(15)),
            // 性别
            Text("${_data.content.is_male ? '男' : '女'}", style: style2),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(15)),
          child: Divider(thickness: 0.2, height: 0, color: t_gray),
        ),
        Text("帖子标题", style: style1),
        Text("${_data.title}", style: style2), // 帖子标题
        SizedBox(height: S.h(15)),
        Text("帖子内容", style: style1),
        Text("${_data.brief}", style: style2), // 帖子内容
        SizedBox(height: S.h(15)),
        Divider(thickness: 0.2, height: 0, color: t_gray),
      ],
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
          "$val 元宝",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
