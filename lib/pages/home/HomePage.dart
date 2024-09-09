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
import 'package:flutter_app/helper/config/text_style.dart';
import 'package:flutter_app/notifier/changeNotifier.dart';
import 'package:flutter_app/pages/bt/BTPage.dart';
import 'package:flutter_app/pages/caraux/CarAuxPage.dart';
import 'package:flutter_app/pages/gps/GPSPage.dart';
import 'package:flutter_app/pages/home/widget/Swiper.dart';
import 'package:flutter_app/pages/play/PlayPage.dart';
import 'package:flutter_app/pages/radio/RadioPage.dart';
import 'package:flutter_app/pages/rgb/RGBPage.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:get/get.dart';

class HomePage extends BaseWidget with WidgetsBindingObserver {
  @override
  BaseWidgetState<BaseWidget> getState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState<HomePage> {
  List<String> imageArr = [
    JKImage.icon_radio,
    JKImage.icon_usb,
    JKImage.icon_bt,
    JKImage.icon_aux,
    JKImage.icon_sd,
    JKImage.icon_rgb,
    JKImage.icon_gps,
    JKImage.icon_setting,
  ];

  List<String> descArr = [
    S.current.BT_Music,
    S.current.AUX,
    S.current.USB,
    S.current.SD_Card,
    S.current.Radio,
    S.current.RGB,
    S.current.GPS,
    S.current.Setting
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
  String _version = '';

  // late VideoPlayerController? _controller;
  GlobalKey<SwiperState> swiperKey = GlobalKey();

  // ignore: cancel_subscriptions
  StreamSubscription<List<ScanResult>>? scanSubscription;
  bool triedConnect = false;

  // didChangeAppLifecycleState

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initBlueTooth();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
      });
    });
  }

  // 初始化蓝牙
  void _initBlueTooth() async {
    await JKBluetooth.instance.initBle();
    _autoConnect();
  }

  // 自动连接蓝牙
  void _autoConnect() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (shared.getString('bleRemoteId') != null) {
      printLog(shared.getString('bleRemoteId')!);
      StreamSubscription? stream;
      stream = JKBluetooth.instance.startScan().listen((result) {
        if (result.device.remoteId.toString() == shared.getString('bleRemoteId')! &&
            !ConnectNotifier.instance.isConnected) {
          if (stream != null) {
            stream!.cancel();
            stream = null;
          }
          EasyLoading.show(status: 'connect...');
          JKBluetooth.connectDevice(result.device).then((value) {
            EasyLoading.dismiss();
          });
        }
      });
    }
  }

  @override
  Widget buildVerticalLayout() {
    return Column(
      children: [
        _buildTopView(),
        _buildVerticalGridView(),
        _buildVersionView(),
      ],
    );
  }

  @override
  Widget buildHorizontalLayout() {
    return Column(
      children: [
        _buildTopView(),
        _buildHorizontalGridView(),
        _buildVersionView(),
      ],
    );
  }

  /// 顶部view
  Widget _buildTopView() {
    final isPortrait = ScreenUtil().orientation == Orientation.portrait;
    final double top = isPortrait ? 20.r : (Platform.isAndroid ? 0 : 25.r);
    final double bottom = isPortrait ? 30.r : 20.r;
    return Container(
      padding: EdgeInsets.only(left: 20.r, right: 20.r, top: top, bottom: bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            JKImage.icon_logo,
            height: 43,
            fit: BoxFit.contain,
          ),
          buildConnectView()
        ],
      ),
    );
  }

  Widget _buildVerticalGridView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 20 * JKSize.instance.px,
          right: 20 * JKSize.instance.px,
          top: max(200 * JKSize.instance.px - 190, 0),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行最多显示3个元素
            crossAxisSpacing: 15 * JKSize.instance.px, // 交叉轴方向的间距
            mainAxisSpacing: 15 * JKSize.instance.px, // 主轴方向的间距
            childAspectRatio: 8 / 5, // 设置元素的宽高比例，这里设为3:2
          ),
          itemCount: imageArr.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemView(index);
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalGridView() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20 * JKSize.instance.px, right: 20 * JKSize.instance.px),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 每行最多显示3个元素
            crossAxisSpacing: 15 * JKSize.instance.px, // 交叉轴方向的间距
            mainAxisSpacing: 15 * JKSize.instance.px, // 主轴方向的间距
            childAspectRatio: 8 / 5, // 设置元素的宽高比例，这里设为3:2
          ),
          itemCount: imageArr.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemView(index);
          },
        ),
      ),
    );
  }

  Widget _buildItemView(int index) {
    return InkWell(
      onTap: () {
        if (kDebugMode || ConnectNotifier.instance.isConnected) {
          if (index == 0) {
            Get.to(() => RadioPage());
          } else if (index == 1) {
            Get.to(() => PlayPage());
          } else if (index == 2) {
            Get.to(() => BtPage());
          } else if (index == 3) {
            Get.to(() => CarAuxPage());
          } else if (index == 4) {
            Get.to(() => PlayPage());
          } else if (index == 5) {
            Get.to(() => RGBPage());
          } else if (index == 6) {
            Get.to(() => GPSPage());
          } else if (index == 7) {
            // Get.to(() => Setting());
          } else {
            Fluttertoast.showToast(msg: S.current.reconnected_msg);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                imageArr[index],
              ),
            ),
            Positioned(
              top: 20 * JKSize.instance.px,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 100,
                child: Text(
                  descArr[index],
                  style: styleSize_16Height_22.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionView() {
    return Container(
      padding: EdgeInsets.all(JKSize.instance.isPortrait ? 15 : 0),
      child: Text(
        'v ' + _version,
        style: styleSize_14Height_19.copyWith(
          color: Colors.white,
        ),
      ),
    );
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
    // swiperKey.currentState!.pageTo(this.index);
    // super.didPopNext();
  }
}
