import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../api/api.dart';
import '../../app_details/size.dart';
import '../../class/class.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) => data());
    super.initState();
  }

  //  AppLifecycleState ?_lastState;

// user agreement  and api data call from CustomApi  class
  data() async {
    await CustomApi().checkFirstSeen(context);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 181, 222, 245),
      body: AnimationLimiter(
        child: AnimationConfiguration.synchronized(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(),
            child: Stack(children: [
              SizedBox(
                height: h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      'Welcome To',
                      style: TextStyle(
                          fontSize: 35,
                          color: black,
                          // fontFamily: 'KodeMono',
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "Sri Lanka's Fastest & Largest \nDelivery Network",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: black1,
                          // fontFamily: 'KodeMono',
                          fontWeight: FontWeight.normal),
                    ),
                    Spacer(),
                    Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo-02.png',
                            width: AppSize().width(context) / 1.2,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SlideAnimation(
                          horizontalOffset: 500,
                          duration: Duration(milliseconds: 1800),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40, top: 0),
                            child: Image.asset(
                              'assets/logo-04.png',
                              width: AppSize().width(context) / 1.2,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SlideAnimation(
                          horizontalOffset: 500,
                          duration: Duration(milliseconds: 1200),
                          child: Image.asset(
                            'assets/logo-03.png',
                            width: AppSize().width(context) / 1.2,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Spacer(),
                    Text("Copyright 2024 by \nKoobiyo IT (pvt)Ltd",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: black1,
                          fontSize: 13.dp,
                          fontWeight: FontWeight.normal,
                        )),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      padding: EdgeInsets.only(bottom: 200),
                      child: Loader().loader(context),
                    )
                  : SizedBox(),
            ]),
          ),
        ),
      ),
    );
  }
}
