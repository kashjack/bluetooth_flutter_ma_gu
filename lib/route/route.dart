import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/config.dart';

class JKRoute {
  static FluroRouter router = FluroRouter();

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    // router.notFoundHandler =
    //     Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    //   printLog("route is not find !");
    //   return null;
    // });
  }

  static void navigateTo(BuildContext context, String path) {
    router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }

  static void goWeb(BuildContext context, String url, String title) {
    navigateTo(context,
        "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}");
  }
}
