/*
 * @Author: kashjack
 * @Date: 2021-05-09 22:32:28
 * @LastEditTime: 2022-04-07 13:56:40
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/helper/config/size.dart
 */

import 'dart:ui' as ui show window;
import 'package:flutter/material.dart';

class JKSize {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
  static JKSize instance = JKSize();
  double px = mediaQuery.size.width / 375.0;
  double width = mediaQuery.size.width;
  double height = mediaQuery.size.height;
  double right = mediaQuery.padding.right;
  double left = mediaQuery.padding.left;
  double top = mediaQuery.padding.top;
  double mRatio = 1;
  double bottom = mediaQuery.padding.bottom;
  bool isPortrait = mediaQuery.orientation == Orientation.portrait;
}

double px(double value) {
  return JKSize.instance.px * value;
}
