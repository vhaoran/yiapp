import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_hehun_data.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/ui/vip/yiorder/meet_master_detail_page.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/master-cate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 15:04
// usage ：大师服务项目组件
// ------------------------------------------------------

typedef FnMasterCate = Function(MasterCate m);

class ServiceItem extends StatefulWidget {
  final cate; // [MasterCate] 或者 [BrokerMasterCate]
  final bool isSelf;
  final dynamic yiOrderData;
  final FnMasterCate onRm; // 移除服务事件
  final FnMasterCate onChange; // 修改服务事件
  final VoidCallback onTap; // 点击文章事件

  const ServiceItem({
    this.cate,
    this.isSelf: false,
    this.yiOrderData,
    this.onRm,
    this.onChange,
    this.onTap,
    Key key,
  }) : super(key: key);

  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      margin: EdgeInsets.symmetric(vertical: S.h(0.5)),
      child: widget.isSelf
          ? CupertinoLeftScroll(
              closeTag: LeftScrollCloseTag("MasterCate"),
              key: Key(widget.cate.id.toString()),
              onTap: widget.onTap,
              child: _item(),
              buttons: <Widget>[
                LeftScrollItem(
                  text: "删除",
                  textColor: Colors.white,
                  color: Colors.red,
                  onTap: () => widget.onRm(widget.cate),
                ),
              ],
            )
          : _item(),
    );
  }

  Widget _item() {
    return Container(
      color: primary,
      padding: EdgeInsets.symmetric(horizontal: S.w(5), vertical: S.h(5)),
      constraints: BoxConstraints(maxHeight: S.h(110)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _leftIcon(), // 左侧图标
          SizedBox(width: S.w(10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _nameAndCh(), // 服务名称和修改服务按钮
                SizedBox(height: S.h(5)),
                Text(
                  widget.cate.comment, // 项目介绍
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: CusText(
                      "${widget.cate.price}元宝/次", Color(0xFFD0662A), 26),
                ), // 服务价格
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 服务名称和修改服务按钮
  Widget _nameAndCh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.cate.yi_cate_name, // 服务名称
          style: TextStyle(color: t_gray, fontSize: S.sp(16)),
        ),
        Spacer(),
        if (widget.isSelf)
          CusRaisedButton(
            padding:
                EdgeInsets.symmetric(horizontal: S.w(12), vertical: S.h(6)),
            child: Text("修改服务",
                style: TextStyle(color: Colors.white, fontSize: S.sp(15))),
            onPressed: () => widget.onChange(widget.cate),
            borderRadius: 50,
          ),
        if (!widget.isSelf)
          CusRaisedButton(
            padding:
                EdgeInsets.symmetric(horizontal: S.w(12), vertical: S.h(6)),
            child: Text("立即测算",
                style: TextStyle(color: Colors.white, fontSize: S.sp(15))),
            onPressed: () async {
//              String str = await KV.getStr(kv_order);
//              // 直接点的一对一咨询
//              if (str == null) {
//                CusRoute.push(context, TalkAboutMaster(data: widget.cate));
//              }
//              // 点击四柱六爻合婚后，选择大师一对一咨询
//              else {
//                CusRoute.push(context, MeetMasterPage(cate: widget.cate));
//              }
              if (widget.yiOrderData != null) {
                CusRoute.push(
                  context,
                  MeetMasterDetailPage(
                    cate: widget.cate,
                    yiOrderData: widget.yiOrderData,
                  ),
                ).then((value) {
                  if (value != null) {
                    Navigator.of(context).pop("");
                  }
                });
              }
            },
            borderRadius: 50,
          ),
      ],
    );
  }

  /// 左侧图标(要改成根据服务类型显示图标)
  Widget _leftIcon() {
    return Container(
      height: Adapt.px(120),
      width: Adapt.px(120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: fif_primary,
      ),
      child: Icon(FontAwesomeIcons.fire,
          color: Colors.white70, size: Adapt.px(80)),
    );
  }
}
