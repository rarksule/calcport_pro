import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../models/request_decoder.dart';
import '../models/user_model.dart';
import 'common.dart';
import 'constant_dart_mapes.dart';
import 'constants.dart';
import 'network.dart';

submitRequestApi(UserModel user) async {
  if (invalidAppointmentId.contains(user.appointment.appointCode)) {
    throw "Invalid Appointment Id ${user.appointment.appointCode!.short}";
  }
  requestMap["officeId"] = user.location.officeId;
  requestMap["deliverySiteId"] = user.location.deliveryId;
  requestMap["appointmentIds"] = [user.appointment.appointCode];
  requestMap["userName"] = user.email;
  requestMap["email"] = user.email;
  requestMap["applicants"][0]["firstName"] = user.eName;
  requestMap["applicants"][0]["middleName"] = user.efName;
  requestMap["applicants"][0]["lastName"] = user.egName;
  requestMap["applicants"][0]["geezFirstName"] = user.gName;
  requestMap["applicants"][0]["geezMiddleName"] = user.gfName;
  requestMap["applicants"][0]["geezLastName"] = user.ggName;
  requestMap["applicants"][0]["dateOfBirth"] = user.dob;
  requestMap["applicants"][0]["gender"] = user.gender;
  requestMap["applicants"][0]["birthPlace"] = user.birthPlace;
  requestMap["applicants"][0]["isUnder18"] = user.isUnder18;
  requestMap["applicants"][0]["phoneNumber"] = user.phone;
  requestMap["applicants"][0]["address"]["city"] = user.city;
  requestMap["applicants"][0]["address"]["region"] = user.region;
  final token = stateTokens.data.where((tkn) => tkn.isActive).lastOrNull;
  if (token == null) throw "no validToken";
  requestMap["sessionId"] = token.value;

  try {
    token.used = true;
    await makeRequestToPassportEndpoint(
      endpoint: stateUrl.requestUrl,
      payload: requestMap,
      hostHeader: stateUrl.requestHost,
    ).then((onValue) async {
      if (onValue.statusCode.isSuccessful()) {
        final data = RequestDecoder.fromJson(jsonDecode(onValue.body));
        String name = "${user.eName} ${user.efName}";
        String? remoteId;
        await storeCode(data).then((onValue) {
          remoteId = onValue.isNotEmpty ? onValue : null;
        });
        if (user.appointment.applicationNumber == null) {
          user.appointment.applicationNumber = data.applicationNumber;
          user.appointment.requestId = data.requestId;
          user.appointment.personId = data.personId;
          user.appointment.remoteId = remoteId;
          var modl = AppointmentStatusModel(
            applicationNumber: user.appointment.applicationNumber,
            personId: user.appointment.personId,
            requestId: user.appointment.requestId,
          );
          dataCollection.add(DataCollectionModel(name: name, status: modl));
          liveStream.emit(setStateM);
          myStream.emit(setStateU);
        }
        invalidAppointmentId.add(user.appointment.appointCode!);
        state.removeToken(token);
      } else if (onValue.statusCode == 502) {
        processError(jsonDecode(onValue.body));
        token.used = false;
      } else {
        if (jsonDecode(onValue.body)['message']
            .toString()
            .contains('Appointment Already Selected')) {
          invalidAppointmentId.add(user.appointment.appointCode!);
        }
        processError(jsonDecode(onValue.body)['message']);
        state.removeToken(token);
      }
    });
  } catch (onError) {
    processError(onError);
    state.removeToken(token);
  }
}
