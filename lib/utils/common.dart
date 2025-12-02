import 'dart:convert';
import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../models/user_model.dart';
import 'constants.dart';
// import 'network.dart';

InputDecoration myDecoration(String label) => InputDecoration(
      labelText: label,
      hintText: label,
      border: OutlineInputBorder(),
      fillColor: Colors.green.shade100,
    );

void processError(error) {
  log("\n\n\n\n${error.toString()}\n\n\n");
  try {
    toast(error,
        gravity: ToastGravity.TOP,
        textColor: const Color.fromARGB(255, 0, 255, 0),
        bgColor: Colors.transparent);
  } catch (e) {
    log(e);
    toast('Some thing went wrong',
        gravity: ToastGravity.TOP,
        textColor: const Color.fromARGB(255, 0, 255, 0),
        bgColor: Colors.transparent);
  }
}

void getUniquelocation() {
  users.offices = users.data.map((user) => user.location.officeId).toSet();
  setValue(USERS, users.toJson());
  myStream.emit(setStateU);
}

buttonDecoration(colorFactor, String position, [Color? altColor]) {
  return BoxDecoration(
      border: Border(
        top: BorderSide(color: mypurple),
        left: position.contains('left')
            ? BorderSide(color: mypurple)
            : BorderSide.none,
        right: position.contains('right')
            ? BorderSide(color: mypurple)
            : BorderSide.none,
        bottom: BorderSide(color: mypurple),
      ),
      borderRadius: BorderRadius.only(
        bottomRight:
            position.contains('right') ? Radius.circular(30) : Radius.zero,
        topRight:
            position.contains('right') ? Radius.circular(30) : Radius.zero,
        topLeft: position.contains('left') ? Radius.circular(30) : Radius.zero,
        bottomLeft:
            position.contains('left') ? Radius.circular(30) : Radius.zero,
      ),
      color: colorFactor != null && colorFactor != false
          ? Color.fromARGB(255, 0, 150, 0)
          : altColor);
}

void saveUser(UserModel userData) {
  userData.uid = DateTime.now().millisecondsSinceEpoch.toString();
  users.data.insert(0, userData);
  getUniquelocation();
}

updateUser(UserModel userData, UserModel update) {
  int i = users.data.indexWhere((u) => u.uid == userData.uid);
  update.uid = userData.uid;
  users.data[i] = update;
  getUniquelocation();
}

removeUser(UserModel userData) {
  users.data.removeWhere((e) => e.uid == userData.uid);
  getUniquelocation();
}

Future<void> copyuser(UserModel user, [file = false]) async {
  state.setLoading(true);

  if (file) {
    user.idImage = await encodeImage(user.idPath);
    user.birthImage = await encodeImage(user.birthPath);
    String usersEncode = jsonEncode(user.toJson());
    String users64encoded = base64Encode(utf8.encode(usersEncode));
    Uint8List bytes = utf8.encode(users64encoded);
    await FilePicker.platform.saveFile(
        type: FileType.custom,
        fileName: '${user.eName} ${user.efName}.clc',
        bytes: bytes);
  } else {
    user.birthImage = user.idImage = null;
    String usersEncode = jsonEncode(user.toJson());
    Clipboard.setData(ClipboardData(text: usersEncode));
  }
  state.setLoading(false);
}

Future<void> pasteUser([bool file = false]) async {
  state.setLoading(true);
  if (file) {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['clc', 'txt']);
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        final file = File(filePath);
        Uint8List u8Data = base64Decode(await file.readAsString());
        String content = utf8.decode(u8Data);
        final userjson = jsonDecode(content);
        decodeImage(userjson['birthImage'], userjson['birthPath']);
        decodeImage(userjson['idImage'], userjson['idPath']);
        saveUser(UserModel.fromJson(userjson));
      }
    }
  } else {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      final user = UserModel.fromJson(jsonDecode(data!.text!));
      user.uid = DateTime.now().millisecondsSinceEpoch.toString();
      saveUser(user);
    }
  }
  state.setLoading(false);
}

encodeImage(String path) async {
  final File file = File(path);
  final List<int> originalBytes = await file.readAsBytes();
  final List<int> compressed =
      GZipCodec(level: ZLibOption.maxLevel).encode(originalBytes);
  final String compressedBase64 = base64Encode(compressed);
  return compressedBase64;
}

decodeImage(String base64String, String path) async {
  // Decode the Base64 string
  final List<int> compressed = base64Decode(base64String);
  final List<int> decompressed =
      GZipCodec(level: ZLibOption.maxLevel).decode(compressed);

  File file = File(path);
  // Ensure parent directory exists
  await file.parent.create(recursive: true);
  await file.writeAsBytes(decompressed);
}

save([bool multiple = false]) async {
  state.setLoading(true);
  if (multiple) {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      toast("Storage permission denied");
      // setState(() => isLoading = false);
      return;
    }
    String? path = await FilePicker.platform.getDirectoryPath();
    for (var user in users.data) {
      user.idImage = await encodeImage(user.idPath);
      user.birthImage = await encodeImage(user.birthPath);
      String users64encoded =
          base64Encode(utf8.encode(jsonEncode(user.toJson())));
      File file = File("$path/${user.eName} ${user.efName}.clc");
      await file.writeAsString(users64encoded);
    }
    toast("usersSaved at $path/");
  } else {
    for (var el in users.data) {
      el.idImage = await encodeImage(el.idPath);
      el.birthImage = await encodeImage(el.birthPath);
    }
    String users64encoded =
        base64Encode(utf8.encode(jsonEncode(users.toJson())));
    Uint8List bytes = utf8.encode(users64encoded);
    await FilePicker.platform
        .saveFile(type: FileType.custom, fileName: 'users.clc', bytes: bytes);
  }
  state.setLoading(false);
}

restore([bool multiple = false]) async {
  state.setLoading(true);
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: multiple,
    allowedExtensions: ['clc', 'txt'],
  );
  if (multiple) {
    if (result != null && result.files.isNotEmpty) {
      for (var f in result.files) {
        if (f.path != null) {
          final file = File(f.path!);
          Uint8List u8Data = base64Decode(await file.readAsString());
          String content = utf8.decode(u8Data);
          final userjson = jsonDecode(content);
          decodeImage(userjson['birthImage'], userjson['birthPath']);
          decodeImage(userjson['idImage'], userjson['idPath']);
          saveUser(UserModel.fromJson(userjson));
        }
      }
    }
  } else {
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        // Read the file content
        final file = File(filePath);
        String content = await file.readAsString();

        Uint8List data = base64Decode(content);
        content = utf8.decode(data);
        final usersjson = jsonDecode(content);
        final userslistData = UsersListModel.fromJson(usersjson);

        // Ensure images are decoded/written to disk for each restored user
        for (var u in userslistData.data) {
          try {
            if (!u.birthImage.isEmptyOrNull) {
              await decodeImage(u.birthImage!, u.birthPath);
            }
            if (!u.idImage.isEmptyOrNull) {
              await decodeImage(u.idImage!, u.idPath);
            }
          } catch (e) {
            log('Failed to decode image for user ${u.uid}: $e');
          }
        }

        users.data.addAll(userslistData.data);
      } // Return the content as a string
    }
  }
  getUniquelocation();
  state.setLoading(false);
}

extension SHORTNER on String {
  String get short => substring(2, 8);
}

Future<DateTime> getExpireTime(String accessToken) async {
  try {
    final parts = accessToken.split('.');
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload) as Map<String, dynamic>;
    final exp = payloadMap['exp'];
    final utcTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return utcTime;
  } catch (e) {
    log('Error parsing JWT: $e');
    return DateTime.now().add(Duration(minutes: 10));
  }
}

// Future<Dio> createDioWithMultipleCerts() async {
  // Create security context with NO default roots
  // final context = SecurityContext(withTrustedRoots: true);

  // // Load first certificate (HTTP Toolkit .crt)
  // final cert1 = await rootBundle.load('cert.crt');
  // context.setTrustedCertificatesBytes(cert1.buffer.asUint8List());

  // // Load second certificate (BurpSuite .der)
  // final cert2 = await rootBundle.load('cacert.crt');
  // context.setTrustedCertificatesBytes(cert2.buffer.asUint8List());

  // Add more certificates here if needed
  // final cert3 = await rootBundle.load('assets/certs/another.crt');
  // context.setTrustedCertificatesBytes(cert3.buffer.asUint8List());

  // dio = Dio(BaseOptions(
  // headers: _headers(), // Set your headers
  // persistentConnection: true,
// ));

  // Apply the security context
  // dio.httpClientAdapter = IOHttpClientAdapter(
  //   createHttpClient: () {
  //     final httpClient = HttpClient(context: context);

  //     // Proxy certificates require accepting "bad" certs
  //     httpClient.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;

  //     return httpClient;
  //   },
  // );

  // return dio;
// }
