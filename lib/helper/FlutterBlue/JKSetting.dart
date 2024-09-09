/*
 * @Author: your name
 * @Date: 2021-06-29 12:27:40
 * @LastEditTime: 2022-08-29 14:47:51
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/helper/FlutterBlue/JKSetting.dart
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/bean/AlignmentBean.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'JKBluetooth.dart';

class JKSetting {
  JKSetting._privateConstructor();

  static final JKSetting instance = JKSetting._privateConstructor();

  final int writeDuration = 100; //写数据延时

  List<List<int>> allData = [];

  bool isModeChange = false;
  int mode = 0; // 功能页mode包括BT(0x01),RADIO(0x02),USB(0x03),SD(0x04),AUX(0x05)
  double volume = 0; // 音量
  int channel = 0; // 频道

  var channelPages = ["FM1", "FM2", "FM3"]; //频道页数组
  int channelIndex = 1;
  int checkedPresetChannel = 0; //选中的预置频道号
  List<int> presetChannels = [0, 0, 0, 0, 0, 0]; //6个预置频道
  List<int> presetDecimalChannels = [0, 0, 0, 0, 0, 0, 0, 0]; //6个预置频道
  bool isAuto = true;
  int currentRgbIndex = 0; //当七个颜色选项之一才!=0
  List<Color> autoRGBList = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.white
  ]; //七个自动模式下的颜色
  Color currentRGB = Colors.blue; //当前颜色
  int faderProgress = 0; //faba下的fader进度
  int balanceProgress = 0; //faba下的balance进度

  int nowEQMode = 0;
  List<String> eqModes = [
    S.current.CUSTOM,
    S.current.ROCK,
    S.current.POP,
    S.current.JAZZ,
    S.current.FLAT,
  ];
  List<int> eqLongDbs = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ]; //eq下的20个长格式频率值
  int eqQFactor = 1;
  bool isSettingEQQFactorMode = false;
  bool isSettingVolume = false;
  bool isSettingChannel = false;
  bool isSettingRGB = false;
  bool isSettingEQ = false;
  bool isSettingEQMode = false;
  bool isSettingFABA = false;
  bool isSettingPlay = false;
  bool isSettingMusic = false;
  bool isSettingAux = false;
  bool isSettingAlignment = false;
  bool isResetting = false;
  bool isSettingPlayTime = false;
  bool isSettingBassBoost = false;

  bool isSubwoofer = false;
  int level = 0;
  int bassBoost = 0;

  int totalMinute = 0; //play页面总时间分钟
  int totalSecond = 0; //play页面总时间秒
  int nowMinute = 0; //play页面当前播放时间分钟
  int nowSecond = 0; //play页面当前播放时间秒
  bool isMusicPlay = false; //play页面音乐播放状态
  bool isCycle = false; // 是否循环
  bool isRandom = false; //是否随机
  bool isMute = false; //是否静音
  int aisle = 1; // tweeter 01 mid rang 02 woofer 03
  int frq21 = 0; //
  int frq22 = 0; //
  int frq23 = 0; //
  int frq24 = 0; //
  int frq31 = 0; //
  int frq321 = 0; //
  int frq322 = 0; //
  int frq33 = 0; //
  int hSlope = 0;
  int slope = 0;
  int gain = 0;
  int gainRight = 0;
  int phase = 0;

  bool isBtMusicPlay = false; //蓝牙音乐页面音乐播放状态
  bool isBtMusicMute = false; //蓝牙音乐页面是否静音

  bool isAuxMute = false; //是否aux静音

  int alignmentPosition = 0;
  List<String> alignmentModes = [
    S.current.ALL,
    S.current.FRONT + ' ' + S.current.LEFT,
    S.current.FRONT + ' ' + S.current.RIGHT,
    S.current.FRONT + ' ' + S.current.ALL
  ];
  List<AlignmentSpeakItem> alignmentSpeaks = [
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //前左喇叭
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //前右喇叭
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //后左喇叭
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //后右喇叭
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //低音左喇叭
    AlignmentSpeakItem(cm0: 0, cm1: 0, cm: 0, db: 0), //低音右喇叭
  ];

  List<AlignmentSpeakMSItem> alignmentSpeakMss = [
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //前左喇叭
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //前右喇叭
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //后左喇叭
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //后右喇叭
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //低音左喇叭
    AlignmentSpeakMSItem(ms0: 0, ms1: 0, ms: 0), //低音右喇叭
  ];
  int cmMin = 0;
  int cmMax = 850;
  int dbMin = 0;
  int dbMax = 8;

  //状态显示
  bool isSub = false;
  bool isEon = false;
  bool isTa = false;
  bool isAf = false;

  //控制mcu
  bool isLoud = false;
  bool isInt = false;
  bool isStereo = false; //是否立体声
  bool isDistance = false; //是否远程

  bool is2WAY = true;

  String musicName = "";
  String artistName = "";
  String albumName = "";

  Future delayed(VoidCallback voidCallback) {
    return Future.delayed(Duration(milliseconds: writeDuration), voidCallback);
  }

  // 获取当前音量
  Future getVolume() {
    return delayed(() {
      JKBluetooth.writeData([0xa1]);
    });
  }

  // 设置当前音量
  void setVolume(int volume) {
    if (JKSetting.instance.volume != volume) {
      JKSetting.instance.volume = volume.toDouble();
      if (!isSettingVolume) {
        //没有正在设置音量，就启动一个延时future写数据，正在设置音量就只记录最新的音量值
        isSettingVolume = true;
        delayed(() {
          JKBluetooth.writeData([0x01, JKSetting.instance.volume.toInt()]);
          isSettingVolume = false;
        });
      }
    }
  }

  // 获取当前功能模式
  void getMode() {
    JKBluetooth.writeData([0xad]);
  }

  //设置功能模式
  void setMode(int mode) {
    JKBluetooth.writeData([0x0d, mode]);
  }

  // 获取当前Way
  void getWay() {
    JKBluetooth.writeData([0xaf]);
  }

  //设置功当前Way
  void setWay() {
    JKBluetooth.writeData([0x33, JKSetting.instance.is2WAY ? 1 : 2]);
  }

  // 获取当前radio
  Future getRadioInfo() {
    return delayed(() {
      JKBluetooth.writeData([0xa4]);
    });
  }

  // 设置频道 type 0设置 1向上搜索 2向下搜索  presetChannel设置预置台 1-6  0x20step up  0x30step down
  void setChannel(int type, {int presetChannel = 0}) {
    List<int> list = [
      isLoud ? 1 : 0,
      isInt ? 1 : 0,
      isDistance ? 1 : 0,
      isStereo ? 1 : 0,
      type == 2 ? 1 : 0,
      type == 1 ? 1 : 0,
      channelIndex ~/ 2,
      channelIndex % 2
    ];
    List<int> list2 = [
      0,
      0,
      0,
      0,
      isAf ? 1 : 0,
      isTa ? 1 : 0,
      isEon ? 1 : 0,
      isSub ? 1 : 0,
    ];
    if (!isSettingChannel) {
      isSettingChannel = true;
      delayed(() {
        JKBluetooth.writeData([
          0x04,
          list.toInt(),
          list2.toInt(),
          channel,
          presetChannel,
          presetChannels[0],
          presetChannels[1],
          presetChannels[2],
          presetChannels[3],
          presetChannels[4],
          presetChannels[5],
          this.presetDecimalChannels.toInt(),
        ]);
        isSettingChannel = false;
      });
    }
  }

  //获取颜色
  Future getRGB() {
    return delayed(() {
      JKBluetooth.writeData([0xa2]);
    });
  }

  //设置颜色 isCheck是否是选择
  void setRGB() {
    if (isAuto) {
      JKBluetooth.writeData([
        0x02,
        0x02,
      ]);
    } else {
      if (!isSettingRGB) {
        isSettingRGB = true;
        delayed(() {
          if (currentRgbIndex == 0) {
            JKBluetooth.writeData([
              0x02,
              0x01,
              currentRGB.red,
              currentRGB.green,
              currentRGB.blue
            ]);
          } else {
            JKBluetooth.writeData([0x02, 0x01, currentRgbIndex]);
          }
          isSettingRGB = false;
        });
      }
    }
  }

  //获取音乐
  Future getMusic() {
    return delayed(() {
      JKBluetooth.writeData([0xa5]);
    });
  }

  void setMusic(int function) {
    if (!isSettingMusic) {
      isSettingMusic = true;
      delayed(() {
        List<int> list = [
          0,
          0,
          isBtMusicMute ? 1 : 0,
          isLoud ? 1 : 0,
          isSub ? 1 : 0,
          function == 4 ? 1 : 0,
          function == 2 ? 1 : 0,
          isBtMusicPlay ? 1 : 0,
        ];
        JKBluetooth.writeData([0x05, list.toInt()]);
        isSettingMusic = false;
      });
    }
  }

  //获取aux信息
  Future getAux() {
    return delayed(() {
      JKBluetooth.writeData([0xa6]);
    });
  }

  // 设置当前aux音量
  void setAux() {
    if (!isSettingAux) {
      isSettingAux = true;
      delayed(() {
        List<int> list = [
          0,
          0,
          0,
          0,
          0,
          isLoud ? 1 : 0,
          isSub ? 1 : 0,
          isAuxMute ? 1 : 0,
        ];
        JKBluetooth.writeData([0x06, list.toInt()]);
        isSettingAux = false;
      });
    }
  }

  //获取play页信息
  Future? getPlayInfo() {
    if (mode == 3) {
      //usb
      return delayed(() {
        JKBluetooth.writeData([0xa7, 0x00]);
      });
    } else if (mode == 4) {
      //sd
      return delayed(() {
        JKBluetooth.writeData([0xa8, 0x00]);
      });
    } else {
      return null;
    }
  }

  //设置play页信息
  void setPlayInfo(int function1, {int function2 = 0}) {
    if (!isSettingPlay) {
      isSettingPlay = true;
      delayed(() {
        List<int> datas = [];
        if (mode == 3) {
          datas.add(0x07);
        } else if (mode == 4) {
          datas.add(0x08);
        }
        List<int> list1 = [
          0,
          0,
          isRandom ? 1 : 0,
          isCycle ? 1 : 0,
          function1 == 8 ? 1 : 0,
          function1 == 4 ? 1 : 0,
          isMusicPlay ? 0 : 1,
          isMusicPlay ? 1 : 0,
        ];
        List<int> list2 = [
          0,
          0,
          0,
          isLoud ? 1 : 0,
          isSub ? 1 : 0,
          function2 == 4 ? 1 : 0,
          function2 == 2 ? 1 : 0,
          isMute ? 1 : 0
        ];
        datas.addAll([
          list1.toInt(),
          list2.toInt(),
          totalMinute,
          totalSecond,
          nowMinute,
          nowSecond
        ]);
        JKBluetooth.writeData(datas);
        isSettingPlay = false;
      });
    }
  }

  //获取EQ信息
  Future getEQInfo(bool isLong) {
    return delayed(() {
      JKBluetooth.writeData([0xa9, isLong ? 0x02 : 0x01]);
    });
  }

  //设置eq数据
  void setEQInfo() {
    if (!isSettingEQ) {
      isSettingEQ = true;
      delayed(() {
        List<int> datas1 = [0x09, 0x01];
        datas1.addAll(
            eqLongDbs.getRange(0, 10).map((value) => value + 9).toList());
        JKBluetooth.writeData(datas1);
      }).then((value) => delayed(() {
            List<int> datas2 = [0x09, 0x02];
            datas2.addAll(
                eqLongDbs.getRange(10, 20).map((value) => value + 9).toList());
            JKBluetooth.writeData(datas2);
            isSettingEQ = false;
          }));
    }
  }

  void setEQQFactor() {
    if (!isSettingEQQFactorMode) {
      isSettingEQQFactorMode = true;
      delayed(() {
        JKBluetooth.writeData([0x09, 0x00, 0x00, eqQFactor]);
        isSettingEQQFactorMode = false;
      });
    }
  }

  //设置eq模式
  void setEQMode() {
    if (!isSettingEQMode) {
      isSettingEQMode = true;
      delayed(() {
        JKBluetooth.writeData([0x09, nowEQMode]);
        isSettingEQMode = false;
      });
    }
  }

  // 获取BassBoost
  Future getBassBoostInfo() {
    return delayed(() {
      JKBluetooth.writeData([
        0xb0,
      ]);
    });
  }

  void setBassBoostInfo() {
    int subwoofer = (isSubwoofer ? 128 : 0) + level;
    if (!isSettingBassBoost) {
      isSettingBassBoost = true;
      delayed(() {
        JKBluetooth.writeData([0x10, subwoofer, bassBoost]);
        isSettingBassBoost = false;
      });
    }
  }

  //获取FA/BA
  Future getFABAInfo() {
    return delayed(() {
      JKBluetooth.writeData([
        0xaa,
      ]);
    });
  }

  void changeFABA() {
    if (!isSettingFABA) {
      isSettingFABA = true;
      delayed(() {
        JKBluetooth.writeData([0x0a, faderProgress + 15, balanceProgress + 15]);
        isSettingFABA = false;
      });
    }
  }

  //获取Alignment
  Future getAlignmentInfo() {
    return delayed(() {
      JKBluetooth.writeData([0xab]);
    });
  }

  //设置Alignment
  void setAlignmentInfo() {
    if (!isSettingAlignment) {
      isSettingAlignment = true;
      delayed(() {
        int positionPre = is2WAY ? 1 : 2;
        JKBluetooth.writeData([
          0x0b,
          0x01,
          (positionPre << 4) + alignmentPosition + 1,
          alignmentSpeaks[0].cm0,
          alignmentSpeaks[0].cm1,
          alignmentSpeaks[0].db,
          alignmentSpeaks[1].cm0,
          alignmentSpeaks[1].cm1,
          alignmentSpeaks[1].db,
          alignmentSpeaks[2].cm0,
          alignmentSpeaks[2].cm1,
          alignmentSpeaks[2].db,
        ]);
      }).then((value) => delayed(() {
            int positionPre = is2WAY ? 1 : 2;
            JKBluetooth.writeData([
              0x0b,
              0x02,
              (positionPre << 4) + alignmentPosition + 1,
              alignmentSpeaks[3].cm0,
              alignmentSpeaks[3].cm1,
              alignmentSpeaks[3].db,
              alignmentSpeaks[4].cm0,
              alignmentSpeaks[4].cm1,
              alignmentSpeaks[4].db,
              alignmentSpeaks[5].cm0,
              alignmentSpeaks[5].cm1,
              alignmentSpeaks[5].db,
            ]);
            isSettingAlignment = false;
          }));
    }
  }

  //获取X OVER信息
  Future getXOverInfo() {
    return delayed(() {
      JKBluetooth.writeData([0xac, JKSetting.instance.aisle]);
    });
  }

  // 设置XOVER
  void setXOverInfo() {
    if (JKSetting.instance.is2WAY) {
      if (JKSetting.instance.aisle == 1) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x01,
            JKSetting.instance.frq21,
            JKSetting.instance.gain,
            JKSetting.instance.gainRight,
          ]);
        });
      } else if (JKSetting.instance.aisle == 2) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x02,
            JKSetting.instance.frq22,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
          ]);
        });
      } else if (JKSetting.instance.aisle == 3) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x03,
            JKSetting.instance.frq23,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
            JKSetting.instance.phase
          ]);
        });
      } else if (JKSetting.instance.aisle == 4) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x04,
            JKSetting.instance.frq24,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
            JKSetting.instance.phase
          ]);
        });
      }
    } else {
      if (JKSetting.instance.aisle == 1) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x21,
            0x00,
            0x00,
            0x00,
            JKSetting.instance.frq31,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
            JKSetting.instance.phase
          ]);
        });
      } else if (JKSetting.instance.aisle == 2) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x22,
            JKSetting.instance.frq321,
            JKSetting.instance.hSlope,
            JKSetting.instance.frq322,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
            JKSetting.instance.phase
          ]);
        });
      } else if (JKSetting.instance.aisle == 3) {
        delayed(() {
          JKBluetooth.writeData([
            0x0c,
            0x23,
            JKSetting.instance.frq33,
            JKSetting.instance.slope,
            JKSetting.instance.gain,
            JKSetting.instance.phase
          ]);
        });
      }
    }
  }

  //复位
  void reset(int mode) {
    if (!isResetting) {
      isResetting = true;
      delayed(() {
        JKBluetooth.writeData([0x0e, mode]);
        isResetting = false;
      });
    }
  }

  //修改播放时间点
  void changePlayTime() {
    if (!isSettingPlayTime) {
      isSettingPlayTime = true;
      delayed(() {
        JKBluetooth.writeData([0x0f, nowMinute, nowSecond]);
        isSettingPlayTime = false;
      });
    }
  }
}
