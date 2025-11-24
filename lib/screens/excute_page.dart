import '../main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/user_model.dart';
import '../utils/common.dart';
import '../utils/network.dart';
import 'user_info.dart';

class ExcutePage extends StatefulWidget {
  const ExcutePage({super.key});

  @override
  State<ExcutePage> createState() => _ExcutePageState();
}

class _ExcutePageState extends State<ExcutePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  UserModel? userData = users.data.firstOrNull;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appUserData.email,
          style: TextStyle(color: appUserData.isValid ? greenYellow : null),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              UserInfo().launch(context);
            },
          ),
          Observer(builder: (context) {
            return Text(
              state.tokens.data.length.toString(),
            );
          }),
          8.width,
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: AppTextField(
                            textFieldType: TextFieldType.OTHER,
                            controller: _controller,
                            textStyle: TextStyle(color: white),
                            suffix: Icon(Icons.paste).onTap(() {
                              Clipboard.getData(Clipboard.kTextPlain)
                                  .then((value) async {
                                if (value?.text != null) {
                                  _controller.text = value!.text!;
                                }
                              });
                              setState(() {});
                            }),
                            decoration: myDecoration('Code')),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownMenu(
                          enableSearch: false,
                          initialSelection: userData,
                          onSelected: (val) {
                            setState(() {
                              userData = val ?? userData;
                            });
                          },
                          dropdownMenuEntries: users.data
                              .map((e) => DropdownMenuEntry(
                                  label: "${e.eName} ${e.efName}", value: e))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 0,
                  children: [
                    Container(
                      decoration: buttonDecoration(
                        false,
                        'left',
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (_controller.text.isNotEmpty) {
                            state.setLoading(true);
                          }
                          if (_controller.text.isNotEmpty) {
                            await userData!.pay(_controller.text);
                          }
                          state.setLoading(false);
                        },
                        child: SizedBox(
                          width: (context.width() * 0.22),
                          height: ButtonTheme.of(context).height,
                          child: Center(
                            child: Text(
                              'PAYMENT',
                              softWrap: false,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: buttonDecoration(
                        false,
                        '',
                      ),
                      child: InkWell(
                        onTap: () async {
                          state.setLoading(true);
                          if (_controller.text.isNotEmpty) {
                            await userData!.upload(_controller.text);
                          }
                          state.setLoading(false);
                        },
                        child: SizedBox(
                          width: (context.width() * 0.22),
                          height: ButtonTheme.of(context).height,
                          child: Center(
                            child: Text(
                              'UPLOAD',
                              softWrap: false,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: buttonDecoration(
                        false,
                        '',
                      ),
                      child: InkWell(
                        onTap: () async {
                          state.setLoading(true);
                          await signInApi().then((val) {
                            if (val) {
                              processError('request Done');
                            } else {
                              processError('request failed');
                            }
                          }).catchError((onError) {
                            processError(onError);
                          });
                          state.setLoading(false);
                        },
                        child: SizedBox(
                          width: (context.width() * 0.22),
                          height: ButtonTheme.of(context).height,
                          child: Center(
                            child: Text(
                              appUserData.isValid ? "OK" : 'SIGN IN',
                              softWrap: false,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: buttonDecoration(false, 'right'),
                      child: InkWell(
                        onTap: () async {
                          if (_controller.text.isNotEmpty) {
                            state.setLoading(true);
                          }
                          await validateOTPApi(
                            _controller.text,
                          ).then((val) {
                            if (val) {
                              processError('request Done');
                            } else {
                              processError('request failed');
                            }
                          }).catchError((onError) {
                            processError(onError);
                          });

                          setState(() {});
                          state.setLoading(false);
                        },
                        child: SizedBox(
                          width: (context.width() * 0.22),
                          height: ButtonTheme.of(context).height,
                          child: Center(
                            child: Text(
                              "VerifyOtp",
                              softWrap: false,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Saved Datas'),
                    if (dataCollection.isNotEmpty)
                      Row(
                        children: [
                          Text('Codes Collection'),
                          Icon(Icons.copy_all_outlined).onTap(() {
                            Clipboard.setData(ClipboardData(
                                text: dataCollection
                                    .map((e) =>
                                        "${e.name} \n ${e.status.applicationNumber ?? "--"}\n${e.status.paymentCode ?? ''}")
                                    .toList()
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(',', '')
                                    .replaceAll(']', '')));
                          }),
                        ],
                      ),
                  ],
                ),
                Divider(),
                24.height,
                dataCollection.isEmpty
                    ? Text(
                        'No Data',
                        style: boldTextStyle(size: 24),
                      )
                    : SizedBox(),
                ...dataCollection.map(
                  (e) {
                    var name = e.name;
                    var appt = e.status;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(appt.applicationNumber ?? '--'),
                                SelectableText("   ${appt.paymentCode ?? ''}"),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("paycode ${appt.requestId?.short ?? '--'}  |   ")
                                    .onTap(() {
                                  Clipboard.setData(ClipboardData(
                                      text: appt.requestId ?? ''));
                                }),
                                Text("upload ${appt.personId?.short ?? "--"}")
                                    .onTap(() {
                                  Clipboard.setData(ClipboardData(
                                      text: appt.requestId ?? ''));
                                }),
                              ],
                            ),
                          ],
                        ),
                        8.width,
                        Icon(Icons.copy_outlined).onTap(() {
                          Clipboard.setData(ClipboardData(
                              text:
                                  "${appt.applicationNumber ?? ''}\n${appt.paymentCode ?? ''}"));
                        }),
                      ],
                    );
                  },
                ),
                64.height,
              ],
            ),
          ),
          Observer(builder: (context) {
            return Visibility(
              visible: state.isLoading,
              child: const Center(
                child: CupertinoActivityIndicator(
                  color: Color.fromARGB(255, 255, 255, 255),
                  radius: 16,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
