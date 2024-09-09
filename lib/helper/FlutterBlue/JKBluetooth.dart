import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/bt/BTPage.dart';
import 'package:flutter_app/pages/caraux/CarAuxPage.dart';
import 'package:flutter_app/pages/play/PlayPage.dart';
import 'package:flutter_app/pages/radio/RadioPage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JKSetting.dart';

typedef _CallBack = void Function(String value);

class JKBluetooth {
  JKBluetooth._privateConstructor();

  static final JKBluetooth instance = JKBluetooth._privateConstructor();

  // ignore: cancel_subscriptions
  StreamSubscription<bool>? _subscriptionIsScanning;

  // ignore: cancel_subscriptions
  StreamSubscription<List<int>>? _subscriptionNotice;
  BluetoothDevice? device;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  bool isScanning = false;
  BluetoothCharacteristic? wCharacteristic;
  BluetoothCharacteristic? rCharacteristic;
  _CallBack? stateCallback;
  _CallBack? modeCallback;

  initBle() {
    if (JKBluetooth.instance._subscriptionIsScanning != null) {
      JKBluetooth.instance._subscriptionIsScanning!.cancel();
    }
    JKBluetooth.instance._subscriptionIsScanning =
        JKBluetooth.instance.flutterBlue.isScanning.listen((event) {
      bool isScanning = event;
      JKBluetooth.instance.isScanning = isScanning;
    });
  }

  initModeCallback() {
    modeCallback = (value) {
      if (value == 'disconnect') {
        navigatorKey.currentState!.popUntil(ModalRoute.withName("/"));
        Fluttertoast.showToast(msg: S.current.reconnected_msg);
      } else if (value == 'mode') {
        JKSetting.instance.isModeChange = true;
        if (JKSetting.instance.mode == 1) {
          push(BtPage());
        } else if (JKSetting.instance.mode == 2) {
          push(RadioPage());
        } else if (JKSetting.instance.mode == 3) {
          push(PlayPage());
        } else if (JKSetting.instance.mode == 4) {
          push(PlayPage());
        } else if (JKSetting.instance.mode == 5) {
          push(CarAuxPage());
        }
      }
    };
  }

  push(Widget page) {
    navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => page))
        .then((value) {
      if (value != null && value) {
        // ignore: invalid_use_of_protected_member
        navigatorKey.currentState!.setState(() {});
      }
    });
  }

  static bool isConnect() {
    if (JKBluetooth.instance.device == null) {
      return false;
    }
    return true;
  }

  static Future<void> setNoticeCharacteristic(
      BluetoothCharacteristic characteristic) async {
    JKBluetooth.instance.rCharacteristic = characteristic;
    await characteristic.setNotifyValue(true);

    if (JKBluetooth.instance._subscriptionNotice != null) {
      JKBluetooth.instance._subscriptionNotice!.cancel();
    }
    JKBluetooth.instance._subscriptionNotice = characteristic.value.listen((value) {
      if (value == null || value.length == 0) {
        printLog("我是蓝牙返回数据 - 空！！");
        return;
      }
      if (value.first == 0xff && value.last == 0xfe && value[1] + 3 == value.length) {
        JKBluetooth.instance._parseValue(value);
      } else {
        printLog("$value数据格式不规范！！");
      }
    });
    JKSetting.instance.getMode();
  }

  static void writeData(List<int> data) {
    if (JKBluetooth.isConnect() || kDebugMode) {
      int startCode = 0xff;
      int endCode = 0xfe;
      int lengthCode = data.length + 1;
      int verifyCode = lengthCode;
      for (int item in data) {
        verifyCode += item;
      }
      verifyCode = verifyCode % 256;
      List<int> finalData = [startCode, lengthCode] + data + [verifyCode, endCode];
      printLog("我写了$finalData");
      if (!kDebugMode) {
        JKBluetooth.instance.wCharacteristic!.write(finalData, withoutResponse: true);
      }
    } else {
      Fluttertoast.showToast(msg: S.current.reconnected_msg);
    }
  }

  static void startScan() {
    if (JKBluetooth.instance.isScanning) {
      JKBluetooth.stopScan().then((value) {
        Timer(Duration(milliseconds: 100), () {
          JKBluetooth.instance.isScanning = true;
          JKBluetooth.instance.flutterBlue.startScan();
        });
      });
    } else {
      JKBluetooth.instance.isScanning = true;
      JKBluetooth.instance.flutterBlue.startScan();
    }
    // FlutterBlueTooth.stopScan();
  }

  static Future disConnect() {
    return JKBluetooth.instance.device!.disconnect();
  }

  Stream<List<ScanResult>> scaning() {
    return JKBluetooth.instance.flutterBlue.scanResults;
  }

  static Future stopScan() {
    JKBluetooth.instance.isScanning = false;
    return JKBluetooth.instance.flutterBlue.stopScan();
  }

  Future<List<BluetoothService>> connectDevice(BluetoothDevice device) async {
    await device.connect();
    JKBluetooth.instance.device = device;
    //存储蓝牙id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("blueDeviceId", device.id.toString());
    //监听设备断开
    device.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected) {
        printLog("设备已断开");
        JKBluetooth.instance.device = null;
        if (modeCallback != null) {
          modeCallback!("disconnect");
        }
      }
    });
    return device.discoverServices();
  }

  void _parseValue(List<int> value) {
    printLog("蓝牙接收数据：$value");
    int function = value[2];
    JKSetting.instance.allData.add(value);
    switch (function) {
      case 0x01: // 音量
        JKSetting.instance.volume = value[3].toDouble();
        if (stateCallback != null) {
          stateCallback!('volume');
        }
        break;
      case 0x04: //radio
        var list = value[3].toList();
        JKSetting.instance.isLoud = list[0] == 1;
        JKSetting.instance.isInt = list[1] == 1;
        JKSetting.instance.isDistance = list[2] == 1;
        JKSetting.instance.isStereo = list[3] == 1;
        JKSetting.instance.channelIndex = list[6] * 2 + list[7];
        var list2 = value[4].toList();
        JKSetting.instance.isSub = list2[7] == 1;
        JKSetting.instance.isEon = list2[6] == 1;
        JKSetting.instance.isTa = list2[5] == 1;
        JKSetting.instance.isAf = list2[4] == 1;
        JKSetting.instance.channel = value[5];
        //选中预置台号，好像本地存起来没什么用
        JKSetting.instance.checkedPresetChannel = value[6];
        JKSetting.instance.presetChannels = [
          value[7],
          value[8],
          value[9],
          value[10],
          value[11],
          value[12]
        ];
        JKSetting.instance.presetDecimalChannels = value[13].toList();
        if (stateCallback != null) {
          stateCallback!('radio');
        }
        break;
      case 0x02: //RGB
        JKSetting.instance.isAuto = value[3] != 1;
        if (!JKSetting.instance.isAuto) {
          if (value.length == 7) {
            JKSetting.instance.currentRgbIndex = value[4];
            JKSetting.instance.currentRGB = JKSetting.instance.autoRGBList[value[4] - 1];
          } else {
            JKSetting.instance.currentRgbIndex = 0;
            JKSetting.instance.currentRGB =
                Color.fromARGB(0xFF, value[5], value[6], value[7]);
          }
        }
        if (stateCallback != null) {
          stateCallback!('rgb');
        }
        break;
      case 0x05: //bt
        var list = value[3].toList();
        JKSetting.instance.isBtMusicPlay = list[7] == 1;
        JKSetting.instance.isSub = list[4] == 1;
        JKSetting.instance.isLoud = list[3] == 1;
        JKSetting.instance.isBtMusicMute = list[2] == 1;
        if (stateCallback != null) {
          stateCallback!('bt');
        }
        break;
      case 0x06: //aux
        var list = value[3].toList();
        JKSetting.instance.isAuxMute = list[7] == 1;
        JKSetting.instance.isSub = list[6] == 1;
        JKSetting.instance.isLoud = list[5] == 1;
        if (stateCallback != null) {
          stateCallback!('aux');
        }
        break;
      case 0x07: //usb
      case 0x08: //sd
        int function1 = value[3];
        int function2 = value[4];
        var list1 = function1.toList();
        var list2 = function2.toList();
        JKSetting.instance.isMusicPlay = list1[7] == 1;
        JKSetting.instance.isCycle = list1[3] == 1;
        JKSetting.instance.isRandom = list1[2] == 1;
        JKSetting.instance.isMute = list2[7] == 1;
        JKSetting.instance.isSub = list2[4] == 1;
        JKSetting.instance.isLoud = list2[3] == 1;
        JKSetting.instance.totalMinute = value[5];
        JKSetting.instance.totalSecond = value[6];
        JKSetting.instance.nowMinute = value[7];
        JKSetting.instance.nowSecond = value[8];
        if (stateCallback != null) {
          stateCallback!('play');
        }
        break;
      case 0x09: //EQ
        if (value.length == 6) {
          JKSetting.instance.nowEQMode = value[3];
        } else if (value.length == 8 && value[3] == 0 && value[4] == 0) {
          JKSetting.instance.eqQFactor = value[5];
        } else {
          if (value[3] == 0x01) {
            JKSetting.instance.eqLongDbs
                .setRange(0, 10, List.generate(10, (index) => value[index + 4] - 9));
          } else if (value[3] == 0x02) {
            JKSetting.instance.eqLongDbs
                .setRange(10, 20, List.generate(10, (index) => value[index + 4] - 9));
          }
        }
        if (stateCallback != null) {
          stateCallback!('eq');
        }
        break;
      case 0x10: //BassBoost
        int function = value[3];
        var list = function.toList();
        JKSetting.instance.isSubwoofer = list[0] == 1;
        JKSetting.instance.level = value[3] - (JKSetting.instance.isSubwoofer ? 128 : 0);
        JKSetting.instance.bassBoost = value[4];
        if (stateCallback != null) {
          stateCallback!('bassBoost');
        }
        break;
      case 0x0a: //FA/BA
        JKSetting.instance.faderProgress = value[3] - 15;
        JKSetting.instance.balanceProgress = value[4] - 15;
        if (stateCallback != null) {
          stateCallback!('faba');
        }
        break;
      case 0x0b: //alignment
        //获取前4位数值
        int positionPreFourth = value[4] >> 4;
        JKSetting.instance.is2WAY = positionPreFourth != 2;
        JKSetting.instance.alignmentPosition = value[4] - (positionPreFourth << 4) - 1;
        if (value[3] == 0x01) {
          JKSetting.instance.alignmentSpeaks[0]
            ..cm0 = value[5]
            ..cm1 = value[6]
            ..cm = (value[5] << 8) + value[6]
            ..db = value[7];
          JKSetting.instance.alignmentSpeaks[1]
            ..cm0 = value[8]
            ..cm1 = value[9]
            ..cm = (value[8] << 8) + value[9]
            ..db = value[10];
          JKSetting.instance.alignmentSpeaks[2]
            ..cm0 = value[11]
            ..cm1 = value[12]
            ..cm = (value[11] << 8) + value[12]
            ..db = value[13];
        } else if (value[3] == 0x02) {
          JKSetting.instance.alignmentSpeaks[3]
            ..cm0 = value[5]
            ..cm1 = value[6]
            ..cm = (value[5] << 8) + value[6]
            ..db = value[7];
          JKSetting.instance.alignmentSpeaks[4]
            ..cm0 = value[8]
            ..cm1 = value[9]
            ..cm = (value[8] << 8) + value[9]
            ..db = value[10];
          JKSetting.instance.alignmentSpeaks[5]
            ..cm0 = value[11]
            ..cm1 = value[12]
            ..cm = (value[11] << 8) + value[12]
            ..db = value[13];
        } else if (value[3] == 0x10) {
          JKSetting.instance.alignmentSpeakMss[0]
            ..ms0 = value[5]
            ..ms1 = value[6]
            ..ms = (value[5] << 8) + value[6];
          JKSetting.instance.alignmentSpeakMss[1]
            ..ms0 = value[7]
            ..ms1 = value[8]
            ..ms = (value[7] << 8) + value[8];
          JKSetting.instance.alignmentSpeakMss[2]
            ..ms0 = value[9]
            ..ms1 = value[10]
            ..ms = (value[9] << 8) + value[10];
          JKSetting.instance.alignmentSpeakMss[3]
            ..ms0 = value[11]
            ..ms1 = value[12]
            ..ms = (value[11] << 8) + value[12];
          JKSetting.instance.alignmentSpeakMss[4]
            ..ms0 = value[13]
            ..ms1 = value[14]
            ..ms = (value[13] << 8) + value[14];
          JKSetting.instance.alignmentSpeakMss[5]
            ..ms0 = value[15]
            ..ms1 = value[16]
            ..ms = (value[15] << 8) + value[16];
        }
        if (stateCallback != null) {
          stateCallback!('alignment');
        }
        break;
      case 0x0c:
        if (value[3] == 0x01) {
          JKSetting.instance
            ..aisle = 1
            ..is2WAY = true
            ..frq21 = value[4]
            ..gain = value[5]
            ..gainRight = value[6];
        } else if (value[3] == 0x02) {
          JKSetting.instance
            ..aisle = 2
            ..is2WAY = true
            ..frq22 = value[4]
            ..slope = value[5]
            ..gain = value[6];
        } else if (value[3] == 0x03) {
          JKSetting.instance
            ..aisle = 3
            ..is2WAY = true
            ..frq23 = value[4]
            ..slope = value[5]
            ..gain = value[6];
        } else if (value[3] == 0x04) {
          JKSetting.instance
            ..aisle = 4
            ..is2WAY = true
            ..frq24 = value[4]
            ..slope = value[5]
            ..gain = value[6]
            ..phase = value[7];
        } else if (value[3] == 0x21) {
          JKSetting.instance
            ..aisle = 1
            ..is2WAY = false
            ..frq31 = value[7]
            ..slope = value[8]
            ..gain = value[9]
            ..phase = value[10];
        } else if (value[3] == 0x22) {
          JKSetting.instance
            ..aisle = 2
            ..is2WAY = false
            ..frq321 = value[4]
            ..hSlope = value[5]
            ..frq322 = value[6]
            ..slope = value[7]
            ..gain = value[8]
            ..phase = value[9];
        } else if (value[3] == 0x23) {
          JKSetting.instance
            ..aisle = 3
            ..is2WAY = false
            ..frq33 = value[4]
            ..slope = value[5]
            ..gain = value[6]
            ..phase = value[7];
        }
        if (stateCallback != null) {
          stateCallback!('xover');
        }
        break;
      case 0x0d:
        // 模式
        if (JKSetting.instance.mode != value[3]) {
          JKSetting.instance.mode = value[3];
          if (value[3] == 0x01) {
            JKSetting.instance.musicName = "";
            JKSetting.instance.artistName = "";
            JKSetting.instance.albumName = "";
          }
          if (modeCallback != null) {
            modeCallback!('mode');
          }
        }
        break;
      case 0x33:
        // 模式
        JKSetting.instance.is2WAY = (value[3] == 1);
        if (stateCallback != null) {
          stateCallback!('way');
        }
        break;
      case 0x32:
        //音乐信息
        if (value[3] == 0x01) {
          //歌曲名
          if (value[4] == 0x01) {
            //重置字符串
            JKSetting.instance.musicName = "";
          }
          JKSetting.instance.musicName += value.getRange(5, 17).toList().toAscii();
        } else if (value[3] == 0x02) {
          //艺术家名称
          if (value[4] == 0x01) {
            //重置字符串
            JKSetting.instance.artistName = "";
          }
          JKSetting.instance.artistName += value.getRange(5, 17).toList().toAscii();
        } else if (value[3] == 0x03) {
          //专辑名称
          if (value[4] == 0x01) {
            //重置字符串
            JKSetting.instance.albumName = "";
          }
          JKSetting.instance.albumName += value.getRange(5, 17).toList().toAscii();
        }
        if (stateCallback != null) {
          stateCallback!('music');
        }
        break;
    }
  }
}
