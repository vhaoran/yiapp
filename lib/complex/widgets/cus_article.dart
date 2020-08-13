import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_button.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 15:04
// usage ：自定义文章组件（左侧一张图片，右侧有文章主题、主要内容、一个可选按钮）
// ------------------------------------------------------

class CusArticle extends StatelessWidget {
  final int maxLines; // 最多显示多少行
  final double size; // 文章图片尺寸
  final double titleSize; // 主标题文字大小
  final double subSize; // 副标题文字大小
  final double padding; // EdgeInsets.all
  final double margin;
  final double borderRadius; // 图片圆角
  final double spaceWidth; // 图片和右侧标题间隔
  final double spaceHeight; // 主副标题间隔
  final double btnFontSize; // 按钮字体大小
  final double btnRadius; // 按钮圆角
  final String title; // 主标题
  final String subtitle; // 副标题
  final String url; // 图片链接
  final String btnName; // 按钮名称
  final Color backGroundColor;
  final Color titleColor; // 主标题文字颜色
  final Color subColor; // 副标题文字颜色
  final Color btnBgColor; // 按钮背景色
  final Color btnFontColor; // 按钮文字颜色
  final Color shadowColor; // Card 底部阴影颜色
  final bool showBtn; // 是否显示按钮
  final VoidCallback onTap; // 点击文章事件
  final VoidCallback onPressed; // 按钮事件

  const CusArticle({
    this.maxLines: 3,
    this.size: 90,
    this.titleSize: 32,
    this.subSize: 24,
    this.padding: 18,
    this.margin: 0.4,
    this.borderRadius: 10,
    this.spaceWidth: 20,
    this.spaceHeight: 20,
    this.btnFontSize: 48,
    this.btnRadius: 50,
    this.title: "文章标题",
    this.subtitle,
    this.url: "",
    this.btnName: "开始测试",
    this.backGroundColor: primary,
    this.titleColor: t_gray,
    this.subColor: t_primary,
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
        onTap: onTap ?? () => print(">>>点了文章《$title》"),
        child: Container(
          color: backGroundColor,
          padding: EdgeInsets.all(Adapt.px(padding)),
          child: Row(
            children: <Widget>[
              // 文章图片
              CusAvatar(url: url, size: size, borderRadius: borderRadius),
              SizedBox(width: Adapt.px(spaceWidth)),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: Adapt.px(50),
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
                            CusRaisedBtn(
                              bgColor: btnBgColor,
                              textColor: btnFontColor,
                              fontSize: Adapt.px(btnFontSize),
                              text: btnName,
                              borderRadius: btnRadius,
                              pdHor: 20,
                              pdVer: 2,
                              onPressed:
                                  onPressed ?? () => print(">>>点了 $title 上的按钮"),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: Adapt.px(spaceHeight)),
                    // 副标题
                    Text(
                      subtitle ??
                          "中国人历来讲究图吉利、喜庆，特别是挑选结婚的吉日，家住上海三林镇李大妈的儿子今年要结婚，"
                              "为了给儿子挑选一个“良辰吉日”，李大妈可是没少费工夫。",
                      style: TextStyle(
                          color: subColor, fontSize: Adapt.px(subSize)),
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
