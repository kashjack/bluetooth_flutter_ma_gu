/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-29 16:30:16
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/route/BasePage.dart';

class PlayPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _PlayPageState();
}

class _PlayPageState extends BaseWidgetState<PlayPage> {
  List<String> topBtnList = [S.current.SUB];
  List<String> typeBtnList = [S.current.LOUD];
  List<String> controlBtnList = [
    JKImage.icon_radio_voice,
    JKImage.icon_play_last,
    JKImage.icon_play_pause,
    JKImage.icon_play_next,
    JKImage.icon_radio_setting
  ];

  Widget buildVerticalLayout() {
    String headTitle = S.current.USB;
    if (JKSetting.instance.mode == 3) {
      headTitle = S.current.USB;
    } else if (JKSetting.instance.mode == 4) {
      headTitle = S.current.SD_Card;
    }
    return Column(
      children: [
        this.initTopView(headTitle),
        this.initTopButtonView(),
        this.initTypeButtonView(),
        this.initVoiceView(),
        this.initContentView(),
        this.buildVerticalBottomLayout(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    String headTitle = S.current.USB;
    if (JKSetting.instance.mode == 3) {
      headTitle = S.current.USB;
    } else if (JKSetting.instance.mode == 4) {
      headTitle = S.current.SD_Card;
    }

    return Stack(
      children: [
        this.initHorizontalContentView(),
        Column(
          children: [
            this.initTopView(headTitle),
            this.initTopButtonView(),
            this.initTypeButtonView(),
            this.initVoiceView(),
            this.buildHorizontalBottomLayout(),
          ],
        ),
      ],
    );
  }

  void initData() {
    JKBluetooth.instance.stateCallback = (value) {
      if (value == "play") {
        controlBtnList[0] = JKSetting.instance.isMute
            ? JKImage.icon_radio_mute
            : JKImage.icon_radio_voice;
        controlBtnList[2] = JKSetting.instance.isMusicPlay
            ? JKImage.icon_play_pause
            : JKImage.icon_play_play;
      }
      setState(() {});
    };
    JKSetting.instance.getVolume().then((value) {
      return JKSetting.instance.getPlayInfo();
    });
  }

  Widget initTopButtonView() {
    if (this.topBtnList.length == 2) {
      this.topBtnList.removeLast();
    }
    String eqType = JKSetting.instance.eqModes[JKSetting.instance.nowEQMode];
    this.topBtnList.add(eqType);
    return Container(
      height: px(40),
      width: px(350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.topBtnList.map((string) {
          return Container(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                string,
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 14,
                  color:
                      isStateChecked(string) ? Colors.white : Color(0xff8b8b8b),
                ),
              ),
              onPressed: null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget initTypeButtonView() {
    return Container(
      height: px(40),
      width: px(350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.typeBtnList.map((string) {
          return Container(
            width: this.px * 100,
            height: 30,
            child: TextButton(
              child: Text(
                string,
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 14,
                  color: Color(0xff8b8b8b),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1,
                    color: JKSetting.instance.isLoud
                        ? JKColor.main
                        : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                JKSetting.instance.isLoud = !JKSetting.instance.isLoud;
                JKSetting.instance.setPlayInfo(0);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget initContentView() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: JKColor.main,
              width: 10,
            ),
          ),
          height: 300,
          width: 300,
          child: Text(
            '${JKSetting.instance.musicName}\n${JKSetting.instance.albumName}\n${JKSetting.instance.artistName}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mont',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget initHorizontalContentView() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          JKSize.instance.px * 36, JKSize.instance.px * 90, right, bottom),
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: JKSize.instance.px * 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red,
          width: 5,
        ),
      ),
      height: JKSize.instance.px * 133,
      width: JKSize.instance.px * 133,
      child: Text(
        '${JKSetting.instance.musicName}\n${JKSetting.instance.albumName}\n${JKSetting.instance.artistName}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Mont',
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget buildVerticalBottomLayout() {
    return Container(
      height: 150,
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          this.initTimeView(),
          this.initControlView(),
          this.initPlayTypeView(),
        ],
      ),
    );
  }

  Widget buildHorizontalBottomLayout() {
    return Container(
      height: 100,
      margin:
          EdgeInsets.only(left: 30, right: 30, top: JKSize.instance.px * 50),
      child: Column(
        children: [
          this.initTimeView(),
          this.buildControlView(),
        ],
      ),
    );
  }

  Widget initTimeView() {
    return Container(
      height: 40,
      child: Row(
        children: [
          Container(
            width: 50,
            child: Text(
              "${JKSetting.instance.nowMinute.toTimeString()}:${JKSetting.instance.nowSecond.toTimeString()}",
              style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbColor: Colors.red,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Color(0xff666666),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: (JKSetting.instance.nowMinute * 60 +
                        JKSetting.instance.nowSecond)
                    .toDouble(),
                min: 0,
                max: (JKSetting.instance.totalMinute * 60 +
                        JKSetting.instance.totalSecond)
                    .toDouble(),
                onChanged: (value) {
                  setState(() {
                    JKSetting.instance.nowMinute = value ~/ 60;
                    JKSetting.instance.nowSecond = (value % 60).toInt();
                    // JKSetting.instance.setPlayInfo(0x00);

                    JKSetting.instance.changePlayTime();
                  });
                },
              ),
            ),
          ),
          Container(
            width: 50,
            child: Text(
              "${JKSetting.instance.totalMinute.toTimeString()}:${JKSetting.instance.totalSecond.toTimeString()}",
              style: TextStyle(
                  fontFamily: 'Mont',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildControlView() {
    Color color1 =
        JKSetting.instance.isRandom ? Colors.white : Colors.grey.shade600;
    Color color2 =
        JKSetting.instance.isCycle ? Colors.white : Colors.grey.shade600;
    return Container(
      height: 60,
      width: this.px * 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            child: Image.asset(
              JKImage.icon_play_random,
              color: color1,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              JKSetting.instance.isRandom = !JKSetting.instance.isRandom;
              if (JKSetting.instance.isRandom) {
                JKSetting.instance.isCycle = false;
                JKSetting.instance.setPlayInfo(0x20);
              } else {
                JKSetting.instance.setPlayInfo(0x00);
              }
              this.setState(() {});
            },
          ),
          Container(
            width: this.px * 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: this
                  .controlBtnList
                  .asMap()
                  .map((index, imageName) {
                    return MapEntry(
                        index,
                        GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0: //voice
                                JKSetting.instance.isMute =
                                    !JKSetting.instance.isMute;
                                JKSetting.instance.setPlayInfo(0x00);
                                break;
                              case 1: //last
                                JKSetting.instance.setPlayInfo(0x04);
                                break;
                              case 2: //pause
                                JKSetting.instance.isMusicPlay =
                                    !JKSetting.instance.isMusicPlay;
                                JKSetting.instance.setPlayInfo(
                                    JKSetting.instance.isMusicPlay
                                        ? 0x01
                                        : 0x02);
                                setState(() {});
                                break;
                              case 3: //next
                                JKSetting.instance.setPlayInfo(0x08);
                                break;
                              case 4: //setting
                                this.push(FabaPage());
                                break;
                            }
                          },
                          onLongPressStart: (e) {
                            if (index == 1) {
                              //快退
                              JKSetting.instance
                                  .setPlayInfo(0x00, function2: 0x04);
                            } else if (index == 3) {
                              //快进
                              JKSetting.instance
                                  .setPlayInfo(0x00, function2: 0x02);
                            }
                          },
                          onLongPressEnd: (e) {
                            if (index == 1) {
                              //取消快退
                              JKSetting.instance
                                  .setPlayInfo(0x00, function2: 0x00);
                            } else if (index == 3) {
                              //取消快进
                              JKSetting.instance
                                  .setPlayInfo(0x00, function2: 0x00);
                            }
                          },
                          child: Container(
                            width: 50,
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Image.asset(
                                imageName,
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                              onPressed: null,
                            ),
                          ),
                        ));
                  })
                  .values
                  .toList(),
            ),
          ),
          TextButton(
            child: Image.asset(
              JKImage.icon_play_cycle,
              color: color2,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              JKSetting.instance.isCycle = !JKSetting.instance.isCycle;
              if (JKSetting.instance.isCycle) {
                JKSetting.instance.isRandom = false;
                JKSetting.instance.setPlayInfo(0x10);
              } else {
                JKSetting.instance.setPlayInfo(0x00);
              }
              this.setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget initControlView() {
    return Container(
      height: 60,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this
                .controlBtnList
                .asMap()
                .map((index, imageName) {
                  return MapEntry(
                      index,
                      GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0: //voice
                              JKSetting.instance.isMute =
                                  !JKSetting.instance.isMute;
                              JKSetting.instance.setPlayInfo(0x00);
                              break;
                            case 1: //last
                              JKSetting.instance.setPlayInfo(0x04);
                              break;
                            case 2: //pause
                              JKSetting.instance.isMusicPlay =
                                  !JKSetting.instance.isMusicPlay;
                              JKSetting.instance.setPlayInfo(
                                  JKSetting.instance.isMusicPlay ? 0x01 : 0x02);
                              setState(() {});
                              break;
                            case 3: //next
                              JKSetting.instance.setPlayInfo(0x08);
                              break;
                            case 4: //setting
                              this.push(FabaPage());
                              break;
                          }
                        },
                        onLongPressStart: (e) {
                          if (index == 1) {
                            //快退
                            JKSetting.instance
                                .setPlayInfo(0x00, function2: 0x04);
                          } else if (index == 3) {
                            //快进
                            JKSetting.instance
                                .setPlayInfo(0x00, function2: 0x02);
                          }
                        },
                        onLongPressEnd: (e) {
                          if (index == 1) {
                            //取消快退
                            JKSetting.instance
                                .setPlayInfo(0x00, function2: 0x00);
                          } else if (index == 3) {
                            //取消快进
                            JKSetting.instance
                                .setPlayInfo(0x00, function2: 0x00);
                          }
                        },
                        child: Container(
                          width: 50,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Image.asset(
                              imageName,
                              height: 30,
                              width: 30,
                              fit: BoxFit.contain,
                            ),
                            onPressed: null,
                          ),
                        ),
                      ));
                })
                .values
                .toList(),
          )
        ],
      ),
    );
  }

  Widget initPlayTypeView() {
    Color color1 =
        JKSetting.instance.isRandom ? Colors.white : Colors.grey.shade600;
    Color color2 =
        JKSetting.instance.isCycle ? Colors.white : Colors.grey.shade600;
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Image.asset(
              JKImage.icon_play_random,
              color: color1,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              JKSetting.instance.isRandom = !JKSetting.instance.isRandom;
              if (JKSetting.instance.isRandom) {
                JKSetting.instance.isCycle = false;
                JKSetting.instance.setPlayInfo(0x20);
              } else {
                JKSetting.instance.setPlayInfo(0x00);
              }
              this.setState(() {});
            },
          ),
          Container(
            width: 50,
          ),
          TextButton(
            child: Image.asset(
              JKImage.icon_play_cycle,
              color: color2,
              height: 22,
              width: 22,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              JKSetting.instance.isCycle = !JKSetting.instance.isCycle;
              if (JKSetting.instance.isCycle) {
                JKSetting.instance.isRandom = false;
                JKSetting.instance.setPlayInfo(0x10);
              } else {
                JKSetting.instance.setPlayInfo(0x00);
              }
              this.setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget initVoiceView() {
    return Container(
      height: 50,
      width: this.px * 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_voice_small,
                fit: BoxFit.fill,
              ),
              onPressed: null,
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbColor: Color(0xFFF01140),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Color(0xff666666),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: JKSetting.instance.volume,
                  min: 0,
                  max: 62,
                  onChanged: (value) {
                    JKSetting.instance.setVolume(value.toInt());
                    this.setState(() {});
                  },
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_voice_big,
                fit: BoxFit.fill,
              ),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }

  // ['SUB', 'EON', 'TA', 'AF']
  bool isStateChecked(String state) {
    if (state == S.current.SUB) {
      return JKSetting.instance.isSub;
    }
    switch (state) {
      case "EON":
        return JKSetting.instance.isEon;
      case "TA":
        return JKSetting.instance.isTa;
      case "AF":
        return JKSetting.instance.isAf;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    JKSetting.instance.mode = 0;
  }
}
