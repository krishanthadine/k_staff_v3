import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/custom_textField.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_application_2/uI/widget/textField.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../navigation/navigation.dart';

class CODZeroApproval extends StatefulWidget {
  const CODZeroApproval({super.key});

  @override
  State<CODZeroApproval> createState() => _CODZeroApprovalState();
}

class _CODZeroApprovalState extends State<CODZeroApproval> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int x = 0;
  List<Map<String, dynamic>> depositList = [
    {'date': '2023/01/23'},
    {'date': '2023/11/23'},
    {'date': '2023/02/23'},
    {'date': '2023/01/21'},
    {'date': '2023/01/23'},
    {'date': '2023/01/24'}
  ];
  List dataList = [];
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  List branchRiders = [];
  String? selectval;
  bool isLoading = false;
  List<Map<String, dynamic>> depositListTemp = [];
  @override
  void initState() {
    branchRider();
    data('3');
    setState(() {
      depositListTemp = depositList;
    });
    // TODO: implement initState
    super.initState();
  }

  branchRider() async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().deliveryApprovalsRiderList(context);
    log(res.toString());
    setState(() {
      branchRiders = res;
      isLoading = false;
    });
  }

  data(String id) async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().deliveryApprovals(context, id);
    log(res.toString());
    setState(() {
      dataList = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    child: Container(
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
                        underline: SizedBox(),
                        isExpanded: true,
                        alignment: AlignmentDirectional.centerEnd,
                        hint: Container(
                          //and here
                          child: Text(
                            "Select Rider                                                         ",
                            style: TextStyle(color: black1),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        value:
                            selectval, //implement initial value or selected value
                        onChanged: (value) {
                          setState(() {
                            //set state will update UI and State of your App
                            selectval = value.toString();
                            data(selectval
                                .toString()); //change selectval to new value
                          });
                        },
                        items: branchRiders.map((itemone) {
                          return DropdownMenuItem(
                              value: itemone['user_id'],
                              child: Text(
                                itemone['staff_name'],
                                style: TextStyle(color: black2),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )),
          title: Text(
            'Delivery Approval',
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
        backgroundColor: white,
        body: Stack(
          children: [
            dataList.isEmpty && isLoading == false
                ? SizedBox(
                    height: h,
                    width: w,
                    child: Column(
                      children: [
                        Center(child: NoData()),
                      ],
                    ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          codApproval();
                        },
                        child: Card(
                          color: Color.fromARGB(255, 179, 196, 210),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ID",
                                            style: TextStyle(
                                              fontSize: 17.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "- ${dataList[index]['waybill_id']}",
                                      style: TextStyle(
                                        fontSize: 17.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Receiver name",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "- ${dataList[index]['name']}",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Customer name",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "- ${dataList[index]['cust_name']}",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Address",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: w / 2,
                                      child: Text(
                                        "- ${dataList[index]['address']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Card(
                                        color: Colors.amberAccent,
                                        elevation: 20,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${dataList[index]['status']}",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Receiver phone",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "- ${dataList[index]['phone']}",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: Color.fromARGB(255, 46, 19, 196),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "From Branch",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "- Kurunegala",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "To branch",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "- 0711672439",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Remark",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- ${dataList[index]['cutomer_remarks']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 10,
                                  child: Divider(
                                    color: Color.fromARGB(255, 127, 156, 190),
                                    thickness: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                              ],
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

  codApproval() {
    QuickAlert.show(
      title: 'Oder Confirmation',
      context: context,
      type: QuickAlertType.confirm,
      barrierDismissible: true,
      confirmBtnText: 'SAVE',
      // width: double.infinity,
      widget: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  x = 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Oder Confirm',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        )),
                    Icon(
                      x == 1 ? Icons.check_circle : Icons.circle_outlined,
                      color: x == 1
                          ? Colors.green
                          : const Color.fromARGB(255, 136, 161, 203),
                      size: 27,
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                setState(() {
                  x = 2;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Partially Delivery',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        )),
                    Icon(
                      x == 2 ? Icons.check_circle : Icons.circle_outlined,
                      color: x == 2
                          ? Colors.green
                          : const Color.fromARGB(255, 136, 161, 203),
                      size: 27,
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            x == 2
                ? CustomTextField3(
                    controller: TextEditingController(),
                  )
                : SizedBox()
          ],
        );
      }),
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        await Future.delayed(const Duration(milliseconds: 1000));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Order successfully confirmed !.",
        );
        Navigator.pop(context);
      },
    );
  }
}

Widget serchBarr(BuildContext con) {
  var h = MediaQuery.of(con).size.height;
  var w = MediaQuery.of(con).size.width;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      height: h / 15,
      child: Row(
        children: [
          TextFormField(
            onChanged: (value) {},
            // controller: search,
            style: TextStyle(color: black, fontSize: 13.sp),
            validator: (value) {},
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: black3),
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
              hintText: 'Search by date',
              fillColor: white2,
            ),
          ),
        ],
      ),
    ),
  );
}
