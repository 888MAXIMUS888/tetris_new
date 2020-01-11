import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';

const bannerAndroidId = "ca-app-pub-7986696519803132/3241106742";
const banneriOSId = "ca-app-pub-7986696519803132/3687350372";

class Ads {
  BannerAd bannerAd;

  Future showBanner() {
    bannerAd ??= createBannerAd();
    bannerAd..load();
    if (Platform.isIOS) {
      bannerAd.show(
        anchorOffset: 50.0,
        anchorType: AnchorType.top,
      );
    } else {
      bannerAd.show(
        anchorOffset: 30.0,
        anchorType: AnchorType.top,
      );
    }
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      // TODO: Release version ADS
      // Platform.isAndroid ? bannerAndroidId : banneriOSId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print('BannerAd event $event');
        if (event == MobileAdEvent.loaded) {
          bannerAd..show();
        }
      },
    );
  }
}
