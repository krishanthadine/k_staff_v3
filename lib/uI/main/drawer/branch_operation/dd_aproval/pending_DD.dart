import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../../class/class.dart';
import '../../../../widget/nothig_found.dart';
import '../../../navigation/navigation.dart';

class DDApproval extends StatefulWidget {
  const DDApproval({super.key});

  @override
  State<DDApproval> createState() => _DDApprovalState();
}

class _DDApprovalState extends State<DDApproval> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  List userBranchList = [
    {"dname": "All", "did": ''}
  ];
  String? selectval;
  List<Map<String, dynamic>> depositListTemp = [];
  List pendingDDList = [];
  @override
  void initState() {
    data('');
    getUserBranch();
    setState(() {});
    // TODO: implement initState
    super.initState();
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

  data(String data) async {
    setState(() {
      isLoading = true;
    });
    var dataList = await CustomApi().ddApprovalScreen(context, data);


    setState(() {
      pendingDDList = dataList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => RefreshIndicator(
        onRefresh: () {
          return data('');
        },
        child: Scaffold(
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
                              "Select branch                                                         ",
                              style: TextStyle(color: black1),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          value:
                              selectval, //implement initial value or selected value
                          onChanged: (value) {
                            setState(() {
                              // _runFilter(value.toString());
                              // //set state will update UI and State of your App
                              // selectval = value.toString();
                              // print(value);
                              //change selectval to new value
                            });
                          },
                          items: userBranchList.map((itemone) {
                            return DropdownMenuItem(
                                onTap: () {
                                  data(itemone['did']);
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
                )),
            title: Text(
              'Pending DD',
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
          body: pendingDDList.isEmpty && isLoading == false
              ? Stack(
                  children: [
                    SizedBox(
                        height: h,
                        width: w,
                        child: Column(
                          children: [
                            Center(child: NoData()),
                          ],
                        )),
                    provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                  ],
                )
              : Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: pendingDDList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          // color: Color.fromARGB(255, 217, 238, 255),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          "- ${pendingDDList[index]['waybill_id']}",
                                          style: TextStyle(
                                            fontSize: 17.dp,
                                            color: black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text:
                                                      "${pendingDDList[index]['waybill_id']}"))
                                              .then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Copied to your waybill id !')));
                                          });
                                        },
                                        icon: Icon(Icons.copy))
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Client name",
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
                                      "- ${pendingDDList[index]['cust_name']}",
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
                                      "- ${pendingDDList[index]['name']}",
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
                                        "- ${pendingDDList[index]['address']} ",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      "- ${pendingDDList[index]['phone']}",
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
                                        "From Branch",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "- ${pendingDDList[index]['dispatch_to_b_name']}",
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
                                      "- ${pendingDDList[index]['dd_to_b_name']}",
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
                                    // SizedBox(
                                    //   width: 4,
                                    // ),
                                    Flexible(
                                      child: Text(
                                        "- ${pendingDDList[index]['status']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: DialogButton(
                                      text: 'Confirm',
                                      onTap: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          text: 'Do you want to Confirm',
                                          confirmBtnText: 'Yes',
                                          cancelBtnText: 'No',
                                          onConfirmBtnTap: () async {
                                            CustomApi().ddUpdate(context,
                                                pendingDDList[index]['oid']);
                                            data('');
                                            Navigator.pop(context);
                                          },
                                          confirmBtnColor: Colors.green,
                                        );
                                      },
                                      buttonHeight: h / 17,
                                      width: w / 3,
                                      color: Colors.cyan),
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
                    isLoading ? Loader().loader(context) : SizedBox(),
                    provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                  ],
                ),
        ),
      ),
    );
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
}
