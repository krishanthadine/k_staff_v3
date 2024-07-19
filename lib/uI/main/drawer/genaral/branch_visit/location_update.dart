import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/drawer/genaral/branch_visit/branch_visit_history.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../widget/diloag_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  MapController mapController = MapController();
  Position? position;
  bool isOpen = false;
  bool lConfirm = false;
  String newImage = '';
  String visitBranchId = '';
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String lat = '';
  String long = '';
  String image64 = '';
  // List userBranchList = [];
  String? selectval;
  List userBranchList = [];
  List branchList = [];

  @override
  void initState() {
    getLocation();
    userLocation();
    getUserBranch();
    // TODO: implement initState
    super.initState();
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    List brancheList = await CustomApi().userActiveBranches(context);
    print(brancheList);
    setState(() {
      userBranchList = brancheList;

      isLoading = false;
    });
  }

  void getLocation() async {
    userLocation();
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      position;
    });
  }

  String MarkerTempId = '';

  List<Marker> markerList = <Marker>[];
  List<Marker> _marker = [];

  userLocation() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var temp = await CustomApi().branchVisitHistroy(context);
    if (!mounted) return;
    setState(() {
      branchList = temp;
    });

    List.generate(branchList.length, (index) {
      double lat = double.parse(branchList[index]['bv_lati']);
      double long = double.parse(branchList[index]['bv_longt']);
      if (formattedDate == branchList[index]['bv_branch_name']) {
        final _markertemp = <Marker>[
          Marker(
            // key: Key(pickupLocation[index]['pickr_id']),
            point: LatLng(lat, long),

            child: InkWell(
                onTap: () {}, child: Image.asset('assets/location_d.png')),
          )
        ];

        _marker.addAll(_markertemp);
      }
    });
    setState(() {
      _marker;
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
        builder: (context, provider, child) => Scaffold(
              floatingActionButton: lConfirm
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: FloatingActionButton.small(
                          backgroundColor: white.withOpacity(0.5),
                          child: Icon(Icons.location_searching_rounded),
                          onPressed: () {
                            Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high)
                                .then((pickedCurrentLocation) {
                              setState(() {
                                position = pickedCurrentLocation;
                              });
                              mapController.move(
                                  LatLng(
                                      position!.latitude, position!.longitude),
                                  2);
                            });
                          }),
                    ),
              appBar: AppBar(
                backgroundColor: appliteBlue,
                title: Text(
                  'Branch Visit',
                  style: TextStyle(
                    fontSize: 18.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(w, h / 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: Container(
                        height: h / 17,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        width: w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: black3,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          alignment: AlignmentDirectional.centerEnd,
                          hint: Container(
                            //and here
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select branch",
                              style: TextStyle(color: black1),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          value:
                              selectval, //implement initial value or selected value
                          onChanged: (value) {
                            setState(() {
                              // _runFilter(value.toString());
                              //set state will update UI and State of your App
                              selectval = value
                                  .toString(); //change selectval to new value
                            });
                          },
                          items: userBranchList.map((itemone) {
                            return DropdownMenuItem(
                                onTap: () {
                                  setState(() {
                                    visitBranchId = itemone['did'];
                                  });
                                  // getData(itemone['did']);
                                },
                                value: itemone['dname'],
                                child: Text(
                                  itemone['dname'],
                                  style: TextStyle(color: black2),
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
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
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchVisitHistory(),
                            ));
                      },
                      icon: Icon(
                        Icons.history,
                        color: white,
                      ))
                ],
              ),
              backgroundColor: Color.fromARGB(255, 229, 232, 238),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: position == null
                    ? Loader().loader(context)
                    : Stack(
                        children: [
                          SizedBox(
                            height: h,
                            width: w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(),
                                lConfirm
                                    ? Container(
                                        color: Colors.blueGrey,
                                        child: provider.lImage.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                child: Container(
                                                    height: h / 2,
                                                    width: w,
                                                    child: Image.file(
                                                      File(provider.lImage),
                                                      fit: BoxFit.cover,
                                                    )))
                                            : DottedBorder(
                                                color: Colors.black38,
                                                borderType: BorderType.RRect,
                                                radius: Radius.circular(12),
                                                padding: EdgeInsets.all(6),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: h / 2,
                                                    width: w,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .cloud_upload_outlined,
                                                          size: 40,
                                                          color: const Color
                                                              .fromARGB(
                                                              96, 77, 76, 76),
                                                        ),
                                                        Text(
                                                            'Please upload \nyour image',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black38,
                                                              fontSize: 12.dp,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      )
                                    : Expanded(
                                        child:
                                            // GoogleMap(
                                            //   markers: _marker,
                                            //   onCameraMoveStarted: () {},
                                            //   padding: EdgeInsets.only(
                                            //     top: h / 2.0,
                                            //   ),
                                            //   // on below line specifying map type.
                                            //   mapType: MapType.normal,
                                            //   // on below line setting user location enabled.
                                            //   myLocationEnabled: true,
                                            //   // on below line setting compass enabled.

                                            //   initialCameraPosition: CameraPosition(
                                            //     target: LatLng(position!.latitude,
                                            //         position!.longitude),
                                            //     zoom: 11.4746,
                                            //   ),
                                            //   onTap: (argument) {
                                            //     argument.latitude;
                                            //     argument.longitude;
                                            //     // MapUtils.openMap(
                                            //     //     argument.latitude, argument.longitude);
                                            //   },

                                            //   onMapCreated:
                                            //       (GoogleMapController controller) {
                                            //     _controller.complete(controller);
                                            //   },
                                            // ),
                                            FlutterMap(
                                          mapController: mapController,
                                          // mapController: mapController,
                                          options: MapOptions(
                                            initialCenter:
                                                LatLng(7.8731, 80.7718),
                                            minZoom: 8,
                                            maxZoom: 40,
                                            zoom: 7.5,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              subdomains: ['a', 'b', 'c'],
                                            ),
                                            MarkerLayer(markers: _marker),
                                            MarkerLayer(markers: [
                                              Marker(
                                                  point: LatLng(
                                                      position!.latitude,
                                                      position!.longitude),
                                                  child: Icon(
                                                    Icons
                                                        .person_pin_circle_rounded,
                                                    size: 20,
                                                    color: Color.fromARGB(
                                                        255, 240, 27, 4),
                                                  ))
                                            ]),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          isLoading ? Loader().loader(context) : SizedBox(),
                          provider.isanotherUserLog
                              ? UserLoginCheck()
                              : SizedBox()
                        ],
                      ),
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.only(
                    bottom: 30, left: 8, right: 8, top: 10),
                child: Container(
                  height: h / 16 + 10,
                  alignment: Alignment.center,
                  width: w,
                  child: DialogButton(
                      text: provider.lImage.isNotEmpty && lConfirm
                          ? 'Save'
                          : lConfirm
                              ? 'Upload location Image'
                              : 'Confirm My Location',
                      onTap: provider.lImage.isNotEmpty && lConfirm
                          ? () async {
                              setState(() {
                                isLoading = true;
                              });

                              print(
                                  Provider.of<ProviderS>(context, listen: false)
                                      .bImage
                                      .toString());
                              print(position!.latitude.toString());
                              print(position!.longitude.toString());
                              print(visitBranchId);
                              await CustomApi().branchVisit(
                                  context,
                                  visitBranchId,
                                  position!.latitude.toString(),
                                  position!.longitude.toString(),
                                  Provider.of<ProviderS>(context, listen: false)
                                      .bImage);
                              await userLocation();
                              // Navigator.pop(context);
                              setState(() {
                                lConfirm = false;
                                isLoading = false;
                              });
                            }
                          : lConfirm
                              ? () {
                                  show();
                                }
                              : () {
                                  if (visitBranchId != '') {
                                    CustomDialog().alert(context, 'Info',
                                        'Can you provide your current location?',
                                        () {
                                      Provider.of<ProviderS>(context,
                                              listen: false)
                                          .lImage = '';
                                      setState(() {
                                        lConfirm = true;
                                        Navigator.pop(context);
                                      });
                                    });
                                  } else {
                                    notification().warning(
                                        context, 'Please select the branch');
                                  }
                                },
                      buttonHeight: h / 16,
                      width: w / 1.5,
                      color: appButtonColorLite),
                ),
              ),
            ));
  }

  getImage() async {
    final XFile? image =
        await _picker.pickImage(imageQuality: 10, source: ImageSource.camera);

    Provider.of<ProviderS>(context, listen: false).lImage = image!.path;
    List<int> imageBytes = await image!.readAsBytes();
    // Encode the bytes to base64
    String base64Image = base64Encode(imageBytes);
    setState(() {
      image64 = base64Image;
      print(image64);
      Provider.of<ProviderS>(context, listen: false).bImage = base64Image;
    });
    Navigator.pop(context);
  }

  void show() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return StatefulBuilder(builder: (context, setstate) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    getImage();
                  },
                  child: Text('Use Camera'),
                ),
                // CupertinoActionSheetAction(
                //   onPressed: () async {
                //     final XFile? image = await _picker.pickImage(
                //         imageQuality: 10, source: ImageSource.gallery);
                //     Provider.of<ProviderS>(context, listen: false).lImage =
                //         image!.path;

                //     Navigator.pop(context);
                //   },
                //   child: Text('Upload from files'),
                // ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            );
          });
        });
  }
}
