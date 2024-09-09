class AlignmentSpeakItem {
  int cm0 = 0; //喇叭的延时第一个字节
  int cm1 = 0; //喇叭的延时第二个字节
  int cm = 0; //喇叭的延时
  int db = 0; //喇叭的增益

  AlignmentSpeakItem({
    required this.cm0,
    required this.cm1,
    required this.cm,
    required this.db,
  });
}

//新增ms
class AlignmentSpeakMSItem {
  int ms0 = 0; //喇叭的ms第一个字节
  int ms1 = 0; //喇叭的ms第二个字节
  int ms = 0; //喇叭的ms

  AlignmentSpeakMSItem({
    required this.ms0,
    required this.ms1,
    required this.ms,
  });
}
