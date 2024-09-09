/*
 * @Author: your name
 * @Date: 2021-12-08 14:44:46
 * @LastEditTime: 2021-12-08 15:05:34
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /CarBlueTooth/lib/helper/config/android_back_desktop.dart
 */
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AndroidBackTop {
  //初始化通信管道-设置退出到手机桌面
  static const String CHANNEL = "android/back/desktop";
  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return Future.value(false);
  }
}
