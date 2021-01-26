import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/vip/prize/user_prize_doing_page.dart';
import 'package:yiapp/util/math_util.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午6:56
// usage ：六爻悬赏帖求测
// ------------------------------------------------------

class LiuYaoPrizePage extends StatefulWidget {
  final SubmitLiuYaoData liuYaoData;

  LiuYaoPrizePage({this.liuYaoData, Key key}) : super(key: key);

  @override
  _LiuYaoPrizePageState createState() => _LiuYaoPrizePageState();
}

class _LiuYaoPrizePageState extends State<LiuYaoPrizePage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商悬赏帖标准
  List<num> _prices = []; // 价格降序重新排列
  int _select = -1; // 当前选择的第几个悬赏帖标准
  SubmitLiuYaoData _liuYaoData;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员获取运营商设置的悬赏帖的标准
  _fetch() async {
    try {
      _liuYaoData = widget.liuYaoData;
      var res = await ApiBo.brokerPriceLevelPrizeUserList();
      if (res != null) {
        _l = res;
        if (res.isNotEmpty) {
          List<num> l = res.map((e) => e.price).toList();
          var set = Set<num>(); // 数据去重
          set.addAll(l);
          _prices = MathUtil.listSort(set.toList(), up: false);
        }
      }
    } catch (e) {
      Log.error("会员六爻测算获取运营商悬赏帖标准出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "六爻测算"),
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
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: S.w(10)),
              children: <Widget>[
                SizedBox(height: S.h(5)),
                Text(
                  "六爻信息",
                  style: TextStyle(fontSize: S.sp(16), color: t_primary),
                ),
                // 提交六爻的基本信息
                PostComDetail(
                  prize: BBSPrize(
                    title: _liuYaoData.title,
                    brief: _liuYaoData.brief,
                    content: _liuYaoData.content,
                    content_type: submit_liuyao,
                  ),
                ),
                SizedBox(height: S.h(5)),
                Text(
                  _l.isEmpty ? "运营商暂未设置悬赏金" : "选择悬赏金",
                  style: TextStyle(fontSize: S.sp(16), color: t_primary),
                ),
                SizedBox(height: S.h(5)),
                // 运营商如果已经设置了悬赏金额，用户才可以看到下面这些
                if (_l.isNotEmpty) ...[
                  // 选择悬赏金额
                  Wrap(
                    children: List.generate(
                        _prices.length, (i) => _priceItem(_prices[i], i)),
                  ),
                ],
              ],
            ),
          ),
        ),
        // 发布悬赏帖按钮
        SizedBox(width: S.screenW(), child: _doPrizeOrderWt()),
      ],
    );
  }

  /// 发悬赏帖按钮
  Widget _doPrizeOrderWt() {
    return CusRaisedButton(
      child: Text("发悬赏帖", style: TextStyle(fontSize: S.sp(14))),
      borderRadius: 50,
      onPressed: () {
        if (_l.isEmpty) {
          CusDialog.tip(context, title: "因运营商暂未设置悬赏金，暂时无法发帖");
          return;
        } else {
          if (_liuYaoData?.amt == 0) {
            CusToast.toast(context, text: "未选择悬赏金", milliseconds: 1500);
            return;
          }
        }
        if (_liuYaoData != null) {
          Log.info("发帖数据：${_liuYaoData.toJson()}");
          _doPrizeOrder(); // 发六爻悬赏帖
        } else {
          Log.error("提交的六爻测试数据为空");
        }
      },
    );
  }

  /// 发六爻悬赏帖
  void _doPrizeOrder() async {
    try {
      BBSPrize prize = await ApiBBSPrize.bbsPrizeAdd(_liuYaoData.toJson());
      if (prize != null) {
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        BalancePay(
          context,
          data:
              PayData(amt: _liuYaoData.amt, b_type: b_bbs_prize, id: prize.id),
          onSuccess: () {
            CusRoute.push(
              context,
              UserPrizeDoingPage(
                postId: prize.id,
                backData: "发六爻悬赏帖后进入处理中页面，然后返回时携带数据",
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
      Log.error("六爻悬赏帖下单出现异常：$e");
    }
  }

  /// 单个悬赏帖标准组件
  Widget _priceItem(num val, int select) {
    bool checked = _select == select;
    return InkWell(
      onTap: () {
        if (_select != select) _select = select;
        // 获取当前选择标准的详情
        PriceLevelRes selectPrice = _l.firstWhere(
          (e) => e.price == val,
          orElse: () => null,
        );
        Log.info("当前的悬赏金标准：${selectPrice.toJson()}");
        _liuYaoData.amt = val;
        _liuYaoData.level_id = selectPrice.price_level_id;
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
