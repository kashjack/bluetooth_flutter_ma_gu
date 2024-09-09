/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2021-01-04 18:40:19
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-08-29 16:27:31
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

class BtPage extends BaseWidget {
  BaseWidgetState<BaseWidget> getState() => _BtPageState();
}

class _BtPageState extends BaseWidgetState<BtPage> {
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
    return Column(
      children: [
        this.initTopView(S.current.BT_Music),
        this.initTopButtonView(),
        this.initTypeButtonView(),
        this.initVoiceView(),
        this.initContentView(),
        this.initControlView(),
      ],
    );
  }

  Widget buildHorizontalLayout() {
    return Stack(children: [
      this.initHorizontalContentView(),
      Column(
        children: [
          this.initTopView(S.current.BT_Music),
          this.initTopButtonView(),
          this.initTypeButtonView(),
          this.initVoiceView(),
          this.initControlView(),
        ],
      ),
    ]);
  }

  void initData() {
    JKBluetooth.instance.stateCallback = (value) {
      if (value == "bt") {
        controlBtnList[0] = JKSetting.instance.isBtMusicMute
            ? JKImage.icon_radio_mute
            : JKImage.icon_radio_voice;
        controlBtnList[2] = JKSetting.instance.isBtMusicPlay
            ? JKImage.icon_play_pause
            : JKImage.icon_play_play;
      }
      setState(() {});
    };
    JKSetting.instance.getMusic();
    JKSetting.instance.getVolume();
  }

  Widget initTopButtonView() {
    if (this.topBtnList.length == 2) {
      this.topBtnList.removeLast();
    }
    String eqType = JKSetting.instance.eqModes[JKSetting.instance.nowEQMode];
    this.topBtnList.add(eqType);
    return Container(
      height: 50,
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
      height: 50,
      width: px(350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: this.typeBtnList.map((string) {
          return Container(
            width: px(100),
            height: 30,
            child: TextButton(
              child: Text(
                string,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff8b8b8b),
                  fontFamily: 'Mont',
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
                JKSetting.instance.setMusic(0);
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

  Widget initControlView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: isPortrait
          ? EdgeInsets.zero
          : EdgeInsets.only(top: JKSize.instance.px * 60),
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
                      Container(
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
                          onPressed: () {
                            switch (index) {
                              case 0:
                                JKSetting.instance.isBtMusicMute =
                                    !JKSetting.instance.isBtMusicMute;
                                JKSetting.instance.setMusic(0x00);
                                break;
                              case 1: //last
                                JKSetting.instance.setMusic(0x02);
                                break;
                              case 2: //pause
                                JKSetting.instance.isBtMusicPlay =
                                    !JKSetting.instance.isBtMusicPlay;
                                JKSetting.instance.setMusic(
                                    JKSetting.instance.isBtMusicPlay
                                        ? 0x01
                                        : 0x00);
                                setState(() {});
                                break;
                              case 3: //next
                                JKSetting.instance.setMusic(0x04);
                                break;
                              case 4: //setting
                                this.push(FabaPage());
                                break;
                              default:
                                break;
                            }
                          },
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

  Widget initVoiceView() {
    return Container(
      height: 50,
      margin: isPortrait
          ? EdgeInsets.only(left: 10, right: 10)
          : EdgeInsets.only(
              left: JKSize.instance.px * 200, right: JKSize.instance.px * 200),
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
    JKSetting.instance.mode = 0;
    super.dispose();
  }
}
