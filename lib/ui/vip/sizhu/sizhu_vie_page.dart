import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/vip/vie/user_vie_doing_page.dart';
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
// date  ：2021/1/25 下午5:03
// usage ：四柱闪断帖求测
// ------------------------------------------------------

class SiZhuViePage extends StatefulWidget {
  final SubmitSiZhuData siZhuData;

  SiZhuViePage({this.siZhuData, Key key}) : super(key: key);

  @override
  _SiZhuViePageState createState() => _SiZhuViePageState();
}

class _SiZhuViePageState extends State<SiZhuViePage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商闪断帖标准
  List<num> _prices = []; // 价格降序重新排列
  int _select = -1; // 当前选择的第几个闪断帖标准
  SubmitSiZhuData _siZhuData;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员获取运营商设置的闪断帖的标准
  _fetch() async {
    try {
      _siZhuData = widget.siZhuData;
      var res = await ApiBo.brokerPriceLevelVieUserList();
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
      Log.error("会员获取运营商闪断帖标准出现异常：$e");
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
                  "四柱信息",
                  style: TextStyle(fontSize: S.sp(16), color: t_primary),
                ),
                // 提交四柱的基本信息
                PostComDetail(
                  vie: BBSVie(
                    title: _siZhuData.title,
                    brief: _siZhuData.brief,
                    content: _siZhuData.content,
                    content_type: submit_sizhu,
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
        // 发布闪断帖按钮
        SizedBox(width: S.screenW(), child: _doVieOrderWt()),
      ],
    );
  }

  /// 发闪断帖按钮
  Widget _doVieOrderWt() {
    return CusRaisedButton(
      child: Text("发闪断帖", style: TextStyle(fontSize: S.sp(14))),
      borderRadius: 50,
      onPressed: () {
        if (_l.isEmpty) {
          CusDialog.tip(context, title: "因运营商暂未设置悬赏金，暂时无法发帖");
          return;
        } else {
          if (_siZhuData?.amt == 0) {
            CusToast.toast(context, text: "未选择悬赏金", milliseconds: 1500);
            return;
          }
        }
        if (_siZhuData != null) {
          Log.info("发帖数据：${_siZhuData.toJson()}");
          _doVieOrder(); // 发四柱闪断帖
        } else {
          Log.error("提交的四柱测试数据为空");
        }
      },
    );
  }

  /// 发四柱闪断帖
  void _doVieOrder() async {
    try {
      BBSVie vie = await ApiBBSVie.bbsVieAdd(_siZhuData.toJson());
      if (vie != null) {
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        BalancePay(
          context,
          data: PayData(amt: _siZhuData.amt, b_type: b_bbs_vie, id: vie.id),
          onSuccess: () {
            CusRoute.push(
              context,
              UserVieDoingPage(
                postId: vie.id,
                backData: "发四柱闪断帖进入处理中页面，然后返回时携带数据",
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
      Log.error("四柱闪断帖下单出现异常：$e");
    }
  }

  /// 单个闪断帖标准组件
  Widget _priceItem(num val, int select) {
    bool checked = _select == select;
    return InkWell(
      onTap: () {
        if (_select != select) _select = select;
        // 获取当前选择标准的详情
        PriceLevelRes selectPrice = _l.singleWhere(
          (e) => e.price == val,
          orElse: () => null,
        );
        Log.info("当前的闪断金标准：${selectPrice.toJson()}");
        _siZhuData.amt = val;
        _siZhuData.level_id = selectPrice.price_level_id;
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
