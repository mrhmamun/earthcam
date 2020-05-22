// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

// 🌎 Project imports:
import 'package:earth_cam/widgets/chewie_player_custom/chewie.dart';
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';

class ServerVideoPlayer extends StatefulWidget {
  ServerVideoPlayer({this.url, this.title, this.imageUrl});

  final String url;
  final String title;
  final String imageUrl;

  @override
  State<StatefulWidget> createState() {
    return _ServerVideoPlayerState();
  }
}

class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
  VideoPlayerController _videoPlayerController2;
  VideoPlayerController _customController;
  ChewieController _chewieController;
  final _nativeAdController = NativeAdmobController();
  bool hidePlayer = false;

  @override
  void initState() {
    super.initState();
//    GoogleAdMob().showInterstitialAds();
    _videoPlayerController2 = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      isLive: true,
      fullScreenByDefault: false,
      autoInitialize: true,
//      placeholder: placeHolderImage(),
    );
    hidePlayer = false;
//    _customController = VideoPlayerController.network(widget.url);
//    FacebookAudienceNetwork.init(
//      testingId: "35e92a63-8102-46a4-b0f5-4fd269e6a13c",
//    );
    _showAds();
//    GoogleAdMob.hideBannerAd();
//    GoogleAdMob.showAnotherBannerAd();
  }

  _showAds() async{
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    int displayTimes = sharedPreferences.getInt('counter') ?? 0;

    print('DisplayTimes: $displayTimes');
    if(displayTimes == 0){
      GoogleAdMob.showInterstitialAds();
      displayTimes = 1;
    }
    else if (displayTimes == 2) {
      // Shown 3 times, reset counter
      GoogleAdMob.showInterstitialAds();
      displayTimes = 0;

    }
    else {
      // Less than 3 times, increase counter
      displayTimes++;
    }
    sharedPreferences.setInt('counter', displayTimes);
  }

  Widget placeHolderImage(){
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: FancyShimmerImage(
            boxFit: BoxFit.cover,
            imageUrl: widget.imageUrl,
            errorWidget: Icon(Icons.error),
          ),
        ),
        Positioned.fill(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController2.dispose();
    _nativeAdController.dispose();
//    GoogleAdMob.hideAnotherBannerAd();
    super.dispose();
  }

  onlineCallBack() {
    setState(() {
      _videoPlayerController2 = VideoPlayerController.network(widget.url);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController2,
        showControlsOnInitialize: false,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        isLive: true,
        fullScreenByDefault: false,
        autoInitialize: true,
//        placeholder: placeHolderImage(),
      );
    });
    hidePlayer = false;
  }

  offlineCallBack() {
    setState(() {
      _videoPlayerController2.pause();
      hidePlayer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityUtils.initialize(
        serverToPing: "https://www.google.com",
        callback: (response) => response.contains("google"));
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: SizedBox(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.title,
              style: GoogleFonts.righteous(
                  fontSize: 20, color: AppColor.kThemeColor),
            ),
          ),
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [],
      ),
      backgroundColor: AppColor.kBackgroundColor,
      body: ConnectivityWidget(
        onlineCallback: onlineCallBack,
        offlineCallback: offlineCallBack,
        offlineBanner: Container(
          margin: EdgeInsets.only(bottom: 60),
          padding: EdgeInsets.all(8),
          width: double.infinity,
          color: Colors.red,
          child: Text(
            "No Connection. Please Check your Internet Connection.",
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        showOfflineBanner: true,
        builder: (context, isOnline) => ListView(
          children: <Widget>[
            Stack(
              children: [
                hidePlayer == false
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : placeHolderImage()
//                CustomVideoPlayer(
//                  _customController,
//                  autoInitialize: true,
//                  autoPlay: true,
//                  showControls: true,
//                  looping: true,
//                  //TODO:: PLACE HOLDER IMAGE URL
//                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                // Your ad unit id
                adUnitID: AppConfig.nativeAddId,
                controller: _nativeAdController,
                type: NativeAdmobType.full,
              ),
            ),
            FacebookNativeAd(
              placementId: AppConfig.facebookNativeAdId,
              adType: NativeAdType.NATIVE_AD,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              backgroundColor: Colors.blue,
              titleColor: Colors.white,
              descriptionColor: Colors.white,
              buttonColor: Colors.deepPurple,
              buttonTitleColor: Colors.white,
              buttonBorderColor: Colors.white,
              listener: (result, value) {
                print("Native Ad: $result --> $value");
              },
            ),
          ],
        ),
      ),
    );
  }
}
