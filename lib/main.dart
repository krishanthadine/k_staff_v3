import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/app_details/const.dart';
import 'package:flutter_application_2/push_notification/push_notification.dart';
import 'package:flutter_application_2/uI/splash/splash.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'provider/provider.dart';
import 'uI/app_permission/app_permission.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await notify().initNotifications();

  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // // call the useSystemCallingUI
  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );
  // });
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProviderS()),
      ChangeNotifierProvider(create: (_) => ProviderDropDown()),
    ],
    child: MyApp(navigatorKey: navigatorKey),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FlutterSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorKey: widget.navigatorKey,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        title: 'Koombiyo Staff',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Splash(),
      );
    });
  }
}
