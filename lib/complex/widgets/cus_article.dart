import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_button.dart';
import 'package:yiapp/complex/widgets/cus_square_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 15:04
// usage ：自定义文章组件（左侧一张图片，右侧有文章主题、主要内容、一个可选按钮）
// ------------------------------------------------------

class CusArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(">>>点了文章");
      },
      child: Container(
        color: primary,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            CusSquareAvatar(url: "", size: 70, borderRadius: 10),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "纳音五行的推导过程",
                          style: TextStyle(
                            fontSize: Adapt.px(30),
                            color: t_gray,
                          ),
                        ),
                        Spacer(),
                        CusRaisedBtn(
                          bgColor: t_primary,
                          textColor: Colors.black,
                          fontSize: 24,
                          text: "开始测试",
                          minWidth: 70,
                          borderRadius: 10,
                          height: 10,
                          onPressed: () {
                            print(">>>开始测试");
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "中国人历来讲究图吉利、喜庆，特别是挑选结婚的吉日，家住上海三林镇李大妈的儿子"
                    "今年要结婚，为了给儿子挑选一个“良辰吉日为了给儿子挑选一个“良辰吉日",
                    style: TextStyle(
                      color: t_primary,
                      fontSize: Adapt.px(24),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
