import 'dart:developer';

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:http/http.dart' as https;
import 'package:timeline_tile/timeline_tile.dart';
import '../../navigation/navigation.dart';
import 'dart:math';

class OderAllDetails extends StatefulWidget {
  const OderAllDetails({
    super.key,
  });

  @override
  State<OderAllDetails> createState() => _OderAllDetailsState();
}

class _OderAllDetailsState extends State<OderAllDetails> {
  ScrollController _controller = ScrollController();
  TextEditingController search = TextEditingController();
  TextEditingController waybill = TextEditingController();
  TextEditingController codController = TextEditingController();
  List product = [];
  List allProduct = [];
  //80808082
  String newImage = '';
  String formattedDate = '';
  Map dataList = {};

  bool itemLoading = false;

  bool isLoading = false;
  double progress = 0.0;
  ScrollController _scrollController = ScrollController();
  List item = [];
  List timeLine = [];
  List oderData = [];
  List ger_owner = [];
  List payments = [];
  List return_note = [];
  int x = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  oderDataSerch(String waybill) async {
    setState(() {
      isLoading = true;
    });
    var data = await CustomApi().oderDetailAndTimeLine(context, waybill
        // '80808082'
        );
    print('22222222222222222222');

    print('22222222222222222222');
    setState(() {
      dataList = data;

      print(dataList);
      timeLine = dataList['timeline'];
      oderData = dataList['order_data'];
      ger_owner = dataList['ger_owner'];
      payments = dataList['payments'];
      return_note = dataList['return_note'];

      print(oderData);
      print(ger_owner);
      print(payments);
      print(return_note);

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: serchBar(),
              )),
          title: Text(
            'My Delivery',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  oderData.isEmpty ||
                          payments.isEmpty ||
                          return_note.isEmpty && isLoading == false
                      ? SizedBox(
                          height: h,
                          width: w,
                          child: Column(
                            children: [
                              Center(child: NoData()),
                            ],
                          ))
                      : dataList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  ExpansionTileGroup(
                                      spaceBetweenItem: 20,
                                      toggleType: ToggleType.expandOnlyCurrent,
                                      children: [
                                        ExpansionTileBorderItem(
                                          collapsedBackgroundColor: blue,
                                          backgroundColor: const Color.fromARGB(
                                              255, 231, 222, 192),
                                          title: Text(
                                            'Basic Information',
                                            style: TextStyle(
                                                fontSize: 18, color: black),
                                          ),
                                          expendedBorderColor: Colors.blue,
                                          children: [
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Client Name',
                                                    oderData[0]['cust_name']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Waybill ID',
                                                    oderData[0]['waybill_id']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'COD',
                                                    oderData[0]['cod_final']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Weight',
                                                    oderData[0]['weight']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Delivery Charge',
                                                    oderData[0]
                                                            ['delivery_charge']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Description',
                                                    oderData[0]['description']
                                                        .toString()),
                                            payments.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Payment No',
                                                    payments[0]['payment_no']
                                                        .toString()),
                                            payments.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Paid Date',
                                                    payments[0]['paid_date']
                                                        .toString()),
                                            payments.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Paid Amount',
                                                    payments[0]['paid_amount']
                                                        .toString()),
                                            return_note.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Return Note ID',
                                                    return_note[0]['note_id']
                                                        .toString()),
                                            return_note.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Return Note Date',
                                                    return_note[0]['note_date']
                                                        .toString()),
                                          ],
                                        ),
                                        ExpansionTileBorderItem(
                                          collapsedBackgroundColor: blue,
                                          backgroundColor: const Color.fromARGB(
                                              255, 231, 222, 192),
                                          title: Text(
                                            'Customer Details',
                                            style: TextStyle(
                                                fontSize: 18, color: black),
                                          ),
                                          expendedBorderColor: Colors.blue,
                                          children: [
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Customer Name',
                                                    oderData[0]['cust_name']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Address',
                                                    oderData[0]['address']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Destination',
                                                    oderData[0]['dname']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Phone',
                                                    oderData[0]['phone']
                                                        .toString()),
                                          ],
                                        ),
                                        ExpansionTileBorderItem(
                                          collapsedBackgroundColor: blue,
                                          backgroundColor: const Color.fromARGB(
                                              255, 231, 222, 192),
                                          title: Text(
                                            'Order Details',
                                            style: TextStyle(
                                                fontSize: 18, color: black),
                                          ),
                                          expendedBorderColor: Colors.blue,
                                          children: [
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Destination',
                                                    oderData[0]['dname']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Received At',
                                                    oderData[0]['dname']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Dispatch To',
                                                    oderData[0]['dname']
                                                        .toString()),
                                            oderData.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Create Date',
                                                    oderData[0]['odate']
                                                        .toString()),
                                            ger_owner.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Owner',
                                                    ger_owner[0]['staff_name']
                                                        .toString()),
                                            ger_owner.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Branch Supervisor',
                                                    ger_owner[0]['sp_name']
                                                        .toString()),
                                            ger_owner.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Branch Manager',
                                                    ger_owner[0]['am_name']
                                                        .toString()),
                                            ger_owner.isEmpty
                                                ? SizedBox()
                                                : myRow(
                                                    'Bin Code',
                                                    ger_owner[0]['bin_code']
                                                        .toString()),
                                          ],
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Status',
                        style: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  dataList.isNotEmpty
                      ? SizedBox(
                          // height: h / 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: timeLine.length,
                              itemBuilder: (context, index) {
                                bool isLast = index == timeLine.length - 1;
                                print(index);
                                return TimelineTile(
                                  isFirst: isLast ? true : false,
                                  isLast: index == 0 ? true : false,
                                  indicatorStyle: IndicatorStyle(
                                      width: 60,
                                      height: 60,
                                      indicator: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color:
                                                //  const Color.fromARGB(
                                                //         255, 126, 156, 156)

                                                Color(Random()
                                                        .nextInt(0xffffffff))
                                                    .withAlpha(0xff)
                                                    .withOpacity(0.2),
                                          ),
                                          child: Icon(
                                            index == 0
                                                ? Icons.ac_unit_rounded
                                                : Icons.home,
                                            color: black,
                                            size: 35,
                                          ))),
                                  alignment: TimelineAlign.start,
                                  endChild: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 88, 108, 155),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            timeLine[index]['status'],
                                            style: TextStyle(
                                                color: white, fontSize: 18),
                                          ),
                                          Text(
                                            timeLine[index]['comments'],
                                            style: TextStyle(color: white1),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              timeLine[index]['status_date'],
                                              style: TextStyle(color: white2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget myRow(String text1, String text2) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: w / 2,
          child: Text(
            text1,
            style: TextStyle(fontSize: 14, color: black1),
          ),
        ),
        Expanded(
          child: Text(
            text2,
            style: TextStyle(fontSize: 14, color: black1),
          ),
        ),
      ],
    );
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allProduct;
    } else if (allProduct
        .where((user) =>
            user["item"].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = allProduct
          .where((user) =>
              user["item"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      product = results;
    });
  }

  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: 20,
        width: 20,
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Color.fromARGB(255, 153, 166, 177),
          size: 30,
        ),
      ),
    );
  }

  Widget serchBar() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  if (value.length > 7) {
                    oderDataSerch(value);
                  }
                },
                controller: search,
                style: TextStyle(color: black, fontSize: 13.sp),
                validator: (value) {},
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        scanBarcodeNormal();
                      },
                      icon: Icon(Icons.qr_code_scanner_sharp)),
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        // color: pink.withOpacity(0.1),
                        ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(fontSize: 13.dp),
                  hintText: 'Scan or Search',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      var _scanBarcode = barcodeScanRes;
      if (_scanBarcode == "-1") {
        search.text = "";
      } else {
        search.text = _scanBarcode.toString();
        oderDataSerch(search.text);
      }
    });
  }
}
