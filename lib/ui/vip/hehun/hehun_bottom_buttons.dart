import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_hehun_data.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/sizhu/sizhu_result.dart';
import 'package:yiapp/service/api/api_pai_pan.dart';
import 'package:yiapp/ui/vip/hehun/hehun_prize_page.dart';
import 'package:yiapp/ui/vip/hehun/hehun_vie_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午4:37
// usage ：合婚底部的按钮事件，含悬赏帖求测、闪断帖求测、大师亲测
// ------------------------------------------------------

class HeHunBottomButtons extends StatefulWidget {
  final SubmitHeHunData heHunData;

  HeHunBottomButtons({this.heHunData, Key key}) : super(key: key);

  @override
  _HeHunBottomButtonsState createState() => _HeHunBottomButtonsState();
}

class _HeHunBottomButtonsState extends State<HeHunBottomButtons> {
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
            CusRoute.push(context, HeHunPrizePage(heHunData: widget.heHunData))
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
            CusRoute.push(context, HeHunViePage(heHunData: widget.heHunData))
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
                yiOrderData: widget.heHunData,
              ),
            );
          }
        }
      },
    );
  }

  /// 四柱排盘
  Future<bool> _doSiZhuPaiPan() async {
    HeHunContent content = widget.heHunData.content;
    SpinKit.threeBounce(context);
    var mMale = {
      "is_male": true,
      "is_solar": content.is_solar_male,
      "year": content.year_male,
      "month": content.month_male,
      "day": content.day_male,
      "hour": content.hour_male,
      "minute": content.minute_male,
      "name": content.name_male,
    };
    var mFemale = {
      "is_male": false,
      "is_solar": content.is_solar_female,
      "year": content.year_female,
      "month": content.month_female,
      "day": content.day_female,
      "hour": content.hour_female,
      "minute": content.minute_female,
      "name": content.name_female,
    };
    try {
      SiZhuResult maleSiZhuRes = await ApiPaiPan.paiBaZi(mMale);
      SiZhuResult femaleSiZhuRes = await ApiPaiPan.paiBaZi(mFemale);
      if (maleSiZhuRes != null && femaleSiZhuRes != null) {
        Navigator.pop(context);
        content.male_sizhu_res = maleSiZhuRes;
        content.female_sizhu_res = femaleSiZhuRes;
        return true;
      }
      return false;
    } catch (e) {
      Log.error("合婚时四柱排盘出现异常：$e");
      return false;
    }
  }

  /// 验证提交的四柱数据
  bool get _approved {
    var content = widget.heHunData.content;
    // 验证通过
    if (content.year_male > 0 &&
        content.year_female > 0 &&
        content.name_male.trim().isNotEmpty &&
        content.name_female.trim().isNotEmpty &&
        widget.heHunData.title.isNotEmpty &&
        widget.heHunData.brief.isNotEmpty) {
      return true;
    }
    // 验证不通过
    else {
      String err;
      if (content.name_male.trim().isEmpty) {
        err = "请输入男方姓名";
      } else if (content.year_male <= 0) {
        err = "请选择男方出生日期";
      } else if (content.name_female.trim().isEmpty) {
        err = "请输入女方姓名";
      } else if (content.year_female <= 0) {
        err = "请选择女方出生日期";
      } else if (widget.heHunData.title.isEmpty) {
        err = "请输入标题";
      } else if (widget.heHunData.brief.isEmpty) {
        err = "请输入摘要";
      }
      CusToast.toast(context, text: err);
      return false;
    }
  }
}
