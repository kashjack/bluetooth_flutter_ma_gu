import 'dart:ui';

import 'package:get/get.dart';

enum Command {
  unknown,
  next_mode,
  add_volume,
  reduce_volume,
  set_volume,
  set_fader,
  set_balance,
  set_playTime,
  set_quickGo,
  set_quickBack,
  set_eq,
}

class BluetoothTask {
  Command command = Command.unknown;

  List<int> data = [];

  BluetoothTask(this.command, this.data);
}
