import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/ui/master/master_homepage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 10:10
// usage ：大师基本资料（含头像、名称、在/离线状态、个签）
// ------------------------------------------------------

class MasterCover extends StatelessWidget {
  final MasterInfo info;
  final VoidCallback onPressed;

  const MasterCover({this.info, this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => CusRoutes.push(
              context,
              MasterHomePage(master_id: info.uid),
            ),
        child: Container(
          color: primary,
          padding: EdgeInsets.all(Adapt.px(18)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 大师头像
              CusAvatar(url: info.icon, size: 100, rate: 100),
              SizedBox(width: Adapt.px(20)),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: Adapt.px(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // 主标题
                            CusText(info.nick, t_gray, 32),
                            Spacer(),
                            // 按钮
                            CusRaisedBtn(
                              text: "约聊大师",
                              backgroundColor: Color(0xFFDF5A54),
                              fontSize: 26,
                              pdVer: 5,
                              pdHor: 20,
                              borderRadius: 100,
                              onPressed: onPressed ??
                                  () => print(">>> 点了 ${info.nick} 上的按钮"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Adapt.px(4)),
                        child: Text(
                          "状态",
                          style: TextStyle(
                              color: Colors.yellow, fontSize: Adapt.px(24)),
                        ),
                      ),
                      // 副标题
                      SizedBox(
                        // 这里固定高度是因为 subtitle 内容多少不一时，主副标题跟随着动
                        height: Adapt.px(110),
                        child: Text(
                          info.brief,
                          style:
                              TextStyle(color: t_gray, fontSize: Adapt.px(26)),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
//      child: Card(
//        shadowColor: Colors.white,
//        margin: EdgeInsets.all(Adapt.px(0.4)),
//        child: Container(
//          color: primary,
//          padding: EdgeInsets.all(Adapt.px(18)),
//          child: Row(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              // 大师头像
//              CusAvatar(url: info.icon, size: 100, rate: 100),
//              SizedBox(width: Adapt.px(20)),
//              Expanded(
//                child: Container(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      SizedBox(
//                        height: Adapt.px(50),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            // 主标题
//                            CusText(info.nick, t_gray, 32),
//                            Spacer(),
//                            // 按钮
//                            CusRaisedBtn(
//                              text: "约聊大师",
//                              backgroundColor: Color(0xFFDF5A54),
//                              fontSize: 26,
//                              pdVer: 5,
//                              pdHor: 20,
//                              borderRadius: 100,
//                              onPressed: onPressed ??
//                                  () => print(">>> 点了 ${info.nick} 上的按钮"),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.symmetric(vertical: Adapt.px(4)),
//                        child: Text(
//                          "状态",
//                          style: TextStyle(
//                              color: Colors.yellow, fontSize: Adapt.px(24)),
//                        ),
//                      ),
//                      // 副标题
//                      SizedBox(
//                        // 这里固定高度是因为 subtitle 内容多少不一时，主副标题跟随着动
//                        height: Adapt.px(110),
//                        child: Text(
//                          info.brief,
//                          style:
//                              TextStyle(color: t_gray, fontSize: Adapt.px(26)),
//                          maxLines: 3,
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
        );
  }
}
