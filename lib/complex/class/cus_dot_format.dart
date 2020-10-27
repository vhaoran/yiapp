import 'package:flutter/services.dart';
import 'dart:math' as math;

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/27 10:05
// usage ：限制 TextField 输入的小数点个数，默认为两位
// ------------------------------------------------------

class DotFormatter extends TextInputFormatter {
  final int decimalRange; // 保留小数位数

  DotFormatter({this.decimalRange = 2})
      : assert(decimalRange == null || decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 拿到输入后的字符
    String nValue = newValue.text;
    // 当前所选择的文字区域
    TextSelection nSelection = newValue.selection;
    // 匹配包含数字和小数点的字符(过滤)
    Pattern p = RegExp(r'(\d+\.?)|(\.?\d+)|(\.?)');
    nValue = p
        .allMatches(nValue)
        .map<String>((Match match) => match.group(0))
        .join();

    // 用匹配完的字符判断
    if (nValue.startsWith('.')) {
      // 如果小数点开头补个0
      nValue = '0.';
    } else if (nValue.contains('.')) {
      // 来证小数点位置
      if (nValue.substring(nValue.indexOf('.') + 1).length > decimalRange) {
        nValue = oldValue.text;
      } else {
        if (nValue.split('.').length > 2) {
          // 多个小数点，去掉后面的
          List<String> split = nValue.split('.');
          nValue = split[0] + '.' + split[1];
        }
      }
    }

    // 使光标定位到最后一个字符后面
    nSelection = newValue.selection.copyWith(
      baseOffset: math.min(nValue.length, nValue.length + 1),
      extentOffset: math.min(nValue.length, nValue.length + 1),
    );

    return TextEditingValue(
        text: nValue, selection: nSelection, composing: TextRange.empty);
  }
}
