/*
 * @Author: kashjack
 * @Date: 2021-05-13 11:56:04
 * @LastEditTime: 2022-10-17 17:04:02
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/pages/setting/alignment/alignmentPage.dart
 */
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/AlignmentBean.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/audioSet/AudioSetPage.dart';
import 'package:flutter_app/pages/set/eq/EQPage.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/pages/set/speaker/SpeakerPage.dart';
import 'package:flutter_app/pages/set/widget/SettingView.dart';
import 'package:flutter_app/route/BasePage.dart';

class AlignmentPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _AlignmentPageState();
}

class _AlignmentPageState extends BaseWidgetState<AlignmentPage>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;
  Animation<double>? angleAnimation;

  bool isShow = false;
  String selType = 'Small';
  Timer? timer;
  BuildContext? dialogContext;
  bool isPortraitCache = true;
  Function? dialogState;

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
      setState(() {});
      if (dialogState != null) {
        dialogState!(() {});
      }
    };
    JKSetting.instance.getAlignmentInfo();
  }

  Widget buildVerticalLayout() {
    if ((dialogContext != null) & (isPortraitCache != this.isPortrait)) {
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
            this.initTopView(S.current.Alignment),
            this.initContentView(),
          ],
        ),
        this._buildSettingView(),
        Container(
          alignment: Alignment.centerRight,
          child: this._buildSettingButton(),
        )
      ],
    );
  }

  Widget buildHorizontalLayout() {
    if ((dialogContext != null) & (isPortraitCache != this.isPortrait)) {
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
            this.initTopView(S.current.Alignment),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(width: 40),
                  Container(
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          width: 400,
                          child: Transform.rotate(
                            angle: -math.pi / 2,
                            child: Image.asset(
                              JKImage.icon_car,
                            ),
                          ),
                        ),
                        this.initHorizontalLoudspeakerView(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        this._initPositionRow(),
                        this._initResetBtn(),
                      ],
                    ),
                  ),
                  SizedBox(width: 30)
                  // this._buildSettingButton()
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

  Widget _buildSettingView() {
    return Transform.translate(
      offset: Offset(
          this.offsetAnimation!.value.dx, this.offsetAnimation!.value.dy),
      child: Container(
        margin: EdgeInsets.only(right: 50),
        alignment: Alignment.centerRight,
        child: SettingView(
            selIndex: 3,
            selectTypeCallBack: (index) {
              this.controller!.reverse();
              this.isShow = false;
              if (index == 0) {
                this.pushReplacement(EQPage());
              } else if (index == 1) {
                this.pushReplacement(FabaPage());
              } else if (index == 2) {
                this.pushReplacement(AudioSetPage());
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

  Widget initContentView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          this.initCarView(),
          this._initRowView(),
        ],
      ),
    );
  }

  Widget initHorizontalCarView() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                width: 400,
                child: Transform.rotate(
                  angle: -math.pi / 2,
                  child: Image.asset(
                    JKImage.icon_car,
                  ),
                ),
              ),
              this.initHorizontalLoudspeakerView(),
            ],
          ),
        ),
        _initPositionRow(),
      ],
    );
  }

  Widget initCarView() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: EdgeInsets.only(top: 32),
            alignment:
                isPortraitCache ? Alignment.topCenter : Alignment.topLeft,
            child: Image.asset(
              JKImage.icon_car,
              width: this.px * 140,
              fit: BoxFit.fitWidth,
            ),
          ),
          this.initLoudspeakerView(),
        ],
      ),
    );
  }

  Widget initHorizontalLoudspeakerView() {
    return Container(
      width: px(440),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this._initLoudSpeakerImageView(1),
                SizedBox(
                  height: px(150),
                ),
                this._initLoudSpeakerImageView(0),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(120, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this._initLoudSpeakerImageView(3),
                SizedBox(
                  height: px(150),
                ),
                this._initLoudSpeakerImageView(2),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                this._initLoudSpeakerImageView(5),
                SizedBox(
                  height: px(30),
                ),
                this._initLoudSpeakerImageView(4)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget initLoudspeakerView() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: this.px * 280,
        width: this.px * 280,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  this._initLoudSpeakerImageView(0),
                  SizedBox(
                    width: JKSize.instance.px * 200,
                  ),
                  this._initLoudSpeakerImageView(1),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: JKSize.instance.px * 140, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  this._initLoudSpeakerImageView(2),
                  SizedBox(
                    width: JKSize.instance.px * 200,
                  ),
                  this._initLoudSpeakerImageView(3),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: JKSize.instance.px * 30, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  this._initLoudSpeakerImageView(4),
                  SizedBox(
                    width: 40,
                  ),
                  this._initLoudSpeakerImageView(5)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _initLoudSpeakerImageView(int index) {
    if (isPortraitCache) {
      if (index <= 3) {
        return Opacity(
          opacity: needVisible(index) ? 1 : 0,
          child: Column(
            children: [
              Text(
                "${(JKSetting.instance.alignmentSpeakMss[index].ms * 0.01).toStringAsFixed(2)}ms",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${JKSetting.instance.alignmentSpeaks[index].cm}cm   ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    if (needVisible(index)) {
                      showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            dialogContext = context;
                            return StatefulBuilder(builder: (context, state) {
                              dialogState = state;
                              return _changeAlignmentDialog(index, state);
                            });
                          }).then((value) {
                        dialogContext = null;
                        dialogState = null;
                      });
                    }
                  },
                  child: Image.asset(
                    getLoudSpeakerImage(index),
                    width: isPortraitCache ? this.px * 35 : this.px * 30,
                    height: isPortraitCache ? this.px * 35 : this.px * 30,
                  ),
                ),
              ),
              Text(
                "${JKSetting.instance.alignmentSpeaks[index].db - 8}DB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        return Opacity(
          opacity: needVisible(index) ? 1 : 0,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "${JKSetting.instance.alignmentSpeaks[index].cm}cm   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${(JKSetting.instance.alignmentSpeakMss[index].ms * 0.01).toStringAsFixed(2)}ms",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                    onTap: () {
                      if (needVisible(index)) {
                        showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (context) {
                              dialogContext = context;
                              return StatefulBuilder(builder: (context, state) {
                                dialogState = state;
                                return _changeAlignmentDialog(index, state);
                              });
                            }).then((value) {
                          dialogContext = null;
                          dialogState = null;
                        });
                      }
                    },
                    child: Transform.rotate(
                      angle: isPortraitCache ? 0 : -math.pi / 2,
                      child: Image.asset(
                        getLoudSpeakerImage(index),
                        width: isPortraitCache ? this.px * 35 : this.px * 30,
                        height: isPortraitCache ? this.px * 35 : this.px * 30,
                      ),
                    )),
              ),
              Text(
                "${JKSetting.instance.alignmentSpeaks[index].db - 8}DB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (index <= 3) {
        return Opacity(
          opacity: needVisible(index) ? 1 : 0,
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "${(JKSetting.instance.alignmentSpeakMss[index].ms * 0.01).toStringAsFixed(2)}ms",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${JKSetting.instance.alignmentSpeaks[index].cm}cm   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                  onTap: () {
                    if (needVisible(index)) {
                      showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            dialogContext = context;
                            return StatefulBuilder(builder: (context, state) {
                              dialogState = state;
                              return _changeAlignmentDialog(index, state);
                            });
                          }).then((value) {
                        dialogContext = null;
                        dialogState = null;
                      });
                    }
                  },
                  child: Image.asset(
                    getLoudSpeakerImage(index),
                    width: isPortraitCache ? this.px * 35 : this.px * 30,
                    height: isPortraitCache ? this.px * 35 : this.px * 30,
                  ),
                ),
              ),
              Text(
                "${JKSetting.instance.alignmentSpeaks[index].db - 8}DB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        return Opacity(
          opacity: needVisible(index) ? 1 : 0,
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "${JKSetting.instance.alignmentSpeaks[index].cm}cm   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${(JKSetting.instance.alignmentSpeakMss[index].ms * 0.01).toStringAsFixed(2)}ms",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isPortraitCache ? 12 : 10,
                      fontFamily: 'Mont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: GestureDetector(
                    onTap: () {
                      if (needVisible(index)) {
                        showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (context) {
                              dialogContext = context;
                              return StatefulBuilder(builder: (context, state) {
                                dialogState = state;
                                return _changeAlignmentDialog(index, state);
                              });
                            }).then((value) {
                          dialogContext = null;
                          dialogState = null;
                        });
                      }
                    },
                    child: Transform.rotate(
                      angle: isPortraitCache ? 0 : -math.pi / 2,
                      child: Image.asset(
                        getLoudSpeakerImage(index),
                        width: isPortraitCache ? this.px * 35 : this.px * 30,
                        height: isPortraitCache ? this.px * 35 : this.px * 30,
                      ),
                    )),
              ),
              Text(
                "${JKSetting.instance.alignmentSpeaks[index].db - 8}DB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isPortraitCache ? 12 : 10,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _initCMTextView(int index, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text(
            S.current.Distance,
            style: TextStyle(
              fontSize: isPortraitCache ? 14 : 10,
              color: Colors.white,
              fontFamily: 'Mont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  minusSpeakCm(index, state);
                },
                onTapDown: (e) {
                  if (timer != null) {
                    timer!.cancel();
                  }
                  int count = 0;
                  timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
                    count++;
                    if (count > 5) {
                      minusSpeakCm(index, state);
                    }
                  });
                },
                onTapUp: (e) {
                  if (timer != null) {
                    timer!.cancel();
                  }
                },
                onTapCancel: () {
                  if (timer != null) {
                    timer!.cancel();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    JKImage.icon_triangle_left,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.red,
                decoration: ShapeDecoration(
                    color: Colors.grey[850],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide.none)),
                child: Column(
                  children: [
                    Text(
                      "${JKSetting.instance.alignmentSpeaks[index].cm}CM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPortraitCache ? 12 : 10,
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${(JKSetting.instance.alignmentSpeakMss[index].ms * 0.01).toStringAsFixed(2)}MS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPortraitCache ? 12 : 10,
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  addSpeakCm(index, state);
                },
                onTapDown: (e) {
                  if (timer != null) {
                    timer!.cancel();
                  }
                  int count = 0;
                  timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
                    count++;
                    if (count > 5) {
                      addSpeakCm(index, state);
                    }
                  });
                },
                onTapUp: (e) {
                  if (timer != null) {
                    timer!.cancel();
                  }
                },
                onTapCancel: () {
                  if (timer != null) {
                    timer!.cancel();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    JKImage.icon_triangle_right,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _initDBTextView(int index, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: isPortraitCache
              ? EdgeInsets.fromLTRB(0, 20, 0, 5)
              : EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            S.current.Gain,
            style: TextStyle(
              fontSize: isPortraitCache ? 14 : 10,
              color: Colors.white,
              fontFamily: 'Mont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  JKSetting.instance.alignmentSpeaks[index].db--;
                  if (JKSetting.instance.alignmentSpeaks[index].db <
                      JKSetting.instance.dbMin) {
                    JKSetting.instance.alignmentSpeaks[index].db =
                        JKSetting.instance.dbMin;
                  }
                  JKSetting.instance.setAlignmentInfo();
                  state(() {});
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    JKImage.icon_triangle_left,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.grey[850],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide.none)),
                child: Text(
                  "${JKSetting.instance.alignmentSpeaks[index].db - 8}DB",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPortraitCache ? 12 : 10,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  JKSetting.instance.alignmentSpeaks[index].db++;
                  if (JKSetting.instance.alignmentSpeaks[index].db >
                      JKSetting.instance.dbMax) {
                    JKSetting.instance.alignmentSpeaks[index].db =
                        JKSetting.instance.dbMax;
                  }
                  JKSetting.instance.setAlignmentInfo();
                  state(() {});
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.asset(
                    JKImage.icon_triangle_right,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _initRowView() {
    return Container(
      height: px(110),
      child: Column(
        children: [
          _initResetBtn(),
          _initPositionRow(),
        ],
      ),
    );
  }

  ElevatedButton _initResetBtn() {
    return ElevatedButton(
      onPressed: () {
        JKSetting.instance.reset(0x03);
      },
      child: Text(
        S.current.Reset,
        style: TextStyle(
          fontFamily: 'Mont',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          side: MaterialStateProperty.all(
              BorderSide(width: 1, color: Color(0xFFFFFFFF))),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
    );
  }

  Widget _initPositionRow() {
    if (isPortraitCache) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Text(
                S.current.Position,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove),
              color: Colors.red,
              onPressed: () {
                JKSetting.instance.alignmentPosition =
                    (JKSetting.instance.alignmentPosition + 3) % 4;
                JKSetting.instance.setAlignmentInfo();
                setState(() {});
              },
            ),
            Container(
              alignment: Alignment.center,
              height: 15,
              width: 90,
              color: Color(0xFF767676),
              child: Text(
                JKSetting.instance
                    .alignmentModes[JKSetting.instance.alignmentPosition],
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.red,
              onPressed: () {
                JKSetting.instance.alignmentPosition =
                    (JKSetting.instance.alignmentPosition + 1) % 4;
                JKSetting.instance.setAlignmentInfo();
                setState(() {});
              },
            ),
          ],
        ),
      );
    } else {
      return Container(
        // color: Colors.blue,
        child: Column(
          children: [
            Container(
              width: 80,
              child: Text(
                'Positonin',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: () {
                    JKSetting.instance.alignmentPosition =
                        (JKSetting.instance.alignmentPosition + 3) % 4;
                    JKSetting.instance.setAlignmentInfo();
                    setState(() {});
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  height: 15,
                  width: 90,
                  color: Color(0xFF767676),
                  child: Text(
                    JKSetting.instance
                        .alignmentModes[JKSetting.instance.alignmentPosition],
                    style: TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.red,
                  onPressed: () {
                    JKSetting.instance.alignmentPosition =
                        (JKSetting.instance.alignmentPosition + 1) % 4;
                    JKSetting.instance.setAlignmentInfo();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  bool needVisible(int index) {
    // 改成不隐藏了
    // switch (JKSetting.instance.alignmentPosition) {
    //   case 0: //all
    //     return true;
    //     break;
    //   case 1: //FRONT LEFT
    //     return index == 0;
    //     break;
    //   case 2: //FRONT RIGHT
    //     return index == 1;
    //     break;
    //   case 3: //FRONT ALL
    //     return index == 0 || index == 1;
    //     break;
    // }
    // return false;

    // 改成不隐藏了
    return true;
  }

  String getLoudSpeakerImage(int index) {
    if (isPortraitCache) {
      switch (index) {
        case 0:
          return JKImage.icon_loudspeaker1;
        case 1:
          return JKImage.icon_loudspeaker2;
        case 2:
          return JKImage.icon_loudspeaker3;
        case 3:
          return JKImage.icon_loudspeaker4;
        case 4:
          return JKImage.icon_loudspeaker5;
        case 5:
          return JKImage.icon_loudspeaker5;
      }
    } else {
      switch (index) {
        case 0:
          return JKImage.icon_loudspeaker3;
        case 1:
          return JKImage.icon_loudspeaker1;
        case 2:
          return JKImage.icon_loudspeaker4;
        case 3:
          return JKImage.icon_loudspeaker2;
        case 4:
          return JKImage.icon_loudspeaker5;
        case 5:
          return JKImage.icon_loudspeaker5;
      }
    }
    return '';
  }

  void handleSpeakCm(AlignmentSpeakItem item) {
    item.cm0 = item.cm >> 8;
    item.cm1 = item.cm - (item.cm0 << 8);
  }

  void minusSpeakCm(int index, state) {
    JKSetting.instance.alignmentSpeaks[index].cm--;
    if (JKSetting.instance.alignmentSpeaks[index].cm <
        JKSetting.instance.cmMin) {
      JKSetting.instance.alignmentSpeaks[index].cm = JKSetting.instance.cmMin;
    }
    handleSpeakCm(JKSetting.instance.alignmentSpeaks[index]);
    JKSetting.instance.setAlignmentInfo();
    state(() {});
    setState(() {});
  }

  void addSpeakCm(int index, state) {
    JKSetting.instance.alignmentSpeaks[index].cm++;
    if (JKSetting.instance.alignmentSpeaks[index].cm >
        JKSetting.instance.cmMax) {
      JKSetting.instance.alignmentSpeaks[index].cm = JKSetting.instance.cmMax;
    }
    handleSpeakCm(JKSetting.instance.alignmentSpeaks[index]);
    JKSetting.instance.setAlignmentInfo();
    state(() {});
    setState(() {});
  }

  SimpleDialog _changeAlignmentDialog(index, state) {
    List<String> titleList = [
      S.current.FRONT + ' ' + S.current.LEFT,
      S.current.FRONT + ' ' + S.current.RIGHT,
      S.current.REAR + ' ' + S.current.LEFT,
      S.current.REAR + ' ' + S.current.RIGHT,
      S.current.WOOFER + ' ' + S.current.LEFT,
      S.current.WOOFER + ' ' + S.current.RIGHT,
    ];
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
              width: 2, color: Colors.grey[500]!, style: BorderStyle.solid)),
      title: Text(
        titleList[index],
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: isPortraitCache ? 15 : 12, color: Colors.white),
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 8.0, 0, 10),
      titlePadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      insetPadding: this.isPortrait
          ? const EdgeInsets.fromLTRB(110, 0, 110, 250)
          : const EdgeInsets.fromLTRB(120, 50, 430, 0),
      children: [_initCMTextView(index, state), _initDBTextView(index, state)],
    );
  }

  void dispose() {
    this.controller!.dispose();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    super.dispose();
  }
}
