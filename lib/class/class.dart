
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/uI/login_and_signup/login.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../app_details/color.dart';
class Navigation {
  Nav(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: page,
          inheritTheme: true,
          ctx: context),
    );
  }
}

class Loader {
  loader(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
            ),
          ),
          Center(
              child: Image.asset(
            'assets/app loarding button-01.png',
            height: 40,
          )),
          Center(
              child: LoadingAnimationWidget.threeArchedCircle(
            color: Color.fromARGB(255, 206, 40, 28),
            size: 55,
          )),
        ],
      ),
    );
  }
}

class notification {
  a(BuildContext context) {
    showTopSnackBar(
      displayDuration: Duration(milliseconds: 100),
      Overlay.of(context),
      CustomSnackBar.success(
        message: "Good job, your release is successful. Have a nice day",
      ),
    );
  }

  warning(BuildContext context, String text) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        // backgroundColor: black1.withOpacity(0.3),
        messagePadding: EdgeInsets.all(0),
        message: text,
      ),
    );
  }

  info(BuildContext context, String text) {
    showTopSnackBar(
      //jjjjj
      // displayDuration: Duration(milliseconds: 20),
      // animationDuration: Duration(milliseconds: 80),
      Overlay.of(context),
      CustomSnackBar.info(
        // backgroundColor: black1.withOpacity(0.3),
        messagePadding: EdgeInsets.all(0),
        message: text,
      ),
    );
  }
}

class CustomDialog {
  alert(BuildContext context, String title, String desc, VoidCallback onTap) {
    QuickAlert.show(
      onConfirmBtnTap: onTap,
      context: context,
      type: QuickAlertType.confirm,
      text: desc,
      title: title,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
    );
  }
  appExit(BuildContext context, String title, String desc, VoidCallback onTap) {
    QuickAlert.show(
      onConfirmBtnTap: onTap,
      context: context,
      type: QuickAlertType.warning,
      text: title,
      showCancelBtn: true,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
    );
  }
  userLoginCheck(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          color: Colors.transparent,
          height: h,
          width: w,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 2, 26, 63).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25)),
                height: h / 4,
                width: w,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            "Your user account uses another device. \nPlease log out.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DialogButton(
                            text: 'Log out',
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            buttonHeight: h / 17,
                            width: w / 2,
                            color: Color.fromARGB(57, 255, 238, 6)),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  numberUpdate(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Save',
      showCancelBtn: true,
      customAsset: 'assets/custom.gif',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter Phone Number',
          prefixIcon: Icon(
            Icons.phone_outlined,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        onChanged: (value) => message = value,
      ),
      onConfirmBtnTap: () async {
        if (message.length == 10) {
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 1000));
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Phone number '$message' has been saved!.",
          );
        } else {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input valid number',
          );
          return;
        }
      },
    );
  }
}
class RPSCustomPainterDark extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = Color.fromARGB(255, 21, 20, 20)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0002000, size.height * 1.0008000);
    path_0.lineTo(size.width * 1.0014000, size.height * 0.9976000);
    path_0.quadraticBezierTo(size.width * 1.0025000, size.height * 0.9508000,
        size.width * 0.9986000, size.height * 0.9448000);
    path_0.cubicTo(
        size.width * 0.8032500,
        size.height * 0.9250000,
        size.width * 0.9489500,
        size.height * 0.5044000,
        size.width * 0.5004000,
        size.height * 0.5056000);
    path_0.cubicTo(
        size.width * 0.0518000,
        size.height * 0.5038000,
        size.width * 0.2026000,
        size.height * 0.9294000,
        size.width * 0.0004000,
        size.height * 0.9464000);
    path_0.quadraticBezierTo(size.width * -0.0009500, size.height * 0.9488000,
        size.width * -0.0002000, size.height * 1.0008000);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0002000, size.height * 1.0008000);
    path_0.lineTo(size.width * 1.0014000, size.height * 0.9976000);
    path_0.quadraticBezierTo(size.width * 1.0025000, size.height * 0.9508000,
        size.width * 0.9986000, size.height * 0.9448000);
    path_0.cubicTo(
        size.width * 0.8032500,
        size.height * 0.9250000,
        size.width * 0.9489500,
        size.height * 0.5044000,
        size.width * 0.5004000,
        size.height * 0.5056000);
    path_0.cubicTo(
        size.width * 0.0518000,
        size.height * 0.5038000,
        size.width * 0.2026000,
        size.height * 0.9294000,
        size.width * 0.0004000,
        size.height * 0.9464000);
    path_0.quadraticBezierTo(size.width * -0.0009500, size.height * 0.9488000,
        size.width * -0.0002000, size.height * 1.0008000);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
