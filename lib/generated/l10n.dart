// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `BT Music`
  String get BT_Music {
    return Intl.message(
      'BT Music',
      name: 'BT_Music',
      desc: '',
      args: [],
    );
  }

  /// `AUX`
  String get AUX {
    return Intl.message(
      'AUX',
      name: 'AUX',
      desc: '',
      args: [],
    );
  }

  /// `USB`
  String get USB {
    return Intl.message(
      'USB',
      name: 'USB',
      desc: '',
      args: [],
    );
  }

  /// `SD Card`
  String get SD_Card {
    return Intl.message(
      'SD Card',
      name: 'SD_Card',
      desc: '',
      args: [],
    );
  }

  /// `Radio`
  String get Radio {
    return Intl.message(
      'Radio',
      name: 'Radio',
      desc: '',
      args: [],
    );
  }

  /// `RGB`
  String get RGB {
    return Intl.message(
      'RGB',
      name: 'RGB',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get GPS {
    return Intl.message(
      'GPS',
      name: 'GPS',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get Connect {
    return Intl.message(
      'Connect',
      name: 'Connect',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get Connected {
    return Intl.message(
      'Connected',
      name: 'Connected',
      desc: '',
      args: [],
    );
  }

  /// `DisConnected`
  String get DisConnected {
    return Intl.message(
      'DisConnected',
      name: 'DisConnected',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get Device {
    return Intl.message(
      'Device',
      name: 'Device',
      desc: '',
      args: [],
    );
  }

  /// `Paired Device`
  String get Paired_Device {
    return Intl.message(
      'Paired Device',
      name: 'Paired_Device',
      desc: '',
      args: [],
    );
  }

  /// `Devices Found`
  String get Devices_Found {
    return Intl.message(
      'Devices Found',
      name: 'Devices_Found',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is disconnected and needs to be reconnected`
  String get reconnected_msg {
    return Intl.message(
      'Bluetooth is disconnected and needs to be reconnected',
      name: 'reconnected_msg',
      desc: '',
      args: [],
    );
  }

  /// `Pick a Map application`
  String get openMap_msg {
    return Intl.message(
      'Pick a Map application',
      name: 'openMap_msg',
      desc: '',
      args: [],
    );
  }

  /// `Fader`
  String get Fader {
    return Intl.message(
      'Fader',
      name: 'Fader',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get Balance {
    return Intl.message(
      'Balance',
      name: 'Balance',
      desc: '',
      args: [],
    );
  }

  /// `ON`
  String get ON {
    return Intl.message(
      'ON',
      name: 'ON',
      desc: '',
      args: [],
    );
  }

  /// `OFF`
  String get OFF {
    return Intl.message(
      'OFF',
      name: 'OFF',
      desc: '',
      args: [],
    );
  }

  /// `L`
  String get L {
    return Intl.message(
      'L',
      name: 'L',
      desc: '',
      args: [],
    );
  }

  /// `LEFT`
  String get LEFT {
    return Intl.message(
      'LEFT',
      name: 'LEFT',
      desc: '',
      args: [],
    );
  }

  /// `R`
  String get R {
    return Intl.message(
      'R',
      name: 'R',
      desc: '',
      args: [],
    );
  }

  /// `RIGHT`
  String get RIGHT {
    return Intl.message(
      'RIGHT',
      name: 'RIGHT',
      desc: '',
      args: [],
    );
  }

  /// `Front`
  String get Front {
    return Intl.message(
      'Front',
      name: 'Front',
      desc: '',
      args: [],
    );
  }

  /// `FRONT`
  String get FRONT {
    return Intl.message(
      'FRONT',
      name: 'FRONT',
      desc: '',
      args: [],
    );
  }

  /// `Rear`
  String get Rear {
    return Intl.message(
      'Rear',
      name: 'Rear',
      desc: '',
      args: [],
    );
  }

  /// `REAR`
  String get REAR {
    return Intl.message(
      'REAR',
      name: 'REAR',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get All {
    return Intl.message(
      'All',
      name: 'All',
      desc: '',
      args: [],
    );
  }

  /// `ALL`
  String get ALL {
    return Intl.message(
      'ALL',
      name: 'ALL',
      desc: '',
      args: [],
    );
  }

  /// `WOOFER`
  String get WOOFER {
    return Intl.message(
      'WOOFER',
      name: 'WOOFER',
      desc: '',
      args: [],
    );
  }

  /// `L-WOOFER`
  String get L__WOOFER {
    return Intl.message(
      'L-WOOFER',
      name: 'L__WOOFER',
      desc: '',
      args: [],
    );
  }

  /// `R-WOOFER`
  String get R__WOOFER {
    return Intl.message(
      'R-WOOFER',
      name: 'R__WOOFER',
      desc: '',
      args: [],
    );
  }

  /// `Gain`
  String get Gain {
    return Intl.message(
      'Gain',
      name: 'Gain',
      desc: '',
      args: [],
    );
  }

  /// `GAIN`
  String get GAIN {
    return Intl.message(
      'GAIN',
      name: 'GAIN',
      desc: '',
      args: [],
    );
  }

  /// `GAIN LEFT`
  String get GAIN_LEFT {
    return Intl.message(
      'GAIN LEFT',
      name: 'GAIN_LEFT',
      desc: '',
      args: [],
    );
  }

  /// `GAIN RIGHT`
  String get GAIN_RIGHT {
    return Intl.message(
      'GAIN RIGHT',
      name: 'GAIN_RIGHT',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get Reset {
    return Intl.message(
      'Reset',
      name: 'Reset',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get Distance {
    return Intl.message(
      'Distance',
      name: 'Distance',
      desc: '',
      args: [],
    );
  }

  /// `Alignment`
  String get Alignment {
    return Intl.message(
      'Alignment',
      name: 'Alignment',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get Position {
    return Intl.message(
      'Position',
      name: 'Position',
      desc: '',
      args: [],
    );
  }

  /// `Speaker`
  String get Speaker {
    return Intl.message(
      'Speaker',
      name: 'Speaker',
      desc: '',
      args: [],
    );
  }

  /// `SPEAKER Settings`
  String get SPEAKER_Settings {
    return Intl.message(
      'SPEAKER Settings',
      name: 'SPEAKER_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Tweeter`
  String get Tweeter {
    return Intl.message(
      'Tweeter',
      name: 'Tweeter',
      desc: '',
      args: [],
    );
  }

  /// `X'Over`
  String get XOver {
    return Intl.message(
      'X\'Over',
      name: 'XOver',
      desc: '',
      args: [],
    );
  }

  /// `FRQ`
  String get FRQ {
    return Intl.message(
      'FRQ',
      name: 'FRQ',
      desc: '',
      args: [],
    );
  }

  /// `FRQ THROUGH`
  String get FRQ_THROUGH {
    return Intl.message(
      'FRQ THROUGH',
      name: 'FRQ_THROUGH',
      desc: '',
      args: [],
    );
  }

  /// `F HPF FRQ`
  String get F_HPF_FRQ {
    return Intl.message(
      'F HPF FRQ',
      name: 'F_HPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `R HPF FRQ`
  String get R_HPF_FRQ {
    return Intl.message(
      'R HPF FRQ',
      name: 'R_HPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `HPF`
  String get HPF {
    return Intl.message(
      'HPF',
      name: 'HPF',
      desc: '',
      args: [],
    );
  }

  /// `in`
  String get jk_in {
    return Intl.message(
      'in',
      name: 'jk_in',
      desc: '',
      args: [],
    );
  }

  /// `SLOPE`
  String get SLOPE {
    return Intl.message(
      'SLOPE',
      name: 'SLOPE',
      desc: '',
      args: [],
    );
  }

  /// `LOUD`
  String get LOUD {
    return Intl.message(
      'LOUD',
      name: 'LOUD',
      desc: '',
      args: [],
    );
  }

  /// `BAND`
  String get BAND {
    return Intl.message(
      'BAND',
      name: 'BAND',
      desc: '',
      args: [],
    );
  }

  /// `STEREO`
  String get STEREO {
    return Intl.message(
      'STEREO',
      name: 'STEREO',
      desc: '',
      args: [],
    );
  }

  /// `INT`
  String get INT {
    return Intl.message(
      'INT',
      name: 'INT',
      desc: '',
      args: [],
    );
  }

  /// `WAY`
  String get WAY {
    return Intl.message(
      'WAY',
      name: 'WAY',
      desc: '',
      args: [],
    );
  }

  /// `PHASE`
  String get PHASE {
    return Intl.message(
      'PHASE',
      name: 'PHASE',
      desc: '',
      args: [],
    );
  }

  /// `NORMAL`
  String get NORMAL {
    return Intl.message(
      'NORMAL',
      name: 'NORMAL',
      desc: '',
      args: [],
    );
  }

  /// `REVERSE`
  String get REVERSE {
    return Intl.message(
      'REVERSE',
      name: 'REVERSE',
      desc: '',
      args: [],
    );
  }

  /// `SUBWOOFER LPF`
  String get SUBWOOFER_LPF {
    return Intl.message(
      'SUBWOOFER LPF',
      name: 'SUBWOOFER_LPF',
      desc: '',
      args: [],
    );
  }

  /// `Subwoofer`
  String get Subwoofer {
    return Intl.message(
      'Subwoofer',
      name: 'Subwoofer',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get Level {
    return Intl.message(
      'Level',
      name: 'Level',
      desc: '',
      args: [],
    );
  }

  /// `BASS BOOST `
  String get Bass_Boost {
    return Intl.message(
      'BASS BOOST ',
      name: 'Bass_Boost',
      desc: '',
      args: [],
    );
  }

  /// `Q-FACTOR`
  String get Q_FACTOR {
    return Intl.message(
      'Q-FACTOR',
      name: 'Q_FACTOR',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get Manual {
    return Intl.message(
      'Manual',
      name: 'Manual',
      desc: '',
      args: [],
    );
  }

  /// `CUSTOM`
  String get CUSTOM {
    return Intl.message(
      'CUSTOM',
      name: 'CUSTOM',
      desc: '',
      args: [],
    );
  }

  /// `ROCK`
  String get ROCK {
    return Intl.message(
      'ROCK',
      name: 'ROCK',
      desc: '',
      args: [],
    );
  }

  /// `POP`
  String get POP {
    return Intl.message(
      'POP',
      name: 'POP',
      desc: '',
      args: [],
    );
  }

  /// `JAZZ`
  String get JAZZ {
    return Intl.message(
      'JAZZ',
      name: 'JAZZ',
      desc: '',
      args: [],
    );
  }

  /// `FLAT`
  String get FLAT {
    return Intl.message(
      'FLAT',
      name: 'FLAT',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get Auto {
    return Intl.message(
      'Auto',
      name: 'Auto',
      desc: '',
      args: [],
    );
  }

  /// `AUDIO SET`
  String get AUDIO_SET {
    return Intl.message(
      'AUDIO SET',
      name: 'AUDIO_SET',
      desc: '',
      args: [],
    );
  }

  /// `MID RANGE`
  String get MID_RANGE {
    return Intl.message(
      'MID RANGE',
      name: 'MID_RANGE',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get CANCEL {
    return Intl.message(
      'CANCEL',
      name: 'CANCEL',
      desc: '',
      args: [],
    );
  }

  /// `pull to scan`
  String get pull_to_scan {
    return Intl.message(
      'pull to scan',
      name: 'pull_to_scan',
      desc: '',
      args: [],
    );
  }

  /// `release to scan`
  String get release_to_scan {
    return Intl.message(
      'release to scan',
      name: 'release_to_scan',
      desc: '',
      args: [],
    );
  }

  /// `scaning`
  String get scaning {
    return Intl.message(
      'scaning',
      name: 'scaning',
      desc: '',
      args: [],
    );
  }

  /// `F-HPF FRQ`
  String get F__HPF_FRQ {
    return Intl.message(
      'F-HPF FRQ',
      name: 'F__HPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `F-HPF SLOPE`
  String get F__HPF_SLOPE {
    return Intl.message(
      'F-HPF SLOPE',
      name: 'F__HPF_SLOPE',
      desc: '',
      args: [],
    );
  }

  /// `F-LPF FRQ`
  String get F__LPF_FRQ {
    return Intl.message(
      'F-LPF FRQ',
      name: 'F__LPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `F-LPF SLOPE`
  String get F__LPF_SLOPE {
    return Intl.message(
      'F-LPF SLOPE',
      name: 'F__LPF_SLOPE',
      desc: '',
      args: [],
    );
  }

  /// `LPF FRQ`
  String get LPF_FRQ {
    return Intl.message(
      'LPF FRQ',
      name: 'LPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `LPF SLOPE`
  String get LPF_SLOPE {
    return Intl.message(
      'LPF SLOPE',
      name: 'LPF_SLOPE',
      desc: '',
      args: [],
    );
  }

  /// `HPF SLOPE`
  String get HPF_SLOPE {
    return Intl.message(
      'HPF SLOPE',
      name: 'HPF_SLOPE',
      desc: '',
      args: [],
    );
  }

  /// `SW LPF FRQ`
  String get SW_LPF_FRQ {
    return Intl.message(
      'SW LPF FRQ',
      name: 'SW_LPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `SW LPF PHASE`
  String get SW_LPF_PHASE {
    return Intl.message(
      'SW LPF PHASE',
      name: 'SW_LPF_PHASE',
      desc: '',
      args: [],
    );
  }

  /// `SUB`
  String get SUB {
    return Intl.message(
      'SUB',
      name: 'SUB',
      desc: '',
      args: [],
    );
  }

  /// `HPF FRQ`
  String get HPF_FRQ {
    return Intl.message(
      'HPF FRQ',
      name: 'HPF_FRQ',
      desc: '',
      args: [],
    );
  }

  /// `EQ`
  String get EQ {
    return Intl.message(
      'EQ',
      name: 'EQ',
      desc: '',
      args: [],
    );
  }

  /// `FA/BA`
  String get FABA {
    return Intl.message(
      'FA/BA',
      name: 'FABA',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get Value {
    return Intl.message(
      'Value',
      name: 'Value',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
