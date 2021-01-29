import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/sizhu/sizhu_result.dart';
import 'package:yiapp/service/api/api_pai_pan.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_prize_page.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_vie_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午6:00
// usage ：四柱底部的按钮事件，含悬赏帖求测、闪断帖求测、大师亲测
// ------------------------------------------------------

class SiZhuBottomButtons extends StatefulWidget {
  final SubmitSiZhuData siZhuData;

  SiZhuBottomButtons({this.siZhuData, Key key}) : super(key: key);

  @override
  _SiZhuBottomButtonsState createState() => _SiZhuBottomButtonsState();
}

class _SiZhuBottomButtonsState extends State<SiZhuBottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _prizeButtonWt()), // 悬赏帖求测
        Expanded(child: _vieButtonWt()), // 闪断帖求测
        Expanded(child: _yiOrderButtonWt()), // 大师亲测
      ],
    );
  }

  /// 悬赏帖求测
  Widget _prizeButtonWt() {
    return CusRaisedButton(
      child: Text("悬赏帖求测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFE96C62),
      onPressed: () async {
        if (_approved) {
          if (await _doSiZhuPaiPan()) {
            CusRoute.push(context, SiZhuPrizePage(siZhuData: widget.siZhuData))
                .then((value) {
              if (value != null) Navigator.pop(context);
            });
          }
        }
      },
    );
  }

  /// 闪断帖求测
  Widget _vieButtonWt() {
    return CusRaisedButton(
      child: Text("闪断帖求测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFED9951),
      onPressed: () async {
        if (_approved) {
          if (await _doSiZhuPaiPan()) {
            CusRoute.push(context, SiZhuViePage(siZhuData: widget.siZhuData))
                .then((value) {
              if (value != null) Navigator.pop(context);
            });
          }
        }
      },
    );
  }

  /// 大师亲测
  Widget _yiOrderButtonWt() {
    return CusRaisedButton(
      child: Text("大师亲测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFE8493E),
      onPressed: () async {
        if (_approved) {
          if (await _doSiZhuPaiPan()) {
            CusRoute.push(
              context,
              BrokerMasterListPage(
                showLeading: true,
                yiOrderData: widget.siZhuData,
              ),
            );
          }
        }
      },
    );
  }

  /// 验证提交的四柱数据
  bool get _approved {
    var content = widget.siZhuData.content;
    // 验证通过
    if (content.year > 0 &&
        widget.siZhuData.title.isNotEmpty &&
        widget.siZhuData.brief.isNotEmpty) {
      return true;
    }
    // 验证不通过
    else {
      String err;
      if (content.year <= 0)
        err = "未选择日期";
      else if (widget.siZhuData.title.isEmpty) {
        err = "请输入标题";
      } else if (widget.siZhuData.brief.isEmpty) {
        err = "请输入摘要";
      }
      CusToast.toast(context, text: err);
      return false;
    }
  }

  /// 四柱排盘
  Future<bool> _doSiZhuPaiPan() async {
    SiZhuContent content = widget.siZhuData.content;
    SpinKit.threeBounce(context);
    var m = {
      "is_male": content.is_male,
      "is_solar": content.is_solar,
      "year": content.year,
      "month": content.month,
      "day": content.day,
      "hour": content.hour,
      "minute": content.minute,
      "name": content.name,
    };
    try {
      SiZhuResult siZhuRes = await ApiPaiPan.paiBaZi(m);
      if (siZhuRes != null) {
        Navigator.pop(context);
        content.sizhu_res = siZhuRes;
        return true;
      }
      return false;
    } catch (e) {
      Log.error("四柱排盘出现异常：$e");
      return false;
    }
  }
}
