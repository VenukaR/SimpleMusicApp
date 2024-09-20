import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_music_player/model/splash_view_model.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final splashVM = Get.put(SplashViewMode());

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    splashVM.loadView();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/img/logo.png",
              width: media.width * 0.90,
            ),
          ),
        ],
      ),
    );
  }
}


/*
add music

Center(
            child: Image.asset(
              "assets/img/calmwave_light.png",
              width: media.width * 0.30,
            ),
*/ 