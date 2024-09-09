/*
 * @Author: kashjack
 * @Date: 2021-05-13 11:56:13
 * @LastEditTime: 2022-11-17 11:54:42
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/speaker/SpeakerPage.dart
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/alignment/AlignmentPage.dart';
import 'package:flutter_app/pages/set/widget/SettingView.dart';
import 'package:flutter_app/pages/set/eq/EQPage.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/pages/set/xover/XOverPage.dart';
import 'package:flutter_app/route/BasePage.dart';

class SpeakerPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _SpeakerPageState();
}

class _SpeakerPageState extends BaseWidgetState<SpeakerPage>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  Animation<double>? angleAnimation;

  bool isShow = false;
  double imageSize = px(40);

  void initData() {
    this.controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 360),
    );
    //animation第一种创建方式：
    this.offsetAnimation =
        Tween<Offset>(begin: Offset(270.0, 0.0), end: Offset(0.0, 0.0))
            .animate(controller!)
          ..addListener(() {
            setState(() {});
          });

    this.angleAnimation =
        Tween<double>(begin: 0, end: math.pi).animate(controller!)
          ..addListener(() {
            setState(() {});
          });

    JKBluetooth.instance.stateCallback = (value) {
      if (value == 'way') {
        setState(() {});
      }
    };
    JKSetting.instance.getWay();
  }

  Widget buildVerticalLayout() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            this.initTopView(S.current.SPEAKER_Settings),
            SizedBox(
              height: px(500),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      JKImage.icon_car,
                      height: px(450),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: px(500),
                      child: this._buildBtnView(),
                    ),
                  ),
                ],
              ),
            ),
            this._buildWayView(),
          ],
        ),
        this._buildSettingView(),
        this._buildSettingButton(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(
      children: [
        Column(
          children: [
            this.initTopView(S.current.SPEAKER_Settings),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Image.asset(
                              JKImage.icon_car,
                              height: px(500),
                            ),
                          ),
                        ),
                        Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              height: px(550),
                              child: this._buildBtnView(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  this._buildWayView(),
                ],
              ),
            ),
          ],
        ),
        this._buildSettingView(),
        this._buildSettingButton(),
      ],
    );
  }

  Widget _buildBtnView() {
    return JKSetting.instance.is2WAY
        ? Column(
            children: [
              SizedBox(height: px(100)),
              this._buildBottomMiddleView(S.current.Tweeter, () {
                JKSetting.instance.aisle = 1;
              }),
              SizedBox(height: px(60)),
              this._buildBottomMiddleView(S.current.Front, () {
                JKSetting.instance.aisle = 2;
              }),
              SizedBox(height: px(70)),
              this._buildTopMiddleView(S.current.Rear, () {
                JKSetting.instance.aisle = 3;
              }),
              SizedBox(height: px(70)),
              this._buildTopView(() {
                JKSetting.instance.aisle = 4;
              }),
            ],
          )
        : Column(
            children: [
              SizedBox(height: px(100)),
              this._buildBottomMiddleView(S.current.Tweeter, () {
                JKSetting.instance.aisle = 1;
              }),
              SizedBox(height: px(120)),
              this._buildTopMiddleView(S.current.MID_RANGE, () {
                JKSetting.instance.aisle = 2;
              }),
              SizedBox(height: px(120)),
              this._buildTopView(() {
                JKSetting.instance.aisle = 3;
              }),
            ],
          );
  }

  Widget _buildSettingView() {
    return Transform.translate(
      offset: Offset(
          this.offsetAnimation!.value.dx, this.offsetAnimation!.value.dy),
      child: Container(
        margin: EdgeInsets.only(right: 50),
        alignment: Alignment.centerRight,
        child: SettingView(
            selIndex: 4,
            selectTypeCallBack: (index) {
              this.controller!.reverse();
              this.isShow = false;
              if (index == 0) {
                this.pushReplacement(EQPage());
              } else if (index == 1) {
                this.pushReplacement(FabaPage());
              } else if (index == 2) {
                this.pushReplacement(AlignmentPage());
              } else if (index == 3) {
                this.pushReplacement(AlignmentPage());
              }
            }),
      ),
    );
  }

  Widget _buildSettingButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          this.isShow ? this.controller!.reverse() : this.controller!.forward();
          this.isShow = !this.isShow;
        },
        child: Transform.rotate(
          angle: this.angleAnimation!.value,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              JKImage.icon_left,
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMiddleView(String type, GestureTapCallback callBack) {
    return InkWell(
      onTap: () {
        callBack();
        this.push(XOverPage());
      },
      child: Center(
        child: Container(
          width: px(260),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                JKImage.icon_loudspeaker1,
                height: imageSize,
                width: imageSize,
              ),
              Text(
                type,
                style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Image.asset(
                JKImage.icon_loudspeaker2,
                height: imageSize,
                width: imageSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMiddleView(String type, GestureTapCallback callBack) {
    return InkWell(
      onTap: () {
        callBack();
        this.push(XOverPage());
      },
      child: Center(
        child: Container(
          width: px(260),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                JKImage.icon_loudspeaker3,
                height: imageSize,
                width: imageSize,
              ),
              Text(
                type,
                style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Image.asset(
                JKImage.icon_loudspeaker4,
                height: imageSize,
                width: imageSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopView(GestureTapCallback callBack) {
    return InkWell(
      onTap: () {
        callBack();
        this.push(XOverPage());
      },
      child: Center(
        child: Container(
          width: px(260),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    JKImage.icon_loudspeaker5,
                    height: imageSize + 5,
                    width: imageSize + 5,
                  ),
                  Text(
                    S.current.L__WOOFER,
                    style: TextStyle(
                      fontFamily: 'Mont',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(width: px(40)),
              Column(
                children: [
                  Image.asset(
                    JKImage.icon_loudspeaker5,
                    height: imageSize + 5,
                    width: imageSize + 5,
                  ),
                  Text(
                    S.current.R__WOOFER,
                    style: TextStyle(
                      fontFamily: 'Mont',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWayView() {
    return Container(
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ["2WAY", "3WAY"].map((string) {
          return Container(
            margin: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: JKSize.instance.isPortrait ? 30 : 0),
            child: TextButton(
              child: Text(
                string,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Mont',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1,
                    color: ((string == "2WAY" && JKSetting.instance.is2WAY) ||
                            (string == "3WAY" && !JKSetting.instance.is2WAY))
                        ? Colors.red
                        : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                JKSetting.instance.is2WAY = (string == "2WAY");
                JKSetting.instance.setWay();
                this.setState(() {});
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void dispose() {
    this.controller!.dispose();
    super.dispose();
  }
}
