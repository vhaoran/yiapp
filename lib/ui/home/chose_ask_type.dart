import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'package:yiapp/ui/question/reward_post/ask_question.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/22 16:45
// usage ：选择问命类型
// ------------------------------------------------------

class ChoseAskType extends StatelessWidget {
  bool isMid;
  ChoseAskType({this.isMid, Key key}) : super(key: key);

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
        CusRoutes.pushReplacement(context, LiuYaoPage());
        break;
      case 1: // 四柱
        CusRoutes.pushReplacement(
          context,
          AskQuestionPage(content_type: 2),
        );
        break;
      case 2: // 合婚
        CusRoutes.pushReplacement(
          context,
          AskQuestionPage(content_type: 3),
        );
        break;
      case 3: // 其他
        CusRoutes.pushReplacement(context, AskQuestionPage(content_type: 0));
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }
}
