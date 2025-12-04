import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/common.dart';

class FormPage extends StatefulWidget {
  final UserModel? data;
  const FormPage({super.key, this.data});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _efNameController = TextEditingController();
  final _eNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _egNameController = TextEditingController();
  final _gNameController = TextEditingController();
  final _gfNameController = TextEditingController();
  final _ggNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthController = TextEditingController();
  final _idController = TextEditingController();
  final _efNameNode = FocusNode();
  final _eNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _egNameNode = FocusNode();
  final _gNameNode = FocusNode();
  final _gfNameNode = FocusNode();
  final _ggNameNode = FocusNode();
  final _dobNode = FocusNode();
  final _birthPlaceNode = FocusNode();
  final _emailNode = FocusNode();
  final _emailController = TextEditingController();
  int _genderController = 0;
  int _paymentController = 13;
  bool _isUnder18Controller = false;
  int _officeIdController = 33;
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionNode = FocusNode();
  final _cityNode = FocusNode();
  bool expand = false;

  @override
  void dispose() {
    _efNameController.dispose();
    _eNameController.dispose();
    _phoneController.dispose();
    _egNameController.dispose();
    _gNameController.dispose();
    _gfNameController.dispose();
    _ggNameController.dispose();
    _dobController.dispose();
    _birthPlaceController.dispose();
    _birthController.dispose();
    _idController.dispose();
    _efNameNode.dispose();
    _eNameNode.dispose();
    _phoneNode.dispose();
    _egNameNode.dispose();
    _gNameNode.dispose();
    _gfNameNode.dispose();
    _ggNameNode.dispose();
    _dobNode.dispose();
    _birthPlaceNode.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _regionNode.dispose();
    _cityNode.dispose();
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
        title: Text('user'),
        actions: [
          Icon(Icons.expand).onTap(() {
            setState(() {
              expand = !expand;
            });
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.paste_outlined).onTap(() => pasteData()),
          )
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
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.NAME,
                  controller: _eNameController,
                  nextFocus: _efNameNode,
                  focus: _eNameNode,
                  decoration: myDecoration('Name')),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  controller: _efNameController,
                  focus: _efNameNode,
                  nextFocus: _egNameNode,
                  textFieldType: TextFieldType.NAME,
                  decoration: myDecoration('Father Name')),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.NAME,
                  controller: _egNameController,
                  focus: _egNameNode,
                  nextFocus: _dobNode,
                  decoration: myDecoration('grand father name')),
              SizedBox(height: 16),
              AppTextField(
                textStyle: TextStyle(color: Colors.white),
                focus: _dobNode,
                nextFocus: _gNameNode,
                textFieldType: TextFieldType.OTHER,
                controller: _dobController,
                decoration: myDecoration('Birth Date'),
                validator: (val) {
                  var parsed = DateFormat("MM/dd/yyyy").tryParse(val ?? '');
                  if (parsed == null) {
                    return 'invalid format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.NAME,
                  controller: _gNameController,
                  focus: _gNameNode,
                  nextFocus: _gfNameNode,
                  decoration: myDecoration('ስም')),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.NAME,
                  controller: _gfNameController,
                  focus: _gfNameNode,
                  nextFocus: _ggNameNode,
                  decoration: myDecoration('የአባት ስም')),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.NAME,
                  controller: _ggNameController,
                  focus: _ggNameNode,
                  nextFocus: _phoneNode,
                  decoration: myDecoration('አያት ስም')),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.PHONE,
                  controller: _phoneController,
                  focus: _phoneNode,
                  keyboardType: TextInputType.number,
                  nextFocus: _birthPlaceNode,
                  decoration: myDecoration('phone'),
                  validator: (val) {
                    if (val.isEmptyOrNull) {
                      return 'required';
                    }
                    if (val!.isAlpha() || val.length != 10) {
                      return 'invalid value';
                    }
                    return null;
                  }),
              SizedBox(height: 16),
              AppTextField(
                  textStyle: TextStyle(color: Colors.white),
                  textFieldType: TextFieldType.OTHER,
                  controller: _birthPlaceController,
                  focus: _birthPlaceNode,
                  decoration: myDecoration('birth place')),
              Offstage(
                offstage: !expand,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    AppTextField(
                        textStyle: TextStyle(color: Colors.white),
                        textFieldType: TextFieldType.EMAIL_ENHANCED,
                        controller: _emailController,
                        focus: _emailNode,
                        validator: (val) {
                          if (val.isEmptyOrNull) {
                            _emailController.text =
                                '${_eNameController.text.capitalizeFirstLetter()}${_efNameController.text.toLowerCase()}${random.nextInt(10) + 1}@gmail.com';
                          }
                          return null;
                        },
                        decoration: myDecoration('email')),
                  ],
                ),
              ),
              Offstage(
                offstage: !expand,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    AppTextField(
                        textStyle: TextStyle(color: Colors.white),
                        textFieldType: TextFieldType.NAME,
                        controller: _regionController,
                        focus: _regionNode,
                        nextFocus: _cityNode,
                        validator: (value) {
                          if (value.isEmptyOrNull) {
                            _regionController.text =
                                officeRegion[_officeIdController] ?? '';
                          }
                          if (_regionController.text.isEmptyOrNull) {
                            return "required";
                          }
                          return null;
                        },
                        decoration: myDecoration('Region')),
                    SizedBox(height: 16),
                    AppTextField(
                        textStyle: TextStyle(color: Colors.white),
                        textFieldType: TextFieldType.NAME,
                        controller: _cityController,
                        focus: _cityNode,
                        validator: (value) {
                          if (value.isEmptyOrNull) {
                            _cityController.text = cities
                                .firstWhere(
                                    (c) => c.officeId == _officeIdController)
                                .label;
                          }
                          if (_cityController.text.isEmptyOrNull) {
                            return "required";
                          }
                          return null;
                        },
                        decoration: myDecoration('City')),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    width: (context.width() * 0.4),
                    enableSearch: false,
                    initialSelection: _officeIdController,
                    onSelected: (val) {
                      _officeIdController = val ?? 33;
                    },
                    dropdownMenuEntries: cities
                        .map((e) => DropdownMenuEntry(
                            label: e.label, value: e.officeId))
                        .toList(),
                  ),
                  SizedBox(width: 8),
                  DropdownMenu(
                      width: (context.width() * 0.4),
                      enableSearch: false,
                      initialSelection: _genderController,
                      onSelected: (val) {
                        _genderController = val ?? _genderController;
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(label: 'Female', value: 0),
                        DropdownMenuEntry(label: 'Male', value: 1),
                      ]),
                ],
              ),
              SizedBox(height: 16),
              Offstage(
                offstage: !expand,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenu(
                        width: (context.width() * 0.4),
                        enableSearch: false,
                        initialSelection: _isUnder18Controller,
                        onSelected: (val) {
                          _isUnder18Controller = val ?? _isUnder18Controller;
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(label: 'Above18', value: false),
                          DropdownMenuEntry(label: 'under18', value: true),
                        ]),
                    SizedBox(width: 8),
                    DropdownMenu(
                        width: (context.width() * 0.4),
                        enableSearch: false,
                        initialSelection: _paymentController,
                        onSelected: (val) {
                          _paymentController = val ?? _paymentController;
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(label: 'TeleBirr', value: 17),
                          DropdownMenuEntry(label: 'CBE Birr', value: 9),
                          DropdownMenuEntry(label: 'CBE Mobile', value: 13),
                        ]),
                  ],
                ),
              ),
              if (expand) SizedBox(height: 16),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () async {
                          var result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.image,
                          ); //ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
                          if (result != null &&
                              result.files.firstOrNull != null) {
                            _idController.text = result.files.first.path!;
                            setState(() {});
                          }
                        },
                        child: _idController.text.isEmptyOrNull
                            ? Center(
                                child: FittedBox(child: Text(" Select id")))
                            : kIsWeb
                                ? FittedBox(
                                    child: Text("Loaded birth certificate"))
                                : Image.file(File(_idController.text))),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                        onTap: () async {
                          var result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.image,
                          ); //ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

                          if (result != null &&
                              result.files.firstOrNull != null) {
                            _birthController.text = result.files.first.path!;
                            log("\n\n\n\n\n\n\n _birthController.text : ${_birthController.text}\n\n\n\n\n\n\n");
                            setState(() {});
                          }
                        },
                        child: _birthController.text.isEmptyOrNull
                            ? Center(
                                child:
                                    FittedBox(child: Text("birth certificate")))
                            : kIsWeb
                                ? FittedBox(
                                    child: Text("Loaded birth certificate"))
                                : Image.file(
                                    File(_birthController.text),
                                  )),
                  ),
                ],
              ),
              SizedBox(height: 16),
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
      if (!_idController.text.isEmptyOrNull &&
          !_birthController.text.isEmptyOrNull) {
        final UserModel userData = UserModel(
          eName: _eNameController.text.toUpperCase(),
          efName: _efNameController.text.toUpperCase(),
          egName: _egNameController.text.toUpperCase(),
          dob: DateFormat("yyyy-MM-dd")
              .format(DateFormat("MM/dd/yyyy").parse(_dobController.text)),
          gName: _gNameController.text,
          gfName: _gfNameController.text,
          ggName: _ggNameController.text,
          phone: _phoneController.text,
          birthPath: _birthController.text,
          idPath: _idController.text,
          gender: _genderController,
          email: _emailController.text,
          isUnder18: _isUnder18Controller,
          birthPlace: _birthPlaceController.text,
          payment: _paymentController,
          city: _cityController.text,
          uid: DateTime.now().millisecondsSinceEpoch.toString(),
          region: _regionController.text,
          location: cities.firstWhere((c) => c.officeId == _officeIdController),
          appointment: widget.data?.appointment ?? AppointmentStatusModel(),
        );
        finish(context, userData);
      } else {
        toast('select pic');
      }
    }
  }

  void pasteData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      final userDataList = data.text.splitAfter('\n').split('\n\n');
      _eNameController.text = userDataList[0];
      _efNameController.text = userDataList[1];
      _egNameController.text = userDataList[2];
      _dobController.text = userDataList[3];
      _gNameController.text = userDataList[4];
      _gfNameController.text = userDataList[5];
      _ggNameController.text = userDataList[6];
      _phoneController.text = userDataList[7];
      _birthPlaceController.text = userDataList[8];
      if (userDataList.length == 11) {
        _regionController.text = userDataList[9];
        _cityController.text = userDataList[10];
      } else if (userDataList.length == 10) {
        _regionController.text = Oromia;
        _cityController.text = userDataList[9];
      }
      setState(() {});
    }
  }

  void init() async {
    if (widget.data != null) {
      _eNameController.text = widget.data!.eName;
      _emailController.text = widget.data!.email;
      _efNameController.text = widget.data!.efName;
      _egNameController.text = widget.data!.egName;
      _dobController.text = DateFormat("MM/dd/yyyy")
          .format(DateFormat("yyyy-MM-dd").parse(widget.data!.dob));
      _gNameController.text = widget.data!.gName;
      _gfNameController.text = widget.data!.gfName;
      _ggNameController.text = widget.data!.ggName;
      _phoneController.text = widget.data!.phone;
      _birthPlaceController.text = widget.data!.birthPlace;
      _birthController.text = await File(widget.data!.birthPath).exists()
          ? widget.data!.birthPath
          : '';
      _idController.text =
          await File(widget.data!.idPath).exists() ? widget.data!.idPath : '';
      _genderController = widget.data!.gender;
      _paymentController = widget.data!.payment;
      _regionController.text = widget.data!.region;
      _isUnder18Controller = widget.data!.isUnder18;
      _cityController.text = widget.data!.city;
      _officeIdController = widget.data!.location.officeId;
    }
    setState(() {});
  }
}
