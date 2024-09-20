import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final txtSearch = TextEditingController().obs;


  final recentlyPlayedArr = [
    {
      "name": "Music 01",
      "artists": "Artist Name",
      "audioUrl": "assets/audio/song.mp3",
      "image": "assets/img/alb1.png" // Example path to asset audio
    },
    {
      "name": "Track 2",
      "artists": "new track 2",
      "audioUrl": "assets/audio/songnew.mp3",
      "image": "assets/img/alb1.png"  // Example path to asset audio
    },
     {
      "name": "Track 2",
      "artists": "new track 2",
      "audioUrl": "assets/audio/songnew.mp3",
      "image": "assets/img/alb1.png"  // Example path to asset audio
    },
   
    //add as many you want
   
  ].obs;
}
