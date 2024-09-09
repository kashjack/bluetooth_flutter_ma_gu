/*
 * @Author: kashjack
 * @Date: 2021-05-13 11:56:13
 * @LastEditTime: 2022-10-25 17:49:24
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/set/audioSet/AudioSetPage.dart
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/alignment/AlignmentPage.dart';
import 'package:flutter_app/pages/set/speaker/SpeakerPage.dart';
import 'package:flutter_app/pages/set/widget/SettingView.dart';
import 'package:flutter_app/pages/set/eq/EQPage.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/route/BasePage.dart';

class AudioSetPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _AudioSetPageState();
}

class _AudioSetPageState extends BaseWidgetState<AudioSetPage>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  Animation<double>? angleAnimation;

  bool isShow = false;
  double imageSize = 35;
  StateSetter? dialogState;
  bool isPortraitCache = true;
  BuildContext? dialogContext;

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
      if (value == 'bassBoost') {
        setState(() {});
        if (dialogState != null) {
          dialogState!(() {});
        }
      }
    };
    JKSetting.instance.getBassBoostInfo();
  }

  Widget buildVerticalLayout() {
    if ((dialogContext != null) && (isPortraitCache != this.isPortrait)) {
      if (Navigator.canPop(dialogContext!)) {
        Navigator.pop(dialogContext!);
      }
    }
    isPortraitCache = this.isPortrait;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            this.initTopView(S.current.AUDIO_SET),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  this._initSubwoofer(),
                  SizedBox(height: 30),
                  this._initLevel(),
                  SizedBox(height: 30),
                  this._initBassBoost(),
                ],
              ),
            )
          ],
        ),
        this._buildSettingView(),
        Container(
          alignment: Alignment.centerRight,
          child: this._buildSettingButton(),
        ),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    if ((dialogContext != null) && (isPortraitCache != this.isPortrait)) {
      if (Navigator.canPop(dialogContext!)) {
        Navigator.pop(dialogContext!);
      }
    }
    isPortraitCache = this.isPortrait;
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            this.initTopView(S.current.AUDIO_SET),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      this._initSubwoofer(),
                      this._initBassBoost(),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      this._initLevel(),
                      SizedBox(height: 30),
                    ],
                  ),
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

  Widget _initSubwoofer() {
    return Container(
      child: Column(
        children: [
          Text(
            S.current.Subwoofer,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Mont',
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              this._buildButton(
                  JKSetting.instance.isSubwoofer
                      ? JKColor.ff767676
                      : JKColor.main,
                  S.current.OFF, () {
                JKSetting.instance.isSubwoofer = false;
                JKSetting.instance.setBassBoostInfo();
                setState(() {});
              }),
              SizedBox(width: 50),
              this._buildButton(
                  JKSetting.instance.isSubwoofer
                      ? JKColor.main
                      : JKColor.ff767676,
                  S.current.ON, () {
                JKSetting.instance.isSubwoofer = true;
                JKSetting.instance.setBassBoostInfo();
                setState(() {});
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _initLevel() {
    String level = (JKSetting.instance.level - 15).toString();
    if (JKSetting.instance.level > 15) {
      level = '+' + level;
    }
    return Container(
      child: Column(
        children: [
          Text(
            S.current.Level,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Mont',
            ),
          ),
          SizedBox(height: 20),
          this._buildButton(
            JKColor.main,
            level,
            () {
              this._levelAlert();
            },
          ),
        ],
      ),
    );
  }

  Widget _initBassBoost() {
    String bassBoost = [
      S.current.OFF,
      S.current.Level + ' 1',
      S.current.Level + ' 2',
      S.current.Level + ' 3',
      S.current.Level + ' 4',
      S.current.Level + ' 5',
    ][JKSetting.instance.bassBoost];
    return Container(
      child: Column(
        children: [
          Text(
            S.current.Bass_Boost,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Mont',
            ),
          ),
          SizedBox(height: 20),
          this._buildButton(JKColor.main, bassBoost, () {
            this._bassBoostAlert();
          }),
        ],
      ),
    );
  }

  Widget _buildButton(Color color, String title, GestureTapCallback callBack) {
    return InkWell(
      onTap: callBack,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: 25,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Mont',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLevelAlertButton(String title, StateSetter state) {
    Color color = JKColor.ff767676;
    if (JKSetting.instance.level == int.parse(title) + 15) {
      color = JKColor.main;
    }
    return InkWell(
      onTap: () {
        JKSetting.instance.level = int.parse(title) + 15;
        JKSetting.instance.setBassBoostInfo();
        state(() {});
        setState(() {});
      },
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: 23,
        width: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Mont',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBassAlertButton(String title, StateSetter state) {
    Color color = JKColor.ff767676;
    if (title.contains('6')) {
      return SizedBox(width: 75);
    }
    if (title.contains(JKSetting.instance.bassBoost.toString())) {
      color = JKColor.main;
    }
    if (title == S.current.OFF && JKSetting.instance.bassBoost == 0) {
      color = JKColor.main;
    }
    return InkWell(
      onTap: () {
        if (title == S.current.OFF) {
          JKSetting.instance.bassBoost = 0;
        } else if (title == S.current.Level + ' 1') {
          JKSetting.instance.bassBoost = 1;
        } else if (title == S.current.Level + ' 2') {
          JKSetting.instance.bassBoost = 2;
        } else if (title == S.current.Level + ' 3') {
          JKSetting.instance.bassBoost = 3;
        } else if (title == S.current.Level + ' 4') {
          JKSetting.instance.bassBoost = 4;
        } else if (title == S.current.Level + ' 5') {
          JKSetting.instance.bassBoost = 5;
        }
        state(() {});
        setState(() {});
        JKSetting.instance.setBassBoostInfo();
      },
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: 23,
        width: 75,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Mont',
              ),
            )
          ],
        ),
      ),
    );
  }

  _levelAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        dialogContext = context;
        return StatefulBuilder(builder: (context, setDialogState) {
          this.dialogState = setDialogState;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: JKSize.instance.isPortrait ? 300 : 0,
                ),
                Text(
                  S.current.Level,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Mont',
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 210,
                  height: 230,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: JKColor.ff767676,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['-15', '-14', '-13', '-12', '-11']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['-10', '-9', '-8', '-7', '-6']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['-5', '-4', '-3', '-2', '-1']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['0']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['+1', '+2', '+3', '+4', '+5']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['+6', '+7', '+8', '+9', '+10']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['+11', '+12', '+13', '+14', '+15']
                            .map((e) =>
                                this._buildLevelAlertButton(e, setDialogState))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).then((value) {
      this.dialogState = null;
      this.dialogContext = null;
    });
  }

  _bassBoostAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        dialogContext = context;
        return StatefulBuilder(builder: (context, setDialogState) {
          this.dialogState = setDialogState;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: JKSize.instance.isPortrait ? 300 : 0,
                ),
                Text(
                  S.current.Bass_Boost,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Mont',
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 180,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: JKColor.ff767676,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [S.current.OFF]
                            .map((e) =>
                                this._buildBassAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          S.current.Level + ' 1',
                          S.current.Level + ' 2'
                        ]
                            .map((e) =>
                                this._buildBassAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          S.current.Level + ' 3',
                          S.current.Level + ' 4'
                        ]
                            .map((e) =>
                                this._buildBassAlertButton(e, setDialogState))
                            .toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          S.current.Level + ' 5',
                          S.current.Level + ' 6'
                        ]
                            .map((e) =>
                                this._buildBassAlertButton(e, setDialogState))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).then((value) {
      this.dialogState = null;
      this.dialogContext = null;
    });
  }

  Widget _buildSettingView() {
    return Transform.translate(
      offset: Offset(
          this.offsetAnimation!.value.dx, this.offsetAnimation!.value.dy),
      child: Container(
        margin: EdgeInsets.only(right: 50),
        alignment: Alignment.centerRight,
        child: SettingView(
            selIndex: 2,
            selectTypeCallBack: (index) {
              this.controller!.reverse();
              this.isShow = false;
              if (index == 0) {
                this.pushReplacement(EQPage());
              } else if (index == 1) {
                this.pushReplacement(FabaPage());
              } else if (index == 3) {
                this.pushReplacement(AlignmentPage());
              } else if (index == 4) {
                this.pushReplacement(SpeakerPage());
              }
            }),
      ),
    );
  }

  Widget _buildSettingButton() {
    return InkWell(
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
    );
  }

  void dispose() {
    this.controller!.dispose();
    super.dispose();
  }
}
