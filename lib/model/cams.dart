import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cams {
  String camTitle;
  String address;
  String streamUrl;
  String category;
  String subCategory;
  String createdAt;
  String updatedAt;
  String description;
  String imageUrl;
  Map<String,dynamic> position;
  GeoPoint geoPoint;
  LatLng latLng;

  Cams(
      {this.camTitle,
        this.address,
        this.description,
        this.imageUrl,
        this.createdAt,
        this.position,
        this.category,
        this.streamUrl,
        this.subCategory,
        this.updatedAt,
        this.geoPoint,
        this.latLng,
      });
}


//final List<Cams> camDetails = [
//  Cams(
//      camTitle: 'Stumptown Cams Roasters',
//      address: '18 W 29th St',
//      description:
//      'Cams bar chain offering house-roasted direct-trade Cams, along with brewing gear & whole beans',
//      locationCoords: LatLng(40.745803, -73.988213),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipNNzoa4RVMeOisc0vQ5m3Z7aKet5353lu0Aah0a=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Andrews Cams Shop',
//      address: '463 7th Ave',
//      description:
//      'All-day American comfort eats in a basic diner-style setting',
//      locationCoords: LatLng(40.751908, -73.989804),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOfv3DSTkjsgvwCsUe_flDr4DBXneEVR1hWQCvR=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Third Rail Cams',
//      address: '240 Sullivan St',
//      description:
//      'Small spot draws serious caffeine lovers with wide selection of brews & baked goods.',
//      locationCoords: LatLng(40.730148, -73.999639),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipPGoxAP7eK6C44vSIx4SdhXdp78qiZz2qKp8-o1=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Hi-Collar',
//      address: '214 E 10th St',
//      description:
//      'Snazzy, compact Japanese cafe showcasing high-end Cams & sandwiches, plus sake & beer at night.',
//      locationCoords: LatLng(40.729515, -73.985927),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipNhygtMc1wNzN4n6txZLzIhgJ-QZ044R4axyFZX=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Everyman Espresso',
//      address: '301 W Broadway',
//      description:
//      'Compact Cams & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
//      locationCoords: LatLng(40.721622, -74.004308),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Demra Staff Quarter Cam',
//      address: 'StaffQuarter, Demara-1360',
//      description:
//      'Compact Cams & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
//      locationCoords: LatLng(23.7209, 90.4833),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no'
//  ),
//  Cams(
//      camTitle: 'Boro Mogbazar Cam',
//      address: 'StaffQuarter, Demara-1360',
//      description:
//      'Compact Cams & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
//      locationCoords: LatLng(23.7494, 90.4090),
//      thumbNail: 'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no'
//  ),
//];
