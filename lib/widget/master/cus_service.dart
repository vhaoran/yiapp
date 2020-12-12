import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
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
      margin: EdgeInsets.all(Adapt.px(0.4)),
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
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _leftIcon(), // 左侧图标
          SizedBox(width: Adapt.px(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _nameAndCh(), // 服务名称和按钮
                SizedBox(height: Adapt.px(5)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
                  child: Text(
                    widget.m.comment, // 项目介绍
                    style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
      height: Adapt.px(Adapt.px(80)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CusText(widget.m.yi_cate_name, t_gray, 32), // 主标题
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
