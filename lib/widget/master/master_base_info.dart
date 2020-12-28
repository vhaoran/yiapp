import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/mine/my_orders/select_master_item.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 10:10
// usage ：大师封面，显示大师的基本资料（含头像、名称、在/离线状态、个签）
// ------------------------------------------------------

class MasterCover extends StatelessWidget {
  final BrokerMasterRes info;
  final VoidCallback onPressed;

  const MasterCover({this.info, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CusRoute.push(context, MasterInfoPage(master_id: info.uid)),
      child: Container(
        color: primary,
        padding: EdgeInsets.all(S.w(9)),
        child: _row(context),
      ),
    );
  }

  Widget _row(context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 大师头像
        CusAvatar(url: info.icon, size: 100, rate: 100),
        SizedBox(width: S.w(10)),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 大师昵称
                    Text(
                      info.nick,
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                    ),
                    Spacer(),
                    // 按钮
                    SizedBox(
                      height: S.h(22),
                      child: CusRaisedButton(
                        child: Text("一对一咨询"),
                        borderRadius: 50,
                        onPressed: () => CusRoute.push(
                          context,
                          SelectMasterItem(master_id: info.master_id),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: S.h(2)),
                  child: Text(
                    "在线",
                    style: TextStyle(color: Colors.green, fontSize: S.sp(13)),
                  ),
                ),
                // 副标题
                SizedBox(
                  // 这里固定高度是因为 subtitle 内容多少不一时，主副标题跟随着动
                  height: S.h(55),
                  child: Text(
                    info.brief,
                    style: TextStyle(color: t_gray, fontSize: Adapt.px(26)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
