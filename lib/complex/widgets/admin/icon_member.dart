import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

typedef FnIconTap = void Function(int uid);
typedef FnCheckChanged = void Function(int uid, bool checked);

class IconMember extends StatefulWidget {
  final int uid;
  final String nick;
  final String url;
  final bool showCheckBox;
  final bool horizontal; // 默认横向显示
  final bool isManager; // 管理员
  final bool isOwner; // 是創建者
  final FnIconTap onIconTap; // 按下图标后的回調
  final FnCheckChanged onCheckStateChanged; // 点击switch时的回调
  final bool disable; // 是否禁用按钮
  bool checked;

  IconMember({
    this.uid = 0,
    this.nick = "机器猫",
    this.url = "",
    this.isManager = false,
    this.isOwner = false,
    this.showCheckBox = false,
    this.horizontal = true,
    this.onCheckStateChanged,
    this.onIconTap,
    this.checked = false,
    this.disable = false,
    Key key,
  }) : super(key: key);

  @override
  _IconMemberState createState() => _IconMemberState();
}

class _IconMemberState extends State<IconMember> {
  @override
  Widget build(BuildContext context) {
    return widget.horizontal ? _horizontal() : _vertical();
  }

  /// 水平显示布局
  Widget _horizontal() {
    return Card(
      margin: EdgeInsets.only(bottom: 3),
//      color: widget.disable ? CusColors.systemGrey(context) : Colors.blueGrey,
      color: CusColors.systemGrey(context),
      elevation: 1,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: CusAvatar(url: widget.url ?? "", size: 60),
            ),
            CusText("${widget.nick}", Colors.white, 28),
          ],
        ),
        leading: widget.showCheckBox
            ? ClipOval(
                child: Checkbox(
                  value: widget.checked,
                  onChanged: widget.disable
                      ? null
                      : (e) {
                          setState(() {
                            this.widget.checked = e;
                          });
                          if (widget.onCheckStateChanged != null) {
                            widget.onCheckStateChanged(widget.uid, e);
                          }
                        },
                ),
              )
            : null,
        onTap: widget.disable
            ? null
            : () {
                if (widget.onIconTap != null) {
                  widget.onIconTap(widget.uid ?? 0);
                  return;
                }
                setState(() {
                  this.widget.checked = !this.widget.checked;
                });
                if (widget.onCheckStateChanged != null) {
                  widget.onCheckStateChanged(widget.uid, widget.checked);
                }
              },
        contentPadding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
      ),
    );
  }

  /// 垂直布局，适用已选择的成员显示
  Widget _vertical() {
    return Column(
      children: [
        if (widget.showCheckBox)
          Checkbox(
              value: widget.checked,
              onChanged: (e) {
                setState(() {
                  this.widget.checked = e;
                });
                if (widget.onCheckStateChanged != null) {
                  widget.onCheckStateChanged(widget.uid, e);
                }
              }),
        InkWell(
            onTap: () {
              if (widget.onIconTap != null) {
                widget.onIconTap(widget.uid ?? 0);
                return;
              }
              //else
              setState(() {
                this.widget.checked = !this.widget.checked;
              });
              if (widget.onCheckStateChanged != null) {
                widget.onCheckStateChanged(widget.uid, widget.checked);
              }
            },
            child: Column(
              children: <Widget>[
                CusAvatar(url: widget.url ?? "", size: 60),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  child: CusText("${widget.nick}", t_gray, 26),
                ),
              ],
            ))
      ],
    );
  }
}
