import 'dart:async';

import '../models/request_count_model.dart';
import 'excute_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../utils/network.dart';
import '../widgets/request_count_widget.dart';
import '../widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/token_model.dart';
import '../utils/common.dart';
import '../utils/constants.dart';
import '../widgets/time.dart';
import 'form_page.dart';
import 'log_screen.dart';
import 'tokens_page.dart';
import 'url_manager_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late io.Socket socket;
  Timer? _reconnectTimer;
  bool websocketConnected = false;
  bool orderingUsers = false;
  UserModel? orderableUser;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    if (getJSONAsync(USERS).isNotEmpty) {
      users = UsersListModel.fromJson(getJSONAsync(USERS));
    }

    socket = io.io('https://test.rarksule.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('disconnect', (val) {
      log('Disconnected websocket');
      setState(() {
        websocketConnected = false;
      });
      _tryReconnect();
    });

    socket.on('connect', (_) {
      log('Connected websocket');
      setState(() {
        websocketConnected = true;
      });
    });

    _tryReconnect();

    socket.on('GetToken', (data) {
      if (data != null && data["user"] == appUserData.tokenId) {
        state.addToken(TokenModel(
            expireTime: DateTime.now().add(Duration(minutes: 4, seconds: 50)),
            id: data["token"]
                .toString()
                .short, //random.nextInt(16777216).toRadixString(16),
            value: data["token"]));
      }
    });

    myStream.on(setStateU, (_) {
      setState(() {});
    });
  }

  void _tryReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;
    _reconnectTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (socket.connected) {
        timer.cancel();
      } else {
        log('Attempting to reconnect...');
        socket.connect();
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () async {
              socket.disconnect();
            },
            onLongPress: () => UrlManagerScreen().launch(context),
            child: Column(
              children: [TimeWidget(), RequestCount()],
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.folder_shared_outlined,
                color: appUserData.isValid ? greenYellow : Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => restore(),
                    child: Text('From1File'),
                  ),
                  PopupMenuItem(
                    onTap: () => save(),
                    child: Text('To1File'),
                  ),
                  PopupMenuItem(
                    onTap: () => restore(true),
                    child: Text('FromFiles'),
                  ),
                  PopupMenuItem(
                    onTap: () => save(true),
                    child: Text('ToFiles'),
                  ),
                  PopupMenuItem(
                    onTap: () => orderUsers(),
                    child: Text('OrderUsers'),
                  ),
                ];
              }),
        ],
        leading: InkWell(
            onLongPress: () => LogScreen().launch(context),
            onTap: () => ExcutePage().launch(context),
            child: Icon(
              Icons.window,
              color: websocketConnected ? greenYellow : Colors.red,
            )),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        var data = await FormPage().launch(context);
                        if (data != null) {
                          saveUser(data);
                        }
                        setState(() {});
                      },
                      child: Text(
                        "Add User",
                        style: boldTextStyle(size: 21, color: Colors.white),
                      ),
                    ),
                    16.width,
                    InkWell(
                      onTap: () async {
                        pasteUser();
                      },
                      onLongPress: () {
                        pasteUser(true);
                      },
                      child: Icon(Icons.paste_outlined),
                    ),
                  ],
                ),
                InkWell(
                  onLongPress: () => clearState(),
                  onTap: () {
                    setState(() {});
                  },
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                ...users.data.map((
                  user,
                ) =>
                    orderingUsers
                        ? InkWell(
                            onTap: () {
                              orderableUser = user;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: user == orderableUser
                                          ? Colors.amber
                                          : Colors.transparent,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: UserWidget(user: user)))
                        : UserWidget(user: user)),
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
      bottomNavigationBar: orderingUsers
          ? BottomNavigationBar(
              onTap: (index) {
                if (index == 0) {
                  if (orderableUser == null) toast("Select a user to move up");
                  int userIndex = users.data.indexOf(orderableUser!);
                  if (userIndex <= 0) return;
                  users.data
                      .insert(userIndex - 1, users.data.removeAt(userIndex));
                } else if (index == 1) {
                  if (orderableUser == null) toast("Select a user to move up");
                  int userIndex = users.data.indexOf(orderableUser!);
                  if (userIndex >= users.data.length - 1) return;
                  users.data
                      .insert(userIndex + 1, users.data.removeAt(userIndex));
                } else if (index == 2) {
                  setValue(USERS, users.toJson());
                  orderingUsers = false;
                }
                setState(() {});
              },
              items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_upward_outlined),
                    label: 'Move Up',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_downward), label: 'Move Down'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle), label: 'Done'),
                ])
          : InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...users.offices.map(
                          (e) => Container(
                            decoration: buttonDecoration(false, 'rightleft'),
                            margin: EdgeInsets.only(left: 8),
                            child: InkWell(
                              onLongPress: () async {
                                await TokensPage().launch(context);
                                setState(() {});
                              },
                              onTap: () async {
                                if (stateTokens.data.isNotEmpty) {
                                  await submitAppointment(e);
                                  setState(() {});
                                }
                              },
                              child: SizedBox(
                                width: (context.width() * 0.2),
                                height: ButtonTheme.of(context).height,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        cities
                                            .firstWhere((c) => c.officeId == e)
                                            .label,
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      Observer(builder: (context) {
                                        return Text(
                                          "${state.tokensLength} APTM",
                                          softWrap: false,
                                          style: TextStyle(
                                              overflow: TextOverflow.visible,
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                  ],
                ),
              ),
            ),
    );
  }

  submitAppointment(int officeId) async {
    state.requestChanged(RequestType.appointment);
    await submitAppointmentApi(officeId).then((data) {
      applyAppointmentToUsers(officeId, data);
    }).catchError((error) {
      processError(error);
    });
    state.requestChanged(RequestType.appointment, false);
    setState(() {});
  }

  void applyAppointmentToUsers(
    int officeId,
    String apptCode,
  ) async {
    final usersT = users.data
        .where((e) =>
            e.appointment.appointCode == null &&
            e.location.officeId == officeId)
        .toList();
    var userT = usersT.firstOrNull;
    try {
      if (users.data.any((usr) => usr.appointment.appointCode == apptCode)) {
        return;
      }
      retrivedappointments.update(officeId, (values) {
        values.add(apptCode);
        return values;
      }, ifAbsent: () {
        final values = <String>{};
        values.add(apptCode);
        return values;
      });
    } catch (e) {
      //
    }
    userT?.appointment.appointCode = apptCode;
    setState(() {});
    userT?.request();
  }

  clearState() {
    for (var e in users.data) {
      e.appointment.applicationNumber = null;
      e.appointment.appointCode = null;
      e.appointment.paymentCode = null;
      e.appointment.birthImagePath = null;
      e.appointment.idImagePath = null;
      e.appointment.personId = null;
      e.appointment.requestId = null;
      e.appointment.isSynced = false;
    }
    setState(() {});
  }

  orderUsers() {
    setState(() {
      orderingUsers = true;
    });
  }
}
