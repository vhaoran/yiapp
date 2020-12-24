import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_color.dart';
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

class CusService extends StatefulWidget {
  final MasterCate m;
  final FnMasterCate onRm; // 移除服务事件
  final FnMasterCate onChange; // 修改服务事件
  final VoidCallback onTap; // 点击文章事件

  const CusService({
    this.m,
    this.onRm,
    this.onChange,
    this.onTap,
    Key key,
  }) : super(key: key);

  _CusServiceState createState() => _CusServiceState();
}

class _CusServiceState extends State<CusService> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      margin: EdgeInsets.symmetric(vertical: S.h(0.5)),
      child: CupertinoLeftScroll(
        closeTag: LeftScrollCloseTag("MasterCate"),
        key: Key(widget.m.id.toString()),
        onTap: widget.onTap,
        child: _item(),
        buttons: <Widget>[
          LeftScrollItem(
            text: "删除",
            textColor: Colors.white,
            color: Colors.red,
            onTap: () => widget.onRm(widget.m),
          ),
        ],
      ),
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
                  widget.m.comment, // 项目介绍
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child:
                      CusText("${widget.m.price}元宝/次", Color(0xFFD0662A), 26),
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
    return SizedBox(
      height: S.h(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.m.yi_cate_name, // 服务名称
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
          Spacer(),
          CusRaisedButton(
            child: Text("修改服务"),
            onPressed: () => widget.onChange(widget.m),
            borderRadius: 50,
          ),
        ],
      ),
    );
  }

  /// 左侧图标(要改成根据服务类型显示图标)
  Widget _leftIcon() {
    double size = Adapt.px(120);
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: fif_primary,
      ),
      child: Icon(
        FontAwesomeIcons.fire,
        color: Colors.white70,
        size: Adapt.px(80),
      ),
    );
  }
}
