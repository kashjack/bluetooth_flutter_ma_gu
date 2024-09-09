/*
 * @Author: kashjack
 * @Date: 2021-05-13 11:56:13
 * @LastEditTime: 2022-11-17 11:57:55
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/faba/fabaPage.dart
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/EQBean.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/alignment/AlignmentPage.dart';
import 'package:flutter_app/pages/set/audioSet/AudioSetPage.dart';
import 'package:flutter_app/pages/set/eq/EQPage.dart';
import 'package:flutter_app/pages/set/speaker/SpeakerPage.dart';
import 'package:flutter_app/pages/set/widget/CustomSlide.dart';
import 'package:flutter_app/pages/set/widget/FabaWidget.dart';
import 'package:flutter_app/pages/set/widget/SettingView.dart';
import 'package:flutter_app/pages/set/widget/SpeakView.dart';
import 'package:flutter_app/pages/set/widget/TouchMoveView.dart';
import 'package:flutter_app/route/BasePage.dart';

class FabaPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _FabaPageState();
}

class _FabaPageState extends BaseWidgetState<FabaPage>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  Animation<double>? angleAnimation;

  EQSlideItem faderSlideItem = EQSlideItem(
    id: 1,
    leftText: S.current.Fader,
    rightText: "0",
    min: -15,
    max: 15,
  );
  EQSlideItem balanceSlideItem = EQSlideItem(
    id: 2,
    leftText: S.current.Balance,
    rightText: "0",
    min: -15,
    max: 15,
  );

  GlobalKey<EQSliderState> faderSliderKey = GlobalKey();
  GlobalKey<EQSliderState> balanceSliderKey = GlobalKey();
  GlobalKey<TouchMoveState> touchMoveKey = GlobalKey();
  GlobalKey<SpeakViewState> speakViewKey = GlobalKey();

  bool isShow = false;
  Map<int, String> map = {
    0: S.current.Front + ' ' + S.current.L,
    1: S.current.Front + ' ' + S.current.R,
    2: S.current.All,
    3: S.current.Rear + ' ' + S.current.L,
    4: S.current.Rear + ' ' + S.current.R,
    5: S.current.Reset,
  };
  int _btnCurrentId = 2; //底部按钮当前id

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
      if (value == "faba") {
        faderSliderKey.currentState!
            .changeProgress(-JKSetting.instance.faderProgress.toDouble());
        balanceSliderKey.currentState!
            .changeProgress(-JKSetting.instance.balanceProgress.toDouble());
        touchMoveKey.currentState!.allOffsetChange(
            15 + JKSetting.instance.balanceProgress,
            JKSetting.instance.faderProgress + 15);
        this.setButtoon();
      }
    };
    JKSetting.instance.getFABAInfo();
  }

  Widget buildVerticalLayout() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            this.initTopView(S.current.FABA),
            this._buildCarView(),
            initFabaSlider(faderSlideItem, true),
            initFabaSlider(balanceSlideItem, false),
            //功能被取消
            this._initBottomView(),
          ],
        ),
        this._buildSettingView(),
        Container(
          alignment: Alignment.centerRight,
          child: Transform.rotate(
            angle: this.angleAnimation!.value,
            child: Container(
              width: 50,
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Image.asset(
                  JKImage.icon_left,
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  this.isShow
                      ? this.controller!.reverse()
                      : this.controller!.forward();
                  this.isShow = !this.isShow;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(
      children: [
        Column(
          children: [
            this.initTopView('FA/BA'),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  this._buildCarView(),
                  Container(
                    width: JKSize.instance.px * 350,
                    child: Column(
                      children: [
                        initFabaSlider(faderSlideItem, true),
                        initFabaSlider(balanceSlideItem, false),
                        this._initBottomView(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        this._buildSettingView(),
        Container(
          margin: EdgeInsets.only(right: 0),
          alignment: Alignment.centerRight,
          child: Transform.rotate(
            angle: this.angleAnimation!.value,
            child: Container(
              width: 50,
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Image.asset(
                  JKImage.icon_left,
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  this.isShow
                      ? this.controller!.reverse()
                      : this.controller!.forward();
                  this.isShow = !this.isShow;
                },
              ),
            ),
          ),
        ),
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
            selIndex: 1,
            selectTypeCallBack: (index) {
              this.controller!.reverse();
              this.isShow = false;
              if (index == 0) {
                this.pushReplacement(EQPage());
              } else if (index == 2) {
                this.pushReplacement(AudioSetPage());
              } else if (index == 3) {
                this.pushReplacement(AlignmentPage());
              } else if (index == 4) {
                this.pushReplacement(SpeakerPage());
              }
            }),
      ),
    );
  }

  Widget _buildCarView() {
    return Container(
      // color: Colors.yellow,
      padding: EdgeInsets.only(
        left: JKSize.instance.isPortrait ? 0 : 10,
      ),
      height: JKSize.instance.isPortrait
          ? JKSize.instance.px * 320
          : JKSize.instance.px * 290,
      width: JKSize.instance.px * 300,
      child: Column(
        children: [
          Container(
            // color: Colors.amber,
            child: Stack(
              children: [
                Container(
                  height: JKSize.instance.isPortrait
                      ? JKSize.instance.px * 290
                      : JKSize.instance.px * 290,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              JKImage.icon_loudspeaker1,
                              width: this.px * 25,
                              height: this.px * 25,
                            ),
                            Image.asset(
                              JKImage.icon_loudspeaker3,
                              width: this.px * 25,
                              height: this.px * 25,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              JKImage.icon_loudspeaker2,
                              width: this.px * 25,
                              height: this.px * 25,
                            ),
                            Image.asset(
                              JKImage.icon_loudspeaker4,
                              width: this.px * 25,
                              height: this.px * 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  height: JKSize.instance.px * 290,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          JKImage.icon_car,
                          // alignment: Alignment.center,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SpeakView(
                        key: speakViewKey,
                      ),
                      Container(
                        child: TouchMoveView(
                          key: touchMoveKey,
                          speakViewKey: speakViewKey,
                          xProgressCount: 30,
                          yProgressCount: 30,
                          touchMoveCallback:
                              (xOffsetRatio, yOffsetRatio, offset) {
                            JKSetting.instance.balanceProgress =
                                xOffsetRatio - 15;
                            balanceSliderKey.currentState!.changeProgress(
                                -JKSetting.instance.balanceProgress.toDouble());
                            JKSetting.instance.faderProgress =
                                yOffsetRatio - 15;
                            faderSliderKey.currentState!.changeProgress(
                                -JKSetting.instance.faderProgress.toDouble());
                            speakViewKey.currentState!.reloadCenter(offset);
                            this.setButtoon();
                            JKSetting.instance.changeFABA();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget initFabaSlider(EQSlideItem item, bool isTop) {
    return Container(
      margin: EdgeInsets.only(top: isTop ? 20 : 0),
      height: isTop ? 70 : 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                item.leftText,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mont',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            flex: 4,
          ),
          Expanded(
            child: Column(
              children: [
                Offstage(
                  offstage: !isTop,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "-15",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mont',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mont',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "+15",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mont',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: EQSlider(
                    key: item.id == 1 ? faderSliderKey : balanceSliderKey,
                    isSliderTop: false,
                    min: item.min,
                    max: item.max,
                    progress: (item.id == 1
                            ? -JKSetting.instance.faderProgress
                            : -JKSetting.instance.balanceProgress)
                        .toDouble(),
                    onChanged: (value) {
                      if (item.id == 1) {
                        JKSetting.instance.faderProgress = -value.toInt();
                        touchMoveKey.currentState!.onlyOneOffsetChange(
                            JKSetting.instance.faderProgress + 15, false);
                        JKSetting.instance.changeFABA();
                      } else {
                        JKSetting.instance.balanceProgress = -value.toInt();
                        touchMoveKey.currentState!.onlyOneOffsetChange(
                            15 + JKSetting.instance.balanceProgress, true);
                        JKSetting.instance.changeFABA();
                      }
                      this.setButtoon();
                    },
                  ),
                ),
              ],
            ),
            flex: 5,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "${(item.id == 1 ? -JKSetting.instance.faderProgress : -JKSetting.instance.balanceProgress)}",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mont',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            flex: 4,
          )
        ],
      ),
    );
  }

  setButtoon() {
    setState(() {
      if (JKSetting.instance.faderProgress == -15 &&
          JKSetting.instance.balanceProgress == 15) {
        _btnCurrentId = 0;
      } else if (JKSetting.instance.faderProgress == -15 &&
          JKSetting.instance.balanceProgress == -15) {
        _btnCurrentId = 1;
      } else if (JKSetting.instance.faderProgress == 15 &&
          JKSetting.instance.balanceProgress == 15) {
        _btnCurrentId = 3;
      } else if (JKSetting.instance.faderProgress == 15 &&
          JKSetting.instance.balanceProgress == -15) {
        _btnCurrentId = 4;
      } else {
        _btnCurrentId = 2;
      }
    });
  }

  Widget _initBottomView() {
    printLog(_btnCurrentId);
    return RadioBtnWrap(
      currentId: _btnCurrentId,
      data: map,
      onlyButtonIds: [5],
      checkUpdate: (int id) {
        _btnCurrentId = id;
        switch (id) {
          case 0: //Driver
            JKSetting.instance.faderProgress = -15;
            JKSetting.instance.balanceProgress = 15;
            break;
          case 1: //Passenger
            JKSetting.instance.faderProgress = -15;
            JKSetting.instance.balanceProgress = -15;
            break;
          case 2: //All
            JKSetting.instance.faderProgress = 0;
            JKSetting.instance.balanceProgress = 0;
            break;
          case 3: //Backseat L
            JKSetting.instance.faderProgress = 15;
            JKSetting.instance.balanceProgress = 15;
            break;
          case 4: //Backseat R
            JKSetting.instance.faderProgress = 15;
            JKSetting.instance.balanceProgress = -15;
            break;
          case 5:
            JKSetting.instance.reset(0x02);
            return;
        }
        faderSliderKey.currentState!
            .changeProgress(-JKSetting.instance.faderProgress.toDouble());
        balanceSliderKey.currentState!
            .changeProgress(-JKSetting.instance.balanceProgress.toDouble());
        touchMoveKey.currentState!.allOffsetChange(
            JKSetting.instance.balanceProgress + 15,
            JKSetting.instance.faderProgress + 15);
        JKSetting.instance.changeFABA();
        setState(() {});
      },
    );
  }

  void dispose() {
    this.controller!.dispose();
    super.dispose();
  }
}
