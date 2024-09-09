/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-11-09 12:04:50
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/radio/widget/RadioSliderController.dart';
import 'package:flutter_app/pages/set/faba/FabaPage.dart';
import 'package:flutter_app/route/BasePage.dart';

class RadioPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _RadioPageState();
}

class _RadioPageState extends BaseWidgetState<RadioPage> {
  List<String> topBtnList = [S.current.SUB, 'EON', 'TA', 'AF'];
  List<String> sliderUpTips = ['90', '93', '96', '98', '100', '105'];
  List<String> sliderDownTips = ['500', '750', '1000', '1250', '1560'];
  double value = 0;
  GlobalKey<RadioSliderControllerState> radioSliderKey = GlobalKey();

  initData() {
    JKBluetooth.instance.stateCallback = (value) {
      if (value == "radio") {
        radioSliderKey.currentState!.reloadProgress(JKSetting.instance.channel);
      }
      this.setState(() {});
    };
    JKSetting.instance.getVolume().then((value) {
      return JKSetting.instance.getRadioInfo();
    });
  }

  Widget buildVerticalLayout() {
    return Column(
      children: [
        this.initTopView(S.current.Radio),
        this.initTopButtonView(),
        this.initVoiceView(),
        this.initTypeButtonView(),
        this.buildVerticalBottomLayout(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Column(
      children: [
        this.initTopView(S.current.Radio),
        this.initTopButtonView(),
        this.initVoiceView(),
        this.initTypeButtonView(),
        this.buildHorizontalBottomLayout(),
      ],
    );
  }

  Widget initTopButtonView() {
    if (this.topBtnList.length == 5) {
      this.topBtnList.removeLast();
    }
    String eqType = JKSetting.instance.eqModes[JKSetting.instance.nowEQMode];
    this.topBtnList.add(eqType);
    return Container(
      height: isPortrait ? px(50) : px(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.topBtnList.map((string) {
          return Container(
            alignment: Alignment.center,
            width: 63,
            child: InkWell(
              onTap: () {
                if (string == S.current.SUB) {
                  JKSetting.instance.isSub = !JKSetting.instance.isSub;
                }
                switch (string) {
                  case "EON":
                    JKSetting.instance.isEon = !JKSetting.instance.isEon;
                    break;
                  case "TA":
                    JKSetting.instance.isTa = !JKSetting.instance.isTa;
                    break;
                  case "AF":
                    JKSetting.instance.isAf = !JKSetting.instance.isAf;
                    break;
                }
                JKSetting.instance.setChannel(0);
                setState(() {});
              },
              child: Text(
                string,
                style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 14,
                  color:
                      isStateChecked(string) ? Colors.white : Color(0xff8b8b8b),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget initVoiceView() {
    return Container(
      height: isPortrait ? px(50) : px(40),
      width: JKSize.instance.width - px(20),
      // height: isPortrait ? this.px * 50 : this.px * 40,
      // width: this.px * 375 - 20,
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
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              onPressed: null,
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbColor: Color(0xFFF01140),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Color(0xff666666),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
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
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              onPressed: null,
            ),
          ),
          Container(
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                JKImage.icon_radio_setting,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                this.push(FabaPage());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget initTypeButtonView() {
    return Container(
      width: this.px * 375 - 20,
      margin: EdgeInsets.only(top: isPortrait ? this.px * 10 : 0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              width: 75 * this.px,
              height: 30,
              child: TextButton(
                child: Text(
                  S.current.STEREO,
                  style: TextStyle(
                    fontFamily: 'Mont',
                    fontSize: 14,
                    color: Color(0xff8b8b8b),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1,
                      color: JKSetting.instance.isStereo
                          ? Colors.red
                          : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  JKSetting.instance.isStereo = !JKSetting.instance.isStereo;
                  JKSetting.instance.setChannel(0);
                },
              ),
            ),
            Container(
              width: 75 * this.px,
              height: 30,
              child: TextButton(
                child: Text(
                  S.current.BAND,
                  style: TextStyle(
                    fontFamily: 'Mont',
                    fontSize: 14,
                    color: Color(0xff8b8b8b),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1,
                      color: JKSetting.instance.isDistance
                          ? Colors.red
                          : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // 切换FM
                  JKSetting.instance.channelIndex =
                      JKSetting.instance.channelIndex % 3 + 1;
                  JKSetting.instance.setChannel(0);
                  this.setState(() {});
                },
              ),
            ),
            Container(
              width: 75 * this.px,
              height: 30,
              child: TextButton(
                child: Text(
                  S.current.INT,
                  style: TextStyle(
                    fontFamily: 'Mont',
                    fontSize: 14,
                    color: Color(0xff8b8b8b),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1,
                      color:
                          JKSetting.instance.isInt ? Colors.red : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  JKSetting.instance.isInt = !JKSetting.instance.isInt;
                  JKSetting.instance.setChannel(0);
                },
              ),
            ),
            Container(
              width: 75 * this.px,
              height: 30,
              child: TextButton(
                child: Text(
                  S.current.LOUD,
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
                          ? Colors.red
                          : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  JKSetting.instance.isLoud = !JKSetting.instance.isLoud;
                  JKSetting.instance.setChannel(0);
                },
              ),
            )
          ]),
        ],
      ),
    );
  }

  Widget buildVerticalBottomLayout() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          this.initChannelView(),
          RadioSliderController(
            key: radioSliderKey,
            min: 0,
            max: 204,
            progress: JKSetting.instance.channel,
            graduateCount: 34,
            upTips: sliderUpTips,
            downTips: sliderDownTips,
            controlCallBack: (isAdd, value) {
              JKSetting.instance.setChannel(isAdd ? 1 : 2);
            },
            longControlCallBack: (isAdd, value) {
              if (value == 0) {
                //长按开始
                JKSetting.instance
                    .setChannel(0, presetChannel: isAdd ? 0x20 : 0x30);
              } else {
                //长按结束不需要发
                // JKSetting.instance.setChannel(0, presetChannel: 0);
              }
            },
          ),
          this.initChannelButtonView(),
        ],
      ),
    );
  }

  Widget buildHorizontalBottomLayout() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: px(350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  this.initChannelView(),
                  Container(
                    height: JKSize.instance.px * 100,
                    child: RadioSliderController(
                      key: radioSliderKey,
                      min: 0,
                      max: 204,
                      progress: JKSetting.instance.channel,
                      graduateCount: 34,
                      upTips: sliderUpTips,
                      downTips: sliderDownTips,
                      controlCallBack: (isAdd, value) {
                        JKSetting.instance.setChannel(isAdd ? 1 : 2);
                      },
                      longControlCallBack: (isAdd, value) {
                        if (value == 0) {
                          //长按开始
                          JKSetting.instance.setChannel(0,
                              presetChannel: isAdd ? 0x20 : 0x30);
                        } else {
                          //长按结束不需要发
                          // JKSetting.instance.setChannel(0, presetChannel: 0);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            this.initChannelButtonView(),
          ],
        ),
      ),
    );
  }

  Widget initChannelView() {
    return Container(
      height: isPortrait ? 80 : 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 80,
            height: 60,
            child: TextButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${JKSetting.instance.channelPages[JKSetting.instance.channelIndex - 1]}',
                    style: TextStyle(
                      fontFamily: 'Mont',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Image.asset(
                    JKImage.icon_radio_channel,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              onPressed: () {
                //新需求说不能切换
                // JKSetting.instance.channelIndex =
                //     JKSetting.instance.channelIndex % 3 + 1;
                // JKSetting.instance.setChannel(0);
                // this.setState(() {});
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              this.getChannelStr(JKSetting.instance.channel, 0),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                  fontFamily: 'Mont',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 80,
            height: 50,
            alignment: Alignment.bottomLeft,
            child: Text(
              'MHZ',
              style: TextStyle(
                fontFamily: 'Mont',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initChannelButtonView() {
    return Container(
      width: px(300),
      height: px(200),
      margin: EdgeInsets.only(top: isPortrait ? 0 : 20),
      child: Wrap(
        direction: Axis.vertical,
        spacing: px(10),
        runSpacing: px(10),
        children: JKSetting.instance.presetChannels
            .asMap()
            .map((index, channel) => MapEntry(
                index,
                Container(
                  alignment: Alignment.center,
                  width: 150 * this.px,
                  height: 50 * this.px,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 17,
                            color: Color(0xFF777777),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Text(
                          this.getChannelStr(channel, 7 - index),
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontFamily: 'Mont',
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      //设置当前频道为此频道
                      JKSetting.instance.channel = channel;
                      JKSetting.instance.presetDecimalChannels[0] =
                          JKSetting.instance.presetDecimalChannels[7 - index];
                      JKSetting.instance
                          .setChannel(0, presetChannel: index + 1);
                    },
                    onLongPress: () {
                      //设置此频道为当前频道
                      JKSetting.instance.presetChannels[index] =
                          JKSetting.instance.channel;
                      JKSetting.instance.presetDecimalChannels[7 - index] =
                          JKSetting.instance.presetDecimalChannels[0];
                      JKSetting.instance
                          .setChannel(0, presetChannel: 0x10 | (index + 1));
                    },
                  ),
                )))
            .values
            .toList(),
      ),
    );
  }

  String getChannelStr(int channelInt, int index) {
    double decimal = JKSetting.instance.presetDecimalChannels[index] * 0.05;
    return "${((channelInt * 0.1) + 87.50 + decimal).toStringAsFixed(2)}";
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
    JKBluetooth.instance.stateCallback = null;
    JKSetting.instance.mode = 0;
  }
}
