import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  String? selectval;
  List userList = [];
  bool isLoading = false;
  List userBranchList = [
    {"dname": "All", "did": ''}
  ];

  @override
  void initState() {
    getUserBranch();
    getData('');
    // TODO: implement initState
    super.initState();
  }

  getData(String data) async {
    setState(() {
      isLoading = true;
    });
    List res = await CustomApi().manageUserScreen(
        context, Provider.of<ProviderS>(context, listen: false).bId);
          print(res);
    setState(() {
      userList = res;
      isLoading = false;
  
    });
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    var brancheList = await CustomApi().userActiveBranches(context);
  

    setState(() {
      userBranchList.addAll(brancheList);

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
          title: Text(
            'Manage Users',
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
                        color: black3, style: BorderStyle.solid, width: 0.80),
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
                        selectval =
                            value.toString(); //change selectval to new value
                      });
                    },
                    items: userBranchList.map((itemone) {
                      return DropdownMenuItem(
                          onTap: () {
                            getData(itemone['did']);
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
        ),
        body: Stack(
          children: [
            userList.isEmpty && isLoading == false
                ? Stack(children: [
                    SizedBox(
                        height: h,
                        width: w,
                        child: Column(
                          children: [
                            Center(child: NoData()),
                          ],
                        ))
                  ])
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                splashColor: blue,
                                onTap: () {
                                  // itemDetails();
                                },
                                onLongPress: () {},
                                child: Card(
                                  margin: EdgeInsets.only(left: 0),
                                  color: appliteBlue,
                                  child: Card(
                                    elevation: 50,
                                    margin: EdgeInsets.only(left: 3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Card(
                                                  elevation: 1,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons
                                                            .person_add_alt_sharp,
                                                        size: 40,
                                                        color: Color(Random()
                                                                .nextInt(
                                                                    0xffffffff))
                                                            .withAlpha(0xff),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: w / 1.6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          userList[index]
                                                              ['emp_id'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: black,
                                                            fontSize: 14.dp,
                                                          )),
                                                      Row(mainAxisAlignment:  MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                              'Name:- ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color:
                                                                    Colors.black87,
                                                                fontSize: 12.dp,
                                                              )),
                                                              Flexible(
                                                                child: Text(
                                                                                                                          '${userList[index]['staff_name']}',
                                                                                                                          style: TextStyle(
                                                                                                                            fontWeight:
                                                                  FontWeight.w500,
                                                                                                                            color:
                                                                  Color.fromARGB(221, 48, 47, 47),
                                                                                                                            fontSize: 12.dp,
                                                                                                                          )),
                                                              )
                                                        ],
                                                      ),
                                                      Text(
                                                          'User Name:- ${userList[index]['username']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Type:- ${userList[index]['emp_type_name']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Designation:- ${userList[index]['designation']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Phone:-${userList[index]['mobile_personal']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromARGB(
                                                                    221,
                                                                    220,
                                                                    44,
                                                                    44),
                                                            fontSize: 14.dp,
                                                          )),
                                                      Text(
                                                          'branch:-${userList[index]['dname']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromARGB(
                                                                    221,
                                                                    44,
                                                                    65,
                                                                    220),
                                                            fontSize: 14.dp,
                                                          )),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'Delivery Agent:-',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: black,
                                                                fontSize: 14.dp,
                                                              )),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Card(
                                                            color: userList[index]
                                                                        [
                                                                        'is_agent'] ==
                                                                    0
                                                                ? Colors.red
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        232,
                                                                        200,
                                                                        152),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              child: userList[index]
                                                                          [
                                                                          'is_agent'] ==
                                                                      0
                                                                  ? Text(
                                                                      'Deactivate',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Color.fromARGB(
                                                                            221,
                                                                            250,
                                                                            250,
                                                                            254),
                                                                        fontSize:
                                                                            14.dp,
                                                                      ))
                                                                  : Text(
                                                                      'Active',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Color.fromARGB(
                                                                            221,
                                                                            44,
                                                                            65,
                                                                            220),
                                                                        fontSize:
                                                                            14.dp,
                                                                      )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('System:-',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: black,
                                                                fontSize: 14.dp,
                                                              )),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Card(
                                                            color: userList[index]
                                                                        [
                                                                        'is_koombiyo'] ==
                                                                    0
                                                                ? Colors.red
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        232,
                                                                        200,
                                                                        152),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                              child: userList[index]
                                                                          [
                                                                          'is_koombiyo'] ==
                                                                      0
                                                                  ? Text(
                                                                      'Deactivate',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Color.fromARGB(
                                                                            221,
                                                                            250,
                                                                            250,
                                                                            254),
                                                                        fontSize:
                                                                            14.dp,
                                                                      ))
                                                                  : Text(
                                                                      'Active',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Color.fromARGB(
                                                                            221,
                                                                            44,
                                                                            65,
                                                                            220),
                                                                        fontSize:
                                                                            14.dp,
                                                                      )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }
}
