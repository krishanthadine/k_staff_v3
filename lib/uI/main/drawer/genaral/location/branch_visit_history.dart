import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BranchVisitHistory extends StatefulWidget {
  const BranchVisitHistory({super.key});

  @override
  State<BranchVisitHistory> createState() => _BranchVisitHistoryState();
}

class _BranchVisitHistoryState extends State<BranchVisitHistory> {
  List branchVisit = [];
  DateTime date = DateTime.now();
  Position? position;
  String today = '';
  bool isLoading = false;
  @override
  void initState() {
    ;
    getDat();
    // TODO: implement initState

    super.initState();
  }

  getDat() async {
    setState(() {
      isLoading = true;
    });
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    var res = await CustomApi().branchVisitHistroy(context);

    setState(() {
      branchVisit = res;
      today = formattedDate;
      print(today);
      print(branchVisit);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appliteBlue,
          title: Text(
            'Branch Visit History',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: white,
              )),
        ),
        backgroundColor: Color.fromARGB(255, 229, 232, 238),
        body: Stack(
          children: [
            SizedBox(
              height: h,
              child: ListView.builder(
                itemCount: branchVisit.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromARGB(255, 215, 225, 232),
                      child: SizedBox(
                        width: w - 16,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    branchVisit[index]['bv_branch_name'],
                                    style: TextStyle(
                                        color: black, fontSize: 14.dp),
                                  ),
                                  Text(
                                    '${branchVisit[index]['date']}',
                                    style:
                                        TextStyle(color: black2, fontSize: 14),
                                  ),
                                ],
                              ),
                              Spacer(),
                              branchVisit[index]['out_time'] != null
                                  ? Container()
                                  : DialogButton(
                                      text: 'Exit',
                                      onTap: () async {
                                        if (today ==
                                            branchVisit[index]['date']) {
                                          CustomDialog().alert(context, 'Info',
                                              'Do you want to exit the branch',
                                              () {
                                            Navigator.pop(context);
                                            getLocation(
                                                branchVisit[index]
                                                    ['bv_branch_id'],
                                                branchVisit[index]['bv_id']);

                                            exitBranch();
                                          });
                                        } else {
                                          notification().warning(context,
                                              'Your branch visit day and exit day are different. Please contact your admin.');
                                        }
                                      },
                                      buttonHeight: h / 20,
                                      width: w / 4,
                                      color: Color.fromARGB(255, 2, 174, 91)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  void getLocation(String bId, String bHistoryId) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    double distance = 100.00;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // var res = await Geolocator.distanceBetween(
    //     37.4219988, -122.084, 37.4219983, -122.084);

    await CustomApi().branchExit(context, bId, bHistoryId,
        position!.latitude.toString(), position!.longitude.toString());
    getDat();

    setState(() {
      // print(res);

      //  Latitude: 37.4219983, Longitude: -122.084
      print(position);
      position;
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation('', ''));
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  exitBranch() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 5, 5, 5),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: w / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please Wait ',
                        style: TextStyle(color: white, fontSize: 18.dp),
                      ),
                      Text(
                        'We are collecting some information, like your current location',
                        style: TextStyle(color: white2, fontSize: 14.dp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
