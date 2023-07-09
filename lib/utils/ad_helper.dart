import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    }
    // else if (Platform.isIOS) {
    //return "ca-app-pub-3940256099942544/2934735716";
    //}
    else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8691691433";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589807";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}


class AdMob {
  late BannerAd _adMobBanner;
  bool _isAdMob = false;
  AdMob() {
    String adBannerUnitId = '';
    if (!kIsWeb && Platform.isAndroid) {
      adBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';  //test id
      _isAdMob = true;
    } else if (!kIsWeb && Platform.isIOS) {
      adBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';  //test id
      _isAdMob = true;
    }
    if (_isAdMob) {
      _adMobBanner = BannerAd(
        adUnitId: adBannerUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener(),
      );
    }
  }
  void load() {
    if (_isAdMob) {
      _adMobBanner.load();
    }
  }
  Widget getAdBannerWidget() {
    if (_isAdMob) {
      return Container(
        alignment: Alignment.center,
        width: _adMobBanner.size.width.toDouble(),
        height: _adMobBanner.size.height.toDouble(),
        child: AdWidget(ad: _adMobBanner),
      );
    } else {
      return Container(height: 150);
    }
  }
  double getAdBannerHeight() {
    if (_isAdMob) {
      return _adMobBanner.size.height.toDouble();
    } else {
      return 150;  //for web
    }
  }
}