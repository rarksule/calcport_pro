import 'dart:convert';

import '../models/app_user_model.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import 'main_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/common.dart';
import '../utils/constants.dart';

class UserInfo extends StatefulWidget {
  final bool init;
  const UserInfo({super.key, this.init = false});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordNode = FocusNode();
  final _emailNode = FocusNode();
  final _emailController = TextEditingController();
  final TextEditingController _iamController = TextEditingController();
  final TextEditingController _tokenIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    _emailController.dispose();
    _emailNode.dispose();
    _iamController.dispose();
    _tokenIdController.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App user'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  onTap: () async {
                    appUserData.accessToken.copyToClipboard();
                  },
                  child: Text("Copy accessData")),
              PopupMenuItem(
                  onTap: () async {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) async {
                      if (value?.text != null) {
                        appUserData.accessToken = value!.text!;
                        appUserData.accessExpireTime =
                            await getExpireTime(value.text!);
                        init(true);
                        setValue(APPUSERDATA, appUserData.toJson());
                      }
                    });
                  },
                  child: Text("Paste accessData")),
              PopupMenuItem(
                  onTap: () async {
                    String data = jsonEncode(appUserData.toJson());
                    data.copyToClipboard();
                  },
                  child: Text("Copy fullData")),
              PopupMenuItem(
                  onTap: () async {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) async {
                      if (value?.text != null) {
                        final authExpretime =  appUserData.authExpireTime;
                        appUserData =
                            AppUserModel.fromJson(jsonDecode(value!.text!));
                        appUserData.authExpireTime = authExpretime;
                        init(true);
                        setValue(APPUSERDATA, appUserData.toJson());
                      }
                    });
                  },
                  child: Text("paste fullData")),
            ];
          })
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              AppTextField(
                textFieldType: TextFieldType.PHONE,
                controller: _phoneController,
                focus: _phoneNode,
                nextFocus: _emailNode,
                decoration: myDecoration('phone'),
                textStyle: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                textFieldType: TextFieldType.EMAIL_ENHANCED,
                controller: _emailController,
                textStyle: TextStyle(color: Colors.white),
                focus: _emailNode,
                nextFocus: _passwordNode,
                decoration: myDecoration('email'),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: _passwordController,
                textStyle: TextStyle(color: Colors.white),
                focus: _passwordNode,
                nextFocus: _focusNode,
                isPassword: true,
                decoration: myDecoration('password'),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                textStyle: TextStyle(color: Colors.white),
                controller: _iamController,
                focus: _focusNode,
                nextFocus: _focusNode2,
                decoration: myDecoration('name'),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                textStyle: TextStyle(color: Colors.white),
                controller: _tokenIdController,
                focus: _focusNode2,
                decoration: myDecoration('tokenId'),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppButton(
        text: 'save',
        onTap: _save,
      ),
    );
  }

  _save() {
    if (formKey.currentState!.validate()) {
      appUserData.phone = _phoneController.text.trim();
      appUserData.password = _passwordController.text.trim();
      appUserData.email = _emailController.text.trim();
      appUserData.iam = _iamController.text.trim();
      appUserData.tokenId = _tokenIdController.text.trim();
      setValue(APPUSERDATA, appUserData.toJson());
    }
    if (!widget.init) {
      finish(context);
    } else {
      MainScreen().launch(context, isNewTask: true);
    }
  }

  void init([bool init = false]) async {
    if (init || !widget.init) {
      _iamController.text = appUserData.iam;
      _emailController.text = appUserData.email;
      _passwordController.text = appUserData.password;
      _phoneController.text = appUserData.phone;
      _tokenIdController.text = appUserData.tokenId;
    }
    setState(() {});
  }
}
