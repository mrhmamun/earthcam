// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:earth_cam/widgets/no_data_widget.dart';
import 'live_videos.dart';

class CountryCams extends StatefulWidget {
  CountryCams(
      {this.selectedCountry,
      this.selectedCountryTitle,
      this.selectedCountryFlag,
      this.selectedCountryIcon});

  final String selectedCountry;
  final String selectedCountryTitle;
  final String selectedCountryFlag;
  final String selectedCountryIcon;

  @override
  _CountryCamsState createState() => _CountryCamsState();
}

class _CountryCamsState extends State<CountryCams> {
  Future<List<Cams>> cams;
  var dbHelper;
  bool liked = false;

  Widget _mapList(DocumentSnapshot snapshot) {
    return CamsGridTile(
      context: context,
      camTitle: snapshot.data['camTitle'],
      imageUrl: snapshot.data['imageUrl'],
      onPressed: () {
        print('tapped');
        print('Countt in country :$count');
        count = count + 1;
        print('Countt: $count');
        if (count == 4) {
          count = 0;
        }
        if (snapshot.data['camType'] == 'Youtube') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YtVideoPlayerPage(
                        url: snapshot.data['streamUrl'],
                        title: snapshot.data['camTitle'],
                        imageUrl: snapshot.data['imageUrl'],
                        check: count,
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServerVideoPlayer(
                        url: snapshot.data['streamUrl'],
                        title: snapshot.data['camTitle'],
                        imageUrl: snapshot.data['imageUrl'],
                        check: count,
                      )));
        }
      },
      onPressedFavourite: () {
        Cams c = Cams(
          camId: snapshot.data['camId'],
          camTitle: snapshot.data['camTitle'],
          camType: snapshot.data['camType'],
          imageUrl: snapshot.data['imageUrl'],
          streamUrl: snapshot.data['streamUrl'],
        );
        dbHelper.save(c, context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
//    GoogleAdMob.showInterstitialAds();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: AppColor.kThemeColor),
          centerTitle: true,
          title: SizedBox(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.selectedCountry + ' Cams',
                style: GoogleFonts.righteous(
                    fontSize: 20, color: AppColor.kThemeColor),
              ),
            ),
          ),
          backgroundColor: Color(0xff28292b),
          actions: [
            AppConfig.appBarSearchButton(context),
          ],
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                widget.selectedCountryFlag,
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.kBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('cams')
                      .where('country', isEqualTo: widget.selectedCountry)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.length == 0) {
                        return Center(
                            child: NoDataWidget(text: 'No Cams Found'));
                      }
                      return Center(
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.count(
                                  padding: EdgeInsets.all(1.0),
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.0,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  children: snapshot.data.documents
                                      .map((doc) => _mapList(doc))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: AppConfig.bannerAdId,
        adSize: AdmobBannerSize.ADAPTIVE_BANNER(
          width: size.width.toInt(),
        ),
      ),
    );
  }
}
