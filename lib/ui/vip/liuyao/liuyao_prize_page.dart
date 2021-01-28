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
import 'package:yiapp/ui/question/ask_question/que_container.dart';
import 'package:yiapp/ui/vip/prize/user_prize_doing_page.dart';
import 'package:yiapp/util/math_util.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
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
  var _titleCtrl = TextEditingController(); // 标题
  var _briefCtrl = TextEditingController(); // 摘要
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
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          SizedBox(height: S.h(5)),
          Center(
            child: Text(
              "填写你要咨询的问题",
              style: TextStyle(fontSize: S.sp(16), color: t_primary),
            ),
          ),
          SizedBox(height: S.h(5)),
          _titleWt(), // 设置标题
          _briefWt(), // 设置摘要
          // 提交六爻的基本信息
          PostComDetail(
            hideTitleBrief: true,
            prize: BBSPrize(
              title: _liuYaoData.title,
              brief: _liuYaoData.brief,
              content: _liuYaoData.content,
              content_type: submit_liuyao,
            ),
          ),
          SizedBox(height: S.h(5)),
          Center(
            child: Text(
              _l.isEmpty ? "运营商暂未设置悬赏金" : "选择悬赏金",
              style: TextStyle(fontSize: S.sp(16), color: t_primary),
            ),
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
          SizedBox(height: S.h(30)),
          // 发布悬赏帖按钮
          SizedBox(width: S.screenW(), child: _doPrizeOrderWt()),
          SizedBox(height: S.h(10)),
        ],
      ),
    );
  }

  /// 标题组件、如果是大师订单，则合并标题和摘要为同一个数据
  Widget _titleWt() {
    return QueContainer(
      title: "标题",
      child: Expanded(
        child: CusRectField(
          controller: _titleCtrl,
          hintText: "请输入标题",
          fromValue: "大师，我想问一下，玫瑰花现在多少钱",
          autofocus: false,
          hideBorder: true,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  /// 摘要组件
  Widget _briefWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CusRectField(
        controller: _briefCtrl,
        hintText: "该区域填写你的问题，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为你解答",
        fromValue: "大师，帮我测算一下，玫瑰花有什么效果，喝了可以飞黄腾达吗？",
        autofocus: false,
        hideBorder: true,
        maxLines: 10,
        pdHor: 0,
        onChanged: () => setState(() {}),
      ),
    );
  }

  /// 发悬赏帖按钮
  Widget _doPrizeOrderWt() {
    return CusRaisedButton(
      child: Text("发悬赏帖", style: TextStyle(fontSize: S.sp(14))),
      borderRadius: 50,
      onPressed: () {
        String err;
        if (_l.isEmpty) {
          CusDialog.tip(context, title: "因运营商暂未设置悬赏金，暂时无法发帖");
          return;
        } else {
          if (_titleCtrl.text.trim().isEmpty) {
            err = "请输入标题";
          } else if (_briefCtrl.text.trim().isEmpty) {
            err = "请输入摘要";
          } else if (_liuYaoData?.amt == 0) {
            err = "未选择悬赏金";
          }
        }
        if (err != null) {
          CusToast.toast(context, text: err, milliseconds: 1500);
          return;
        }
        _liuYaoData.title = _titleCtrl.text.trim();
        _liuYaoData.brief = _briefCtrl.text.trim();
        _doPrizeOrder(); // 发六爻悬赏帖
      },
    );
  }

  /// 发六爻悬赏帖
  void _doPrizeOrder() async {
    Log.info("提交六爻悬赏帖的数据：${_liuYaoData.toJson()}");
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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
