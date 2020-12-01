import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/master/cus_fivestar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/19 10:29
// usage ：自定义用户评价组件
// ------------------------------------------------------

class UserComment extends StatelessWidget {
  final String url;
  final String title; // 用户名
  final Color titleColor;
  final String subtitle;
  final String type; // 评论人询问大师的服务类型
  final String created_at; // 评论时间
  final bool svip;

  const UserComment({
    this.url: "",
    this.title: "杨幂",
    this.titleColor: t_gray,
    this.subtitle,
    this.type: "普通提问",
    this.created_at: "2020-08-19 11:18:24",
    this.svip: false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
//      padding: EdgeInsets.all(Adapt.px(10)),
      padding: EdgeInsets.only(
          left: Adapt.px(15), right: Adapt.px(15), top: Adapt.px(15)),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CusAvatar(url: url, size: 50, borderRadius: 100),
              SizedBox(width: Adapt.px(20)),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          title, // 评论人名称
                          style: TextStyle(
                            color: titleColor,
                            fontSize: Adapt.px(28),
                          ),
                        ),
                        // 是否 svip
                        if (svip)
                          Padding(
                            padding: EdgeInsets.only(left: Adapt.px(10)),
                            child: Icon(
                              IconData(0xe60a, fontFamily: "AliIcon"),
                              color: Color(0xFFF2C24F),
                              size: Adapt.px(24),
                            ),
                          ),
                        Spacer(),
                        FiveStars(),
                      ],
                    ),
                    SizedBox(height: Adapt.px(10)),
                    SizedBox(
                      height: Adapt.px(120),
                      child: Text(
                        // 评论内容
                        subtitle ??
                            "如果在春夏时分求得，则及早趋吉避凶。羌笛在塞外频吹，曲调更令人伤感。它使异乡的游子，"
                                "醒悟起归家的日子，遥遥无期。这是一个悲凉的意境，羌笛在塞外频吹，曲调更令人伤感",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: t_gray, fontSize: Adapt.px(24)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // 服务类型
              Container(
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5C884),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(fontSize: Adapt.px(22)),
                ),
              ),
              Spacer(),
              // 评论时间
              Text(
                CusTime.ymdBar(created_at),
                style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
              )
            ],
          ),
          SizedBox(height: Adapt.px(15)),
          Divider(thickness: 1, height: 0, color: Colors.black54),
        ],
      ),
    );
  }
}
