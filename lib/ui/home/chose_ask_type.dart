import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/const/const_int.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'package:yiapp/ui/question/ask_question/ask_main_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/22 16:45
// usage ：选择问命类型
// ------------------------------------------------------

class ChoseAskType extends StatelessWidget {
  bool isMid; // 是否中间发布提问按钮

  ChoseAskType({this.isMid: false, Key key}) : super(key: key);

  // 提问类型
  final List<String> _queTypes = ["六爻", "四柱", "合婚", "其他", "取消"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(context: context, child: _typeDialog(context)),
      child: Image.asset('assets/images/tai_chi.png',
          width: Adapt.px(140), height: Adapt.px(140)),
    );
  }

  /// 选择问命类型
  Widget _typeDialog(context) {
    return SimpleDialog(
      backgroundColor: tipBg,
      title: Center(child: Text('请选择一个您想咨询的类型')),
      titlePadding: EdgeInsets.all(24),
      contentPadding: EdgeInsets.all(0),
      children: List.generate(
        _queTypes.length,
        (i) => Column(
          children: <Widget>[
            Divider(height: 1),
            Container(
              width: double.infinity,
              child: FlatButton(
                child: CusText(_queTypes[i], Colors.black, 30),
                onPressed: () => _type(context, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _type(context, int i) {
    switch (i) {
      case 0: // 六爻
        CusRoute.pushReplacement(context, LiuYaoPage());
        break;
      case 1: // 四柱
        CusRoute.pushReplacement(
          context,
          AskQuestionPage(content_type: post_sizhu, barName: "四柱"),
        );
        break;
      case 2: // 合婚
        CusRoute.pushReplacement(
          context,
          AskQuestionPage(content_type: post_hehun, barName: "合婚"),
        );
        break;
      case 3: // 其他
        CusRoute.pushReplacement(
            context, AskQuestionPage(content_type: 0, barName: "其他"));
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }
}
