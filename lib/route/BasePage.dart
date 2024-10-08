/*
 * @Author: your name
 * @Date: 2021-05-11 00:44:39
 * @LastEditTime: 2022-08-30 23:18:38
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/route/jkPage.dart
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/helper/config/text_style.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/notifier/changeNotifier.dart';
import 'package:flutter_app/pages/bt/BTPage.dart';
import 'package:flutter_app/pages/caraux/CarAuxPage.dart';
import 'package:flutter_app/pages/connect/ConnectPage.dart';
import 'package:flutter_app/pages/home/HomePage.dart';
import 'package:flutter_app/pages/play/PlayPage.dart';
import 'package:flutter_app/pages/radio/RadioPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui show window;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

abstract class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => getState();

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> with RouteAware {
  Widget? navigationBar; //navigationBar

  PreferredSizeWidget? appBarWidget; //body

  Widget? endDrawerWidget; //

  double width = 0;
  double height = 0;
  double top = 0;
  double bottom = 0;
  double left = 0;
  double right = 0;
  double px = 0;
  bool isPortrait = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  String pageName() {
    return ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: endDrawerWidget, //右滑菜单栏
      body: Stack(
        children: [
          RotatedBox(
            quarterTurns: ScreenUtil().orientation == Orientation.portrait ? 0 : 1, // 旋转90度
            child: Image.asset(
              JKImage.icon_bg,
              fit: BoxFit.cover,
              width: 375.w,
              height: 822.w,
            ),
          ),
          SafeArea(child: buildContentView()),
        ],
      ),
    );
  }

  Widget buildContentView() {
    return ScreenUtil().orientation == Orientation.portrait
        ? buildVerticalLayout()
        : buildHorizontalLayout();
  }

  Widget buildTopView(String headTitle) {
    double padding = ScreenUtil().orientation == Orientation.portrait ? 10 : 20;
    if (JKSize.instance.left > 0 && Platform.isIOS) {
      padding = 0;
    }
    return Container(
      height: (Platform.isIOS || JKSize.instance.isPortrait) ? 50 : 25,
      alignment: ScreenUtil().orientation == Orientation.portrait
          ? Alignment.center
          : Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              printLog("object");
              Get.back();
            },
            child: Container(
              height: 30.r,
              child: Row(
                children: [
                  Image.asset(
                    JKImage.icon_back,
                    height: 25,
                    width: 25,
                    fit: BoxFit.fitHeight,
                  ),
                  Text(
                    headTitle,
                    style: styleSize_17Height_24.copyWith(
                      color: Colors.white,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildConnectView(),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   this.setParameters();
  //   return Scaffold(
  //       // appBar: appBarWidget!, //顶部导航栏
  //       endDrawer: endDrawerWidget, //右滑菜单栏
  //       body: WillPopScope(
  //         child: Stack(
  //           children: [
  //             Container(
  //               width: JKSize.instance.width,
  //               height: JKSize.instance.height,
  //               color: Colors.black,
  //             ),
  //             Container(
  //               child: Image.asset(
  //                 JKImage.icon_bg,
  //                 fit: this.isPortrait ? BoxFit.cover : BoxFit.fill,
  //                 width: this.width,
  //                 height: this.height,
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.only(
  //                   top: this.top,
  //                   bottom: this.bottom,
  //                   left: this.left,
  //                   right: this.right),
  //               child: this.isPortrait
  //                   ? this.buildVerticalLayout()
  //                   : this.buildHorizontalLayout(),
  //             )
  //           ],
  //         ),
  //         onWillPop: () async {
  //           if (context.widget is RadioPage ||
  //               context.widget is BtPage ||
  //               context.widget is CarAuxPage ||
  //               context.widget is PlayPage) {
  //             goHome();
  //             return false;
  //           } else if (context.widget is HomePage) {
  //             if (Platform.isAndroid) {
  //               //安卓平台退出之前，断开蓝牙
  //               JKBluetooth.disConnect().then((value) {
  //                 JKBluetooth.instance.device = null;
  //               });
  //             }
  //           }
  //           return true;
  //         },
  //       ));
  // }

  setParameters() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    this.isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    this.width = mediaQuery.size.width;
    this.height = mediaQuery.size.height;
    this.top = mediaQuery.padding.top;
    this.bottom = mediaQuery.padding.bottom;
    this.px = (this.isPortrait ? this.width : this.height) / 375.0;

    JKSize.instance.width = mediaQuery.size.width;
    JKSize.instance.height = mediaQuery.size.height;
    JKSize.instance.isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    JKSize.instance.left = mediaQuery.padding.left;
    JKSize.instance.right = mediaQuery.padding.right;
    JKSize.instance.px =
        (JKSize.instance.isPortrait ? JKSize.instance.width : JKSize.instance.height) / 375.0;
    JKSize.instance.mRatio = MediaQuery.of(context).devicePixelRatio;
  }

  initData() {}

  buildVerticalLayout() {}

  buildHorizontalLayout() {}

  Widget buildConnectView() {
    return ChangeNotifierProvider.value(
      value: ConnectNotifier.instance,
      builder: (context, child) {
        bool isConnected = context.watch<ConnectNotifier>().isConnected;
        return Container(
          width: 100.w,
          child: InkWell(
            onTap: () {
              if (this.widget is HomePage) {
                Get.to(ConnectPage());
              } else {
                if (isConnected) {
                  Fluttertoast.showToast(msg: S.current.Connected);
                } else {
                  Fluttertoast.showToast(msg: S.current.DisConnected);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: isConnected,
                    child: Image.asset(
                      JKImage.icon_true,
                      height: 15,
                      width: 20,
                    ),
                  ),
                  Text(
                    isConnected ? S.current.Connected : S.current.Connect,
                    style: styleSize_12Height_17.copyWith(
                      fontFamily: 'Mont',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  push(Widget page) {
    Get.to(() => page);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => page),
    // ).then((value) {
    //   if (value != null && value) {
    //     this.setState(() {});
    //   }
    // });
  }

  pushReplacement(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  goHome() {
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  back() {
    Get.back();
    // if (context.widget is RadioPage ||
    //     context.widget is BtPage ||
    //     context.widget is CarAuxPage ||
    //     context.widget is PlayPage) {
    //   goHome();
    // } else {
    //   Navigator.pop(context);
    // }
  }

  Widget initTopView(String headTitle) {
    return Container(
      height: 50,
      alignment: JKSize.instance.isPortrait ? Alignment.center : Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: JKSize.instance.isPortrait ? 10 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              this.back();
            },
            child: Row(
              children: [
                Image.asset(
                  JKImage.icon_back,
                  height: 25,
                  width: 25,
                  fit: BoxFit.fitHeight,
                ),
                Text(
                  headTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (JKBluetooth.isConnect()) {
                Fluttertoast.showToast(msg: S.current.Connect);
              } else {
                Fluttertoast.showToast(msg: S.current.DisConnected);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Offstage(
                  offstage: !JKBluetooth.isConnect(),
                  child: Image.asset(
                    JKImage.icon_true,
                    height: 15,
                    width: 20,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(
                  S.current.Connect,
                  style: TextStyle(
                    fontFamily: 'Mont',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 添加监听订阅
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    //重新回到该页面会走该方法
    this.initData();
    setState(() {});
  }
}
