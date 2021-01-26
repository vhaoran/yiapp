import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/mine/my_orders/select_master_service_page.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午2:50
// usage ：大师通用封面，含头像、昵称、评价、一对一咨询等
// ------------------------------------------------------

class MasterComCover extends StatelessWidget {
  final BrokerMasterRes masterInfo;
  final dynamic yiOrderData;

  const MasterComCover({this.masterInfo, this.yiOrderData, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        MasterInfoPage(masterId: masterInfo.uid, yiOrderData: yiOrderData),
      ),
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
        CusAvatar(url: masterInfo.icon ?? "", size: 100, rate: 100),
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
                      masterInfo.nick,
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                    ),
                    Spacer(),
                    // 按钮
                    CusRaisedButton(
                      padding: EdgeInsets.symmetric(
                          vertical: S.h(5), horizontal: S.w(10)),
                      child: Text(
                        "一对一咨询",
                        style: TextStyle(fontSize: S.sp(14)),
                      ),
                      borderRadius: 50,
                      onPressed: () => CusRoute.push(
                        context,
                        SelectMasterServicePage(
                          masterId: masterInfo.master_id,
                          yiOrderData: yiOrderData,
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
                    masterInfo.brief,
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
