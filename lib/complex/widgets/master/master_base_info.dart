import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 10:10
// usage ：大师基本资料（含头像、名称、在/离线状态、个签）
// ------------------------------------------------------

class MasterBaseInfo extends StatelessWidget {
  final int maxLines; // 最多显示多少行
  final String title; // 主标题
  final double titleSize;
  final Color titleColor;
  final String subtitle; // 副标题
  final double subSize;
  final Color subColor;
  final String midTitle; // 中间标题
  final double midSize;
  final Color midColor;
  final double imgSize; // 文章图片尺寸
  final double padding; // EdgeInsets.all
  final double margin;
  final double borderRadius; // 图片圆角
  final double spaceWidth; // 图片和右侧标题间隔
  final double spaceHeight; // 主副标题间隔
  final double btnFontSize; // 按钮字体大小
  final double btnRadius; // 按钮圆角
  final String url; // 图片链接
  final String btnName; // 按钮名称
  final String defaultImage; // 指定默认图片
  final Color backGroundColor;
  final Color btnBgColor; // 按钮背景色
  final Color btnFontColor; // 按钮文字颜色
  final Color shadowColor; // Card 底部阴影颜色
  final bool showBtn; // 是否显示按钮
  final VoidCallback onTap; // 点击文章事件
  final VoidCallback onPressed; // 按钮事件

  const MasterBaseInfo({
    this.maxLines: 3,
    this.title: "大师姓名",
    this.titleSize: 32,
    this.titleColor: Colors.white,
    this.subtitle,
    this.subSize: 26,
    this.subColor: t_gray,
    this.midTitle: "状态",
    this.midSize: 24,
    this.midColor: Colors.yellow,
    this.imgSize: 100,
    this.padding: 18,
    this.margin: 0.4,
    this.borderRadius: 10,
    this.spaceWidth: 20,
    this.spaceHeight: 4,
    this.btnFontSize: 48,
    this.btnRadius: 50,
    this.url: "",
    this.btnName: "立即约聊",
    this.defaultImage: "assets/images/avatar.jpg",
    this.backGroundColor: primary,
    this.btnBgColor: t_primary,
    this.btnFontColor: Colors.black,
    this.shadowColor: Colors.white,
    this.showBtn: true,
    this.onTap,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: shadowColor,
      margin: EdgeInsets.all(Adapt.px(margin)),
      child: InkWell(
        onTap: onTap ?? () => print(">>>点了《$title》"),
        child: Container(
          color: backGroundColor,
          padding: EdgeInsets.all(Adapt.px(padding)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 文章图片
              CusAvatar(
                url: url,
                size: imgSize,
                borderRadius: borderRadius,
                defaultImage: defaultImage,
              ),
              SizedBox(width: Adapt.px(spaceWidth)),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: Adapt.px(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // 主标题
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: Adapt.px(titleSize),
                                color: titleColor,
                              ),
                            ),
                            Spacer(),
                            // 按钮
                            if (showBtn)
                              CusYiBtn(
                                btnName: btnName,
                                onPressed: onPressed ??
                                    () => print(">>> 点了 $title 上的按钮"),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Adapt.px(spaceHeight)),
                        child: Text(
                          midTitle,
                          style: TextStyle(
                              color: midColor, fontSize: Adapt.px(midSize)),
                        ),
                      ),
                      // 副标题
                      SizedBox(
                        // 这里固定高度是因为 subtitle 内容多少不一时，主副标题跟随着动
                        height: Adapt.px(110),
                        child: Text(
                          subtitle ??
                              "中国人历来讲究图吉利、喜庆，特别是挑选结婚的吉日，家住上海三林镇李大妈的儿子今年要结婚，"
                                  "为了给儿子挑选一个“良辰吉日”，李大妈可是没少费工夫。",
                          style: TextStyle(
                              color: subColor, fontSize: Adapt.px(subSize)),
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
