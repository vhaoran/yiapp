import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/api/api_user.dart';

class RegUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("微聊IM系统--注册新用户"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          Adapt.px(20),
          Adapt.px(150),
          Adapt.px(50),
          Adapt.px(0),
        ),
        child: _RegUser(),
      ),
    );
  }
}

class _RegUser extends StatefulWidget {
  @override
  _RegUserState createState() => new _RegUserState();
}

class _RegUserState extends State<_RegUser> {
  // 用户名
  TextEditingController regUserCodeC = new TextEditingController();
  // 手机号
  TextEditingController regMobileC = new TextEditingController();
  // 验证码
  TextEditingController regCaptchaC = new TextEditingController();
  // 注册密码
  TextEditingController regPwdC = new TextEditingController();
  // 错误提示信息
  List<String> errtipsList = new List<String>(4);
  // 是否隐藏密码，默认隐藏
  bool isHidePwd = true;
  // 是否同意用户协议
  bool isUserAgreement = false;
  // 时间管理对象
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            // 注册文本的 Container
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '注册',
                style: TextStyle(
                    fontSize: Adapt.px(60), fontWeight: FontWeight.bold),
              ),
            ),
            // 用户名的 Container
            Container(
              padding: EdgeInsets.only(
                top: Adapt.px(60),
              ),
              child: TextField(
                // focusNode: usercodeFN,
                controller: regUserCodeC,
                // autofocus: true, // 自动获取焦点
                decoration: InputDecoration(
                    hintText: 'cpl201912108517',
                    suffixText: '微聊号',
                    errorText: errtipsList[0],
                    // 暂时找不到标准图标，先用 ☁️ 图标样式代替
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cloud_queue),
                        onPressed: () {
                          CusDialog.tip(context,
                              title: '微聊号介绍', subTitle: '数字、英文、或两者的混合');
                        })),
              ),
            ),
            // 手机号的 Container
            Container(
              child: TextField(
                controller: regMobileC,
                keyboardType: TextInputType.phone, // 默认打开数字键盘
                maxLength: 11,
                decoration: InputDecoration(
                  prefixText: '+86-',
                  prefixStyle: TextStyle(
                    fontSize: Adapt.px(46),
                    color: Color.fromRGBO(32, 32, 32, 1),
                  ),
                  hintText: '请输入手机号',
                  // errorText: errorMobileTips,
                  errorText: errtipsList[1],
                  counterText: '', // 控制是否显示最大字符数
                ),
              ),
            ),
            // 验证码的 Container
            Container(
              child: TextField(
                controller: regCaptchaC,
                keyboardType: TextInputType.phone,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: '验证码',
                  counterText: '',
                  errorText: errtipsList[2],
                  suffixIcon: Container(
                    width: 90,
                    // 这里如果用自适应则会出现 hintText 的文本不显示的问题
                    // height: ScreenUtil().setHeight(10),
                    alignment: Alignment.centerRight,
                    child: OutlineButton(
                      textColor: Color.fromRGBO(32, 32, 32, 1),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(32, 32, 32, 1), width: 0.5),
                      child: Text(
                        '获取验证码',
                        style: TextStyle(
                          fontSize: Adapt.px(30),
                        ),
                      ),
                      onPressed: getCaptchaID,
                    ),
                  ),
                ),
              ),
            ),
            // 密码的 Container
            Container(
              child: TextField(
                controller: regPwdC,
                maxLength: 20,
                obscureText: isHidePwd, // 是否隐藏输入的密码
                decoration: InputDecoration(
                  hintText: '密码长度 6-20 位****',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye,
                          color: isHidePwd ? Colors.grey : Colors.lightBlue),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            isHidePwd = !isHidePwd;
                          });
                        }
                      }),
                  errorText: errtipsList[3],
                ),
              ),
            ),
            // 注册按钮的 Container
            Container(
              padding: EdgeInsets.only(top: Adapt.px(20)),
              height: Adapt.px(120),
              width: Adapt.px(1000),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.black,
                // onPressed: isCanReg() ? submitRegUserdata : null,
                onPressed: this.regBtn,
                // 按钮禁用时的颜色
                disabledColor: Color.fromRGBO(235, 235, 235, 1),
                child: Text(
                  '注册',
                  style: TextStyle(
                    fontSize: Adapt.px(50),
                  ),
                ),
              ),
            ),
            // 用户协议的 Container
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: this.isUserAgreement,
                      onChanged: (bool value) {
                        setState(() {
                          this.isUserAgreement = value;
                        });
                      }),
                  Text.rich(TextSpan(
                    text: '我已阅读并同意聊天系统的',
                    style: userAgreementStyle(),
                    children: [
                      TextSpan(
                        text: '《用户协议》',
                        style: TextStyle(
                          // fontSize: 15,
                          fontSize: Adapt.px(40),
                          // color: Color.fromRGBO(32, 32, 32, 1),
                          color: Colors.lightBlue,
                        ),
                        // 手势（`gestures`）库的点击手势识别器（`TapGestureRecognizer`）类，识别点击手势。
                        // 识别（`recognizer`）属性，一个手势识别器，它将接收触及此文本范围的事件。
                        recognizer: TapGestureRecognizer()
                          ..onTap = userIsAgreement,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }

  /// 注册按钮事件
  void regBtn() async {
    // 验证用户名
    await verifyUserCode();
    // 验证手机号
    errtipsList[1] =
        RegExp(r"1[0-9]\d{9}$").hasMatch(regMobileC.text) ? null : '请输入正确的手机号';
    // 验证验证码(目前先做成仅验证输入的是不是6位数字）
    errtipsList[2] =
        RegExp(r"^\d{6}$").hasMatch(regCaptchaC.text) ? null : '输入的验证码不正确';
    // 验证密码
    errtipsList[3] = (regPwdC.text.length >= 6 && regPwdC.text.length <= 20) &&
            RegExp(r"^[A-Za-z]+$").hasMatch(regPwdC.text)
        ? null
        : '密码设置：6-20位字符大写字母、小写字母';
    setState(() {});

    if (errtipsList.every((value) => value == null)) {
      if (!isUserAgreement) {
        userIsAgreement();
      } else {
        submitRegUserdata();
      }
    } else {
      print('不满足注册的条件');
    }
  }

  /// 提交用户注册事件
  void submitRegUserdata() async {
    Random random = new Random();
    bool isSuccessReg;
    try {
      isSuccessReg = await ApiLogin.RegUser(
        {
          "user_code": regUserCodeC.text.trim(),
          "nick": "微聊新用户:${random.nextInt(1000)}号",
          "mobile": regMobileC.text.trim(),
          "pwd": regPwdC.text.trim(),
        },
      );
    } catch (e) {
      print('------用户提交注册数据发生错误------：$e');
    }
    if (isSuccessReg) {
      CusDialog.tip(context,
          title: "注册成功", onApproval: () => Navigator.pop(context));
      // 清空用户输入的内容
      regUserCodeC.text =
          regMobileC.text = regCaptchaC.text = regPwdC.text = "";
    }
    // 注册失败
    else {
      print("注册失败");
    }
  }

  /// 验证用户名的存在性
  void verifyUserCode() async {
    // 纯数字验证，纯字母验证，英文或者数字验证
    bool isRightUserCode = ((RegExp(r"^[0-9]*$").hasMatch(regUserCodeC.text) ||
            RegExp(r"^[A-Za-z]+$").hasMatch(regUserCodeC.text) ||
            RegExp(r"^[A-Za-z0-9]+$").hasMatch(regUserCodeC.text)) &&
        regUserCodeC.text.length > 0);
    if (isRightUserCode) {
      try {
        bool isUserCodeExisted = await ApiUser.userCodeExist(regUserCodeC.text);
        errtipsList[0] = isUserCodeExisted ? '微聊号已被使用请重新设置' : null;
      } catch (e) {
        print('------验证用户是否存在时发生错误------：$e');
      }
    } else {
      errtipsList[0] = "微聊号由数字、英文、或者两者的混合";
    }
    setState(() {});
  }

  /// 获取验证码
  void getCaptchaID() async {
    if (RegExp(r"1[0-9]\d{9}$").hasMatch(regMobileC.text)) {
      try {
        await ApiLogin.MobileCaptchaOfRegUser(regMobileC.text);
      } catch (e) {
        print('------验证验证码是否正确时发生错误------：$e');
      }
    }
  }

  /// 是否同意用户协议
  void userIsAgreement() {
    isUserAgreement
        ? CusDialog.tip(context, title: '这是用户协议、这是用户协议')
        : CusDialog.tip(context, title: '请同意并勾选用户协议');
  }

  /// 是否同意《用户协议》时，文本的样式
  TextStyle userAgreementStyle() {
    return TextStyle(
      fontSize: Adapt.px(40),
      // 同意：黑色，不同意：灰色
      color: this.isUserAgreement
          ? Color.fromRGBO(32, 32, 32, 1) // 同意：黑色
          : Color.fromRGBO(136, 136, 136, 1), // 不同意：灰色
    );
  }
}
