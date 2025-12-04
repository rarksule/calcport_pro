import 'dart:convert';
import 'dart:io';
import 'constant_dart_mapes.dart';
import 'package:dio/dio.dart';

import '../models/request_decoder.dart';
import '../models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../widgets/time.dart';
import 'common.dart';
import 'constants.dart';

Future<bool> autenticateApi(String value) async {
  Map payload = {"pin": value};

  http.Response response = await makeRequestToMyApi(
    stateUrl.authenticateUrl,
    payload,
  );

  if (response.statusCode.isSuccessful()) {
    return true;
  } else {
    return false;
  }
}

http.Client client = http.Client();

Future<http.Response> makeRequestToMyApi(
  String endpoint,
  Map body,
) async {
  final called = TimeWidgetState.time;
  try {
    http.Response response;
    response =
        await http.post(Uri.parse(endpoint), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    }).timeout(const Duration(seconds: 125), onTimeout: () => throw 'Timeout');

    logstring.add(
        '\n$called ==> ${TimeWidgetState.time} \n\n Request: \n $body\n  Response :\n $endpoint \n ${response.statusCode}\n ${response.body}\n');
    // log(logstring);
    return response;
  } catch (e) {
    log(e.toString());
    logstring.add(
        '\n$called ==> ${TimeWidgetState.time} \n\n Request: \n $body \n  ErrorResponse :\n $endpoint \n $e \n');
    // log(logstring);
    throw 'Some thing went wrong';
  }
}

Dio dio = Dio(BaseOptions(
  // headers: _headers(), // Set your headers
  persistentConnection: true,
));

// ...existing code...
Future<ResponseModel> makeRequestToPassportApi(
    {required String endpoint,
    required FormData payload,
    required String hostHeader}) async {
  final called = time;

  if (!stateUrl.withNoHost) {
    headerMap[HttpHeaders.hostHeader] = hostHeader;
  }

  try {
    Response response = await dio.post(
      endpoint,
      data: payload,
      options: Options(headers: headerMap),
      onSendProgress: (int sent, int total) {
        if (total > 0) {
          upload = ((sent / total) * 100).toInt();
        } else {
          // total unknown, keep upload at 0 (or set to -1 to indicate unknown)
          upload = 0;
        }
      },
    ).timeout(const Duration(seconds: 60), onTimeout: () => throw 'Timeout');

    // Normalize response body to a JSON string so callers can `jsonDecode` it.
    String bodyString;
    if (response.data is String) {
      bodyString = response.data as String;
    } else {
      try {
        bodyString = jsonEncode(response.data);
      } catch (_) {
        bodyString = response.data.toString();
      }
    }

    logstring.add(
        '\n$called ==> $time \n\n Request: \n FormData $endpoint \n ${response.statusCode}\n $bodyString\n Upload: $upload%\n');
    // log(logstring);
    return ResponseModel(
        body: bodyString, statusCode: response.statusCode ?? 0);
  } catch (e) {
    log(e.toString());
    if (e is DioException) {
      logstring.add(
          '\n$called ==> $time \n\n Request: \n FormData \n  ErrorResponse :\n $endpoint \n ${e.response?.data.toString()} \n');
      // log(logstring);
      throw '${e.response?.data.toString()}';
    }
    logstring.add(
        '\n$called ==> $time \n\n Request: \n FormData \n  ErrorResponse :\n $endpoint \n $e \n');
    throw 'Some thing went wrong';
  }
}

Future<ResponseModel> makeRequestToPassportEndpoint(
    {required String endpoint,
    required Map payload,
    required String hostHeader}) async {
  final called = time;

  if (!stateUrl.withNoHost) {
    headerMap[HttpHeaders.hostHeader] = hostHeader;
  }
  try {
    http.Response response = await client
        .post(Uri.parse(endpoint),
            body: jsonEncode(payload), headers: headerMap)
        .timeout(const Duration(seconds: 125),
            onTimeout: () => throw 'Timeout');
    logstring.add(
        '\n$called ==> $time \n\n Request: \n ${payload.toString().replaceFirst(payload['sessionId'] ?? "0xx", payload['sessionId'].toString().validate(value: "no session").short)}\n  Response :\n $endpoint \n ${response.statusCode}\n ${response.body}\n');
    // log(logstring);
    return ResponseModel(body: response.body, statusCode: response.statusCode);
  } catch (e) {
    log(e.toString());
    logstring.add(
        '\n$called ==> $time \n\n ErrorRequest: \n ${payload.toString().replaceFirst(payload['sessionId'] ?? "0xx", payload['sessionId'].toString().validate(value: "no session").short)}\n  ErrorResponse :\n $endpoint \n $e \n');
    // log(logstring);
    throw 'Some thing went wrong';
  }
}

Future<bool> signInApi() async {
  final token = stateTokens.data.where((tkn) => tkn.isActive).firstOrNull;
  if (token == null) throw "no validToken";
  Map<String, dynamic> payload = {
    "username": appUserData.email,
    "password": appUserData.password,
    "sessionId": token.value
  };
  token.used = true;
  ResponseModel response = await makeRequestToPassportEndpoint(
    endpoint: stateUrl.signInurl,
    payload: payload,
    hostHeader: stateUrl.globalHost,
  );
  state.removeToken(token);
  if (response.statusCode.isSuccessful()) {
    return true;
  } else {
    throw response.body;
  }
}

//*************************************************************************************************8/

Future<bool> validateOTPApi(String otp) async {
  Map<String, dynamic> payload = {
    'phoneNumber': appUserData.phone.replaceFirst('0', "+251"),
    "email": appUserData.email,
    "otp": otp,
  };
  ResponseModel response = await makeRequestToPassportEndpoint(
      endpoint: stateUrl.otpverifyUrl,
      payload: payload,
      hostHeader: stateUrl.globalHost);

  if (response.statusCode.isSuccessful()) {
    String refreshtoken = jsonDecode(response.body)['refreshToken'];
    String accessToken = jsonDecode(response.body)['accessToken'];
    DateTime refexpiretime = await getExpireTime(refreshtoken);
    DateTime accessExpireTime = await getExpireTime(accessToken);

    appUserData.accessExpireTime = refexpiretime;
    appUserData.accessToken = refreshtoken;

    setValue(APPUSERDATA, appUserData.toJson());
    await setAccessTokenApi({
      'accessToken': accessToken,
      "expireTime": accessExpireTime.toIso8601String(),
      'authEmail': appUserData.email,
    });
    await setAccessTokenApi();
    return true;
  }
  throw response.body;
}

Future<void> setAccessTokenApi([Map? payload]) async {
  payload ??= {
    'accessToken': appUserData.accessToken,
    "expireTime": appUserData.accessExpireTime.toIso8601String(),
    'authEmail': appUserData.email,
  };
  await makeRequestToMyApi(stateUrl.setAccessTokenUrl, payload);
  return;
}

Future<String> submitAppointmentApi(int officeId) async {
  appointmentMap["OfficeId"] = officeId;
  final token = stateTokens.data.where((tkn) => tkn.isActive).firstOrNull;
  if (token == null) throw "no validToken";
  token.used = true;
  appointmentMap["sessionId"] = token.value;
  ResponseModel response = await makeRequestToPassportEndpoint(
    endpoint: stateUrl.appointmentUrl,
    payload: appointmentMap,
    hostHeader: stateUrl.appoinmentHost,
  );
  if (response.statusCode != 502) {
    state.removeToken(token);
  } else {
    token.used = false;
  }
  if (response.statusCode.isSuccessful()) {
    var json = jsonDecode(response.body);
    var appointmentResponses = json['appointmentResponses'][0];
    return appointmentResponses['id'];
  } else if (response.statusCode == 400) {
    throw response.body;
  } else {
    throw jsonDecode(response.body)['message'];
  }
}

Future<String> storeCode(RequestDecoder value) async {
  Map<String, dynamic> data = value.toJson();
  data["creator"] = appUserData.iam;
  data["authEmail"] = appUserData.email;
  data["userchecked"] = false;

  http.Response response =
      await makeRequestToMyApi(stateUrl.storeCodeUrl, data);

  if (response.statusCode.isSuccessful()) {
    var r = jsonDecode(response.body)['insertedId'].toString();
    return r;
  }
  return '';
}

Future<bool> updateUserData(UserModel user,
    [String processId = "", String type = ""]) async {
  Map<String, dynamic> payload = {
    "id": user.appointment.remoteId,
    "applicationNumber": user.appointment.applicationNumber,
    "birthImage": user.appointment.birthImagePath,
    "idImage": user.appointment.idImagePath,
    "paymentStatus":
        user.appointment.paymentCode != null ? "Payment Pending" : null,
    "orderId": user.appointment.paymentCode,
    "processCode": processId,
    "type": type,
  };

  return await makeRequestToMyApi(stateUrl.updateCodeUrl, payload)
      .then((response) {
    if (response.statusCode.isSuccessful()) {
      return true;
    } else {
      return false;
    }
  }).catchError((er) {
    processError(er);
    return false;
  });
}
