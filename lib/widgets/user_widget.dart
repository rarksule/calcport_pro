import '../models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/form_page.dart';
import '../utils/common.dart';
import '../utils/constants.dart';

class UserWidget extends StatefulWidget {
  final UserModel user;
  const UserWidget({super.key, required this.user});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  void initState() {
    super.initState();
    liveStream.on(setStateM, (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                var updateData = await FormPage(
                  data: user,
                ).launch(context);
                if (updateData != null) {
                  updateUser(user, updateData);
                }
              },
              onLongPress: () async {
                removeUser(user);
              },
              child: Text(
                "${user.eName} ${user.efName}",
                style: boldTextStyle(
                    size: 16, color: Color.fromARGB(255, 255, 105, 255)),
              ),
            ),
            16.width,
            InkWell(
              onTap: () async {
                copyuser(user);
              },
              onLongPress: () async {
                copyuser(user, true);
              },
              child: Icon(
                Icons.copy_outlined,
                size: 16,
              ),
            ),
            16.width,
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 0,
          children: [
            Container(
              decoration:
                  buttonDecoration(user.appointment.appointCode, 'left'),
              child: InkWell(
                onLongPress: () async {
                  Clipboard.setData(
                      ClipboardData(text: user.appointment.appointCode!));
                },
                onTap: () async {
                  ClipboardData? data =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  if (data != null) {
                    user.appointment.appointCode = data.text;
                    setState(() {});
                  }
                },
                child: SizedBox(
                  width: (context.width() * 0.19),
                  height: ButtonTheme.of(context).height,
                  child: Center(
                    child: user.appointment.appointCode != null
                        ? Text(user.appointment.appointCode!.short)
                        : Text(
                            'APNTMT',
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
              decoration:
                  buttonDecoration(user.appointment.applicationNumber, ''),
              child: InkWell(
                onTap: () {
                  if (user.appointment.appointCode != null) {
                    user.request();
                  }
                },
                child: SizedBox(
                  width: (context.width() * 0.19),
                  height: ButtonTheme.of(context).height,
                  child: Center(
                    child: Text(
                      user.appointment.applicationNumber ?? 'RQST',
                      softWrap: false,
                      style: TextStyle(
                          overflow: TextOverflow.clip, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration:
                  buttonDecoration(user.appointment.idImagePath != null, ''),
              child: InkWell(
                onLongPress: () {
                  setState(() {
                    user.appointment.appointCode = null;
                  });
                },
                onTap: () async {
                  if (user.appointment.personId != null) {
                    await user.upload();
                    if (!mounted) return;
                    setState(() {});
                  }
                },
                child: SizedBox(
                  width: (context.width() * 0.19),
                  height: ButtonTheme.of(context).height,
                  child: Center(
                    child: Text(
                      user.appointment.idImagePath != null ? 'Done' : 'UPLD',
                      softWrap: false,
                      style: TextStyle(
                          overflow: TextOverflow.clip, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: buttonDecoration(user.appointment.paymentCode, ''),
              child: InkWell(
                onTap: () {
                  if (user.appointment.requestId != null) {
                    user.pay();
                  }
                },
                child: SizedBox(
                  width: (context.width() * 0.19),
                  height: ButtonTheme.of(context).height,
                  child: Center(
                    child: Text(
                      user.appointment.paymentCode ?? 'PAY',
                      softWrap: false,
                      style: TextStyle(
                          overflow: TextOverflow.clip, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: buttonDecoration(user.appointment.isSynced, 'right'),
              child: InkWell(
                onTap: () async {
                  if (user.appointment.paymentCode != null &&
                      !user.appointment.isSynced) {
                    // user.appointment.isSynced = await updateUserData(user);
                    setState(() {});
                  }
                },
                child: SizedBox(
                  width: (context.width() * 0.15),
                  height: ButtonTheme.of(context).height,
                  child: Center(
                    child: Text(
                      user.appointment.isSynced ? "OK" : 'SYNC',
                      softWrap: false,
                      style: TextStyle(
                          overflow: TextOverflow.clip, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
