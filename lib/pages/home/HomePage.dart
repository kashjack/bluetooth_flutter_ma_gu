import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/android_back_desktop.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/FlutterBlue/JKBluetooth.dart';
import 'package:flutter_app/helper/FlutterBlue/JKSetting.dart';
import 'package:flutter_app/helper/config/config.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/bt/BTPage.dart';
import 'package:flutter_app/pages/caraux/CarAuxPage.dart';
import 'package:flutter_app/pages/connect/ConnectPage.dart';
import 'package:flutter_app/pages/gps/GPSPage.dart';
import 'package:flutter_app/pages/home/widget/Swiper.dart';
import 'package:flutter_app/pages/play/PlayPage.dart';
import 'package:flutter_app/pages/radio/RadioPage.dart';
import 'package:flutter_app/pages/rgb/RGBPage.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends BaseWidget with WidgetsBindingObserver {
  @override
  BaseWidgetState<BaseWidget> getState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState<HomePage> {
  List<String> imageArr = [
    JKImage.icon_bt,
    JKImage.icon_aux,
    JKImage.icon_usb,
    JKImage.icon_sd,
    JKImage.icon_radio,
    JKImage.icon_rgb,
    JKImage.icon_gps,
  ];

  List<String> descArr = [
    S.current.BT_Music,
    S.current.AUX,
    S.current.USB,
    S.current.SD_Card,
    S.current.Radio,
    S.current.RGB,
    S.current.GPS
  ];

  List<Widget> pageArr = [
    BtPage(),
    CarAuxPage(),
    PlayPage(),
    PlayPage(),
    RadioPage(),
    RGBPage(),
    GPSPage(),
  ];

  int index = 0;

  bool isPlayed = false;
  int count = 5;
  String version = '';

  // late VideoPlayerController? _controller;
  GlobalKey<SwiperState> swiperKey = GlobalKey();
  // ignore: cancel_subscriptions
  StreamSubscription<List<ScanResult>>? scanSubscription;
  bool triedConnect = false;

  // didChangeAppLifecycleState

  initData() {
    super.initData();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      this.version = packageInfo.version;
      this.setState(() {});
    });
    JKBluetooth.instance.initModeCallback();
  }

  @override
  Widget build(BuildContext context) {
    this.setParameters();
    int quarterTurns = JKSize.instance.isPortrait ? 0 : 3;
    return Scaffold(
      // appBar: appBarWidget, //顶部导航栏
      endDrawer: endDrawerWidget, //右滑菜单栏
      body: Platform.isIOS
          ? this._buildContentView()
          : WillPopScope(
              onWillPop: () async {
                AndroidBackTop.backDeskTop(); //设置为返回不退出app
                return false; //一定要return false
              },
              child: this._buildContentView(),
            ),
    );
  }

  Widget _buildContentView() {
    return Stack(
      children: [
        Container(
          child: Image.asset(
            JKImage.icon_bg,
            fit: BoxFit.cover,
            width: JKSize.instance.width,
            height: JKSize.instance.height,
          ),
        ),
        this._buildBodyLayout(),
      ],
    );
  }

  Widget _buildBodyLayout() {
    return Container(
      height: JKSize.instance.height,
      width: JKSize.instance.width,
      margin: EdgeInsets.only(
        top: max(JKSize.instance.top, 30),
        bottom: JKSize.instance.bottom,
        left: max(JKSize.instance.left, JKSize.instance.right),
        right: max(JKSize.instance.left, JKSize.instance.right),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.blue,
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            child: this.buildTopView(),
          ),
          Container(
            child: Column(
              children: [
                this.buildSwiperView(),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        this.descArr[this.index],
                        style: TextStyle(
                          color: JKColor.main,
                          fontSize: 28,
                          fontFamily: 'Mont',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'v ' + this.version,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Mont',
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                JKImage.icon_logo,
                height: 23,
                fit: BoxFit.contain,
              ),
              Container(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      // Spacer(),
                      Text(
                        S.current.Connect,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Mont',
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    this.push(ConnectPage());
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildSwiperView() {
    return Container(
      height: 200,
      child: Swiper(
        key: swiperKey,
        images: this.imageArr,
        viewportFraction: 0.4,
        initialPage: this.index,
        onTapCallBack: (int pageIndex) async {
          if (pageIndex == 6) {
            if (Platform.isIOS) {
              this.push(this.pageArr[pageIndex]);
            } else {
              if (await canLaunchUrlString('geo:0,0')) {
                await launchUrlString('geo:0,0');
              } else {
                Fluttertoast.showToast(msg: 'Could not launch maps');
              }
            }
            return;
          }
          if (kDebugMode) {
            this.push(this.pageArr[pageIndex]);
            return;
          }
          if (JKBluetooth.isConnect()) {
            switch (pageIndex) {
              case 0:
                JKSetting.instance.setMode(1);
                break;
              case 1:
                JKSetting.instance.setMode(5);
                break;
              case 2:
                JKSetting.instance.setMode(3);
                break;
              case 3:
                JKSetting.instance.setMode(4);
                break;
              case 4:
                JKSetting.instance.setMode(2);
                break;
              default:
                this.push(this.pageArr[pageIndex]);
                break;
            }
          } else {
            Fluttertoast.showToast(msg: S.current.reconnected_msg);
          }
        },
        onSwitchPageIndexCallBack: (int pageIndex) {
          this.setState(() {
            this.index = pageIndex;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPopNext() {
    if (JKSetting.instance.isModeChange) {
      JKSetting.instance.isModeChange = false;
      switch (JKSetting.instance.mode) {
        case 1:
          index = 0;
          break;
        case 2:
          index = 4;
          break;
        case 3:
          index = 2;
          break;
        case 4:
          index = 3;
          break;
        case 5:
          index = 1;
          break;
      }
    }
    swiperKey.currentState!.pageTo(this.index);
    super.didPopNext();
  }

  Future<void> connect() async {
    EasyLoading.show(status: 'connect...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("blueDeviceId") != null) {
      JKBluetooth.instance.initBle();
      JKBluetooth.instance.isScanning = true;
      JKBluetooth.instance.flutterBlue.startScan();
      JKBluetooth.instance.scaning().listen(
        (results) {
          // 扫描结果 可扫描到的所有蓝牙设备
          for (ScanResult result in results) {
            if (result.device.name.length > 0 &&
                result.device.id.toString() != result.device.name &&
                result.device.id.toString() == prefs.getString("blueDeviceId")) {
              if (!triedConnect) {
                JKBluetooth.stopScan();
                triedConnect = true;
                JKBluetooth.instance.connectDevice(result.device).then(
                  (value) {
                    Fluttertoast.showToast(msg: 'Connected');
                    this.setState(() {});
                    List<BluetoothService> services = value;
                    services.forEach(
                      (service) {
                        // printLog("所有服务值 --- $service");
                        if (service.uuid.toString().toUpperCase().substring(4, 8) ==
                            "FFF0") {
                          service.characteristics.forEach(
                            (characteristic) {
                              // characteristic.uuid;
                              String upString = characteristic.uuid
                                  .toString()
                                  .toUpperCase()
                                  .substring(4, 8);
                              // printLog("所有特征值 --- $characteristic");
                              if (upString == "FFF2") {
                                JKBluetooth.instance.wCharacteristic = characteristic;
                              } else if (upString == "FFF1") {
                                JKBluetooth.setNoticeCharacteristic(characteristic);
                              }
                            },
                          );
                        }
                      },
                    );
                  },
                );
              }
            }
          }
        },
      );
    }
  }
}
