import 'dart:convert';
import 'dart:io';
import '../utils/rest_api.dart';
import 'request_count_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/constant_dart_mapes.dart';
import '../utils/constants.dart';
import '../utils/network.dart';
import '../utils/common.dart';
import '../widgets/time.dart';
import 'request_decoder.dart';

class UsersListModel {
  List<UserModel> data;
  Set<int> offices;
  UsersListModel({required this.data, required this.offices});

  factory UsersListModel.fromJson(Map<String, dynamic> json) {
    return UsersListModel(
        data: (json['data'] as List<dynamic>? ?? [])
            .map<UserModel>(
                (e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        // ensure offices is converted to a Set<int> when decoding
        offices: (json['offices'] is List)
            ? (json['offices'] as List<dynamic>).map((e) => e as int).toSet()
            : (json['offices'] is Set)
                ? (json['offices'] as Set).map((e) => e as int).toSet()
                : <int>{});
  }

  Map<String, dynamic> toJson() {
    // convert Set to List for JSON encoding (JSON doesn't support Dart Set)
    return {
      'data': data.map((e) => e.toJson()).toList(),
      "offices": offices.toList()
    };
  }
}

class UserModel {
  String eName;
  String efName;
  String egName;
  String gName;
  String gfName;
  String ggName;
  String phone;
  String dob;
  String idPath;
  String birthPath;
  String? birthImage;
  String? idImage;
  int gender;
  String email;
  int payment;
  String birthPlace;
  bool isUnder18;
  String region;
  String city;
  String uid;
  AppointmentStatusModel appointment;
  LocationModel location;

  UserModel(
      {required this.eName,
      required this.efName,
      required this.egName,
      required this.gName,
      required this.gfName,
      required this.ggName,
      required this.phone,
      required this.dob,
      required this.idPath,
      required this.birthPath,
      required this.gender,
      this.birthImage,
      this.idImage,
      required this.uid,
      required this.location,
      required this.payment,
      required this.appointment,
      required this.region,
      required this.city,
      required this.birthPlace,
      required this.isUnder18,
      required this.email});

  static fromJson(Map<String, dynamic> json) {
    return UserModel(
      eName: json["eName"],
      efName: json["efName"],
      egName: json["egName"],
      gName: json["gName"],
      gfName: json["gfName"],
      ggName: json["ggName"],
      phone: json["phone"],
      dob: json["dob"],
      idPath: json["idPath"],
      birthPath: json["birthPath"],
      gender: json["gender"],
      payment: json['payment'],
      birthImage: json["birthImage"],
      idImage: json["idImage"],
      email: json["email"],
      uid: json["uid"],
      appointment: AppointmentStatusModel.fromJson(json["appointment"]),
      location: LocationModel.fromJson(json["location"]),
      birthPlace: json['birthPlace'],
      isUnder18: json['isUnder18'],
      region: json["region"],
      city: json["city"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["eName"] = eName;
    data["efName"] = efName;
    data["egName"] = egName;
    data["gName"] = gName;
    data["gfName"] = gfName;
    data["ggName"] = ggName;
    data["phone"] = phone;
    data["dob"] = dob;
    data["idPath"] = idPath;
    data["birthPath"] = birthPath;
    data["gender"] = gender;
    data["isUnder18"] = isUnder18;
    data["birthImage"] = birthImage;
    data["idImage"] = idImage;
    data["email"] = email;
    data["payment"] = payment;
    data["region"] = region;
    data["city"] = city;
    data["uid"] = uid;
    data['birthPlace'] = birthPlace;
    data["location"] = location.toJson();
    data['appointment'] = AppointmentStatusModel().toJson();
    return data;
  }

  Future<void> request() async {
    try {
      state.requestChanged(RequestType.request);
      await submitRequestApi(this);
    } catch (e) {
      processError(e);
    }
    state.requestChanged(RequestType.request, false);
    liveStream.emit(setStateM);
    myStream.emit(setStateU);
  }

  Future<bool> pay([reqId]) async {
    state.requestChanged(RequestType.payment);
    reqId ??= appointment.requestId;
    if (reqId == null) return false;
    bool status = await _orderRequest(reqId);
    state.requestChanged(RequestType.payment, false);
    return status;
  }

  Future<bool> upload([perId]) async {
    state.requestChanged(RequestType.upload);
    perId ??= appointment.personId;
    if (perId == null) return false;
    await _uploadAttachment(perId).then((onValue) async {
      appointment.birthImagePath = onValue.birthImagePath;
      appointment.idImagePath = onValue.idImagePath;
      if (appointment.remoteId == null) {
        await updateUserData(this, perId, 'upload').then((onValue) {
          if (!onValue) {
            updateUserData(this, perId, 'upload');
          }
          return true;
        });
      } else {
        await updateUserData(this).then((onValue) {
          if (!onValue) {
            updateUserData(this);
          }
          return true;
        });
      }
    }).catchError((error) {
      processError(error);
    });
    liveStream.emit(setStateM);
    myStream.emit(setStateU);
    state.requestChanged(RequestType.upload, false);
    return false;
  }

  Future<AtachmentDecoder> _uploadAttachment(perId) async {
    if (stateUrl.useDio) {
      FormData formData = FormData.fromMap({
        'personRequestId': perId.toString(),
        '10': await MultipartFile.fromFile(birthPath),
        '11': await MultipartFile.fromFile(idPath),
      }, ListFormat.multi, false, "------geckoformboundary");
      var res = await makeRequestToPassportApi(
          endpoint: stateUrl.uploadUrl,
          payload: formData,
          hostHeader: stateUrl.uploadHost);
      if (res.statusCode.isSuccessful()) {
        return AtachmentDecoder.fromJson(jsonDecode(res.body));
      } else {
        throw res;
      }
    } else {
      http.MultipartRequest multiPartRequest =
          http.MultipartRequest('POST', Uri.parse(stateUrl.uploadUrl));
      multiPartRequest.fields['personRequestId'] = perId.toString();

      multiPartRequest.files
          .add(await http.MultipartFile.fromPath("10", birthPath));
      multiPartRequest.files
          .add(await http.MultipartFile.fromPath("11", idPath));
      // headerMap
      if (!stateUrl.withNoHost) {
        headerMap[HttpHeaders.hostHeader] = stateUrl.uploadHost;
      }
      String body = "";
      multiPartRequest.headers.addAll(headerMap);
      await multiPartRequest.send().then((res) async {
        body = await res.stream.bytesToString();
        if (res.statusCode.isSuccessful()) {
          logstring.add(
              '$time  Request: \n Upload Attachment \n  Response :\n ${res.statusCode}\n $body\n');
        } else {
          logstring.add(
              '$time  Request: \n Upload Error Attachment \n  Response :\n ${res.statusCode}\n $body\n');
          throw body;
        }
      });
      return AtachmentDecoder.fromJson(jsonDecode(body));
    }
  }

  Future<bool> _orderRequest(dynamic requestId) async {
    paymentMap["FirstName"] = eName;
    paymentMap["LastName"] = egName;
    paymentMap["Phone"] = "+251${phone.replaceFirst('0', '')}";
    paymentMap["PaymentOptionsId"] = payment;
    paymentMap["requestId"] = requestId;

    try {
      await makeRequestToPassportEndpoint(
              endpoint: stateUrl.paymentUrl,
              payload: paymentMap,
              hostHeader: stateUrl.paymentHost)
          .then((onValue) async {
        String data = '';
        if (onValue.statusCode.isSuccessful()) {
          data = jsonDecode(onValue.body)['orderId'];
        } else if (jsonDecode(onValue.body)['message']
            .contains('Payment Request Already Exist')) {
          String message = jsonDecode(onValue.body)['message'] as String;
          String errorMessage =
              'Payment Request Already Exist Please pay using this Order Order Code =';
          if (message.contains(errorMessage)) {
            data = message.replaceFirst(errorMessage, '');
          }
        } else {
          return false;
        }
        appointment.paymentCode = data;
        if (appointment.remoteId == null) {
          appointment.isSynced =
              await updateUserData(this, requestId.toString(), "payment");
        } else {
          appointment.isSynced = await updateUserData(this);
        }

        dataCollection
            .where((e) => e.status.requestId == requestId)
            .first
            .status
            .paymentCode = data;
        liveStream.emit(setStateM);
        myStream.emit(setStateU);
        return true;
      }).catchError((onError) {
        throw onError;
      });
    } catch (onError) {
      processError(onError);
    }
    return false;
  }
}

class LocationModel {
  final int officeId;
  final int deliveryId;
  final String label;
  const LocationModel({
    required this.officeId,
    required this.label,
    required this.deliveryId,
  });

  static fromJson(Map<String, dynamic> json) {
    return LocationModel(
        officeId: json["officeId"],
        label: json['label'],
        deliveryId: json['deliveryId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["officeId"] = officeId;
    data["deliveryId"] = deliveryId;
    data["label"] = label;
    return data;
  }
}

class AppointmentStatusModel {
  String? appointCode;
  String? applicationNumber;
  String? personId;
  String? requestId;
  String? paymentCode;
  String? remoteId;
  bool isSynced;
  String? birthImagePath;
  String? idImagePath;

  AppointmentStatusModel({
    this.applicationNumber,
    this.appointCode,
    this.paymentCode,
    this.personId,
    this.requestId,
    this.remoteId,
    this.birthImagePath,
    this.idImagePath,
    this.isSynced = false,
  });

  static fromJson(Map<String, dynamic> json) {
    return AppointmentStatusModel(
      appointCode: json["appointCode"],
      applicationNumber: json['applicationNumber'],
      personId: json['personId'],
      requestId: json['requestId'],
      paymentCode: json['paymentCode'],
      remoteId: json['remoteId'],
      isSynced: json['isSynced'] ?? false,
      birthImagePath: json['birthImagePath'],
      idImagePath: json['idImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["appointCode"] = appointCode;
    data["applicationNumber"] = applicationNumber;
    data["personId"] = personId;
    data["requestId"] = requestId;
    data["paymentCode"] = paymentCode;
    data["remoteId"] = remoteId;
    data["isSynced"] = isSynced;
    data["birthImagePath"] = birthImagePath;
    data["idImagePath"] = idImagePath;
    return data;
  }
}
