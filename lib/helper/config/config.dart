/*
 * @Author: kashjack
 * @Date: 2021-04-22 15:11:28
 * @LastEditTime: 2022-10-25 22:09:40
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /MTCouple/lib/helper/config/config.dart
 */

import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

class GlobalConfig {
  static bool isDebug = true; //是否是调试模式
  static bool dark = false;
}

class JKColor {
  static Color main = Color(0xFFF01140);
  static Color ff767676 = Color(0xFF767676);
}

const bool kReleaseMode =
    bool.fromEnvironment('dart.vm.product', defaultValue: false);
const bool kProfileMode =
    bool.fromEnvironment('dart.vm.profile', defaultValue: false);
const bool kDebugMode = !kReleaseMode && !kProfileMode;
const bool kIsWeb = identical(0, 0.0);

void printLog(Object object) {
  if (kDebugMode) {
    final chain = Chain.forTrace(StackTrace.current);
    final frames = chain.toTrace().frames;
    final frame = frames[1];
    if (object.toString().contains("蓝牙")) {
      print(DateTime.now().toString() + object.toString());
    }
    print('******************************');
    print('${frame.uri} -- ${frame.member} -- ${frame.line}');
    print(DateTime.now());
    print(object);
    print('******************************');
  } else {
    print(DateTime.now().toString() + object.toString());
  }
}

extension intToList on int {
  List<int> toList() {
    int mod = this;
    int index1 = mod ~/ 128;
    mod %= 128;
    int index2 = mod ~/ 64;
    mod %= 64;
    int index3 = mod ~/ 32;
    mod %= 32;
    int index4 = mod ~/ 16;
    mod %= 16;
    int index5 = mod ~/ 8;
    mod %= 8;
    int index6 = mod ~/ 4;
    mod %= 4;
    int index7 = mod ~/ 2;
    int index8 = mod % 2;
    return [
      index1,
      index2,
      index3,
      index4,
      index5,
      index6,
      index7,
      index8,
    ];
  }
}

extension listToInt on List<int> {
  int toInt() {
    if (this.length < 8) {
      return 0;
    }
    int sum = this[0] * 128;
    sum += this[1] * 64;
    sum += this[2] * 32;
    sum += this[3] * 16;
    sum += this[4] * 8;
    sum += this[5] * 4;
    sum += this[6] * 2;
    sum += this[7];
    return sum;
  }
}

extension intToTimeString on int {
  String toTimeString() {
    if (this >= 10) {
      return "$this";
    } else {
      return "0$this";
    }
  }
}

extension intListToAscii on List<int> {
  String toAscii() {
    List<int> list2 = [];
    for (int i = 0; i < this.length; i++) {
      if (i % 2 != 0) {
        if (this[i] == 0) {
          if (this[i - 1] != 0) {
            list2.add(this[i - 1]);
          }
        } else {
          list2.add(this[i] * 256 + this[i - 1]);
        }
      }
    }
    return String.fromCharCodes(list2);
  }
}
