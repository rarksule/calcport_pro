import 'package:calcport/utils/common.dart';
import 'package:calcport/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class UrlManagerScreen extends StatefulWidget {
  const UrlManagerScreen({super.key});

  @override
  State<UrlManagerScreen> createState() => _UrlManagerScreenState();
}

class _UrlManagerScreenState extends State<UrlManagerScreen> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        setValue('URL_MANAGER', stateUrl.toJson());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Url Manager"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Appointment",
                  style: boldTextStyle(color: Colors.amber),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("legacy"),
                    Switch(
                        value: stateUrl.legacyAppointment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.legacyAppointment = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentUrl"),
                    Switch(
                        value: stateUrl.urgentUrlAppointment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentUrlAppointment = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentHost"),
                    Switch(
                        value: stateUrl.urgentHostAppointment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentHostAppointment = val;
                          });
                        })
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Text(
                  "Request",
                  style: boldTextStyle(color: Colors.amber),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("legacy"),
                    Switch(
                        value: stateUrl.legacyRequest,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.legacyRequest = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentUrl"),
                    Switch(
                        value: stateUrl.urgentUrlRequest,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentUrlRequest = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentHost"),
                    Switch(
                        value: stateUrl.urgentHostRequest,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentHostRequest = val;
                          });
                        })
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Text(
                  "Upload",
                  style: boldTextStyle(color: Colors.amber),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("legacy"),
                    Switch(
                        value: stateUrl.legacyUpload,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.legacyUpload = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentUrl"),
                    Switch(
                        value: stateUrl.urgentUrlUpload,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentUrlUpload = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentHost"),
                    Switch(
                        value: stateUrl.urgentHostUpload,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentHostUpload = val;
                          });
                        })
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Text(
                  "Payment",
                  style: boldTextStyle(color: Colors.amber),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("legacy"),
                    Switch(
                        value: stateUrl.legacyPayment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.legacyPayment = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentUrl"),
                    Switch(
                        value: stateUrl.urgentUrlPayment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentUrlPayment = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UrgentHost"),
                    Switch(
                        value: stateUrl.urgentHostPayment,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.urgentHostPayment = val;
                          });
                        })
                  ],
                ),
                Divider(
                  thickness: 2,
                ),
                Text(
                  "More",
                  style: boldTextStyle(color: Colors.amber),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Use Dio"),
                    Switch(
                        value: stateUrl.useDio,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.useDio = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("No Host"),
                    Switch(
                        value: stateUrl.withNoHost,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.withNoHost = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("No Header"),
                    Switch(
                        value: stateUrl.noHeaders,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.noHeaders = val;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Is Local"),
                    Switch(
                        value: stateUrl.isLocal,
                        onChanged: (val) {
                          setState(() {
                            stateUrl.isLocal = val;
                          });
                        })
                  ],
                ),
                if(stateUrl.isLocal)
                AppTextField(textFieldType: TextFieldType.OTHER,
                initialValue: localurl,
                decoration: myDecoration("LocalUrl"),
                textStyle: TextStyle(color: mypurple),
                onChanged: (p0){
                  localurl = p0;
                },
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
