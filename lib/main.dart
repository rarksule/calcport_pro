import 'dart:math';

import '/models/url_manager_model.dart';
import '/store/app_store.dart';
import 'package:mobx/mobx.dart';

import '/models/token_model.dart';
import '/models/user_model.dart';
import '/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'models/app_user_model.dart';
import 'models/request_decoder.dart';
import 'screens/cacl_scree.dart';
// import 'utils/common.dart';

AppUserModel appUserData = AppUserModel(
  iam: '',
  tokenId: '',
  email: '',
  phone: '',
  password: '',
  accessToken: anonymous,
  accessExpireTime: DateTime.now(),
  authExpireTime: DateTime.now(),
  remoteCode: '',
);
AppStore state = AppStore();
TokensListModel invalidTokens =
    TokensListModel(data: ObservableList<TokenModel>.of([]));
UrlManagerModel stateUrl = UrlManagerModel();
UsersListModel users = UsersListModel(data: [], offices: <int>{});
Set<DataCollectionModel> dataCollection = {};
Random random = Random();
LiveStream myStream = LiveStream();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  appUserData = getJSONAsync(APPUSERDATA).isNotEmpty
      ? AppUserModel.fromJson(getJSONAsync(APPUSERDATA))
      : appUserData;
  stateUrl = getJSONAsync('URL_MANAGER').isNotEmpty
      ? UrlManagerModel.fromJson(getJSONAsync('URL_MANAGER'))
      : stateUrl;
      // createDioWithMultipleCerts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          title: 'Claculator',
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            iconTheme: IconThemeData(color: Colors.grey),
            colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.dark, seedColor: Colors.white),
            primaryTextTheme: TextTheme(
                displayLarge: TextStyle(color: Colors.white),
                displayMedium: TextStyle(color: Colors.white),
                displaySmall: TextStyle(color: Colors.white)),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
          ),
          home: Calculator()),
    );
  }
}
