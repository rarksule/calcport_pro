import 'dart:io';

import '../main.dart';
import 'constants.dart';

Map requestMap = {
  "requestId": 0,
  "requestMode": 1,
  "processDays": 2,
  "requestTypeId": 2,
  "deliveryDate": "",
  "status": 0,
  "confirmationNumber": "",
  "applicants": [
    {
      "personId": 0,
      "nationalityId": 1,
      "height": "",
      "eyeColor": "",
      "hairColor": "Black",
      "occupationId": null,
      "birthCertificateId": "",
      "photoPath": "",
      "employeeID": "",
      "applicationNumber": "",
      "organizationID": "",
      "isAdoption": false,
      "passportNumber": "",
      "isDatacorrected": false,
      "passportPageId": 1,
      "correctionType": 0,
      "maritalStatus": 0,
      "requestReason": 0,
      "address": {
        "personId": 0,
        "addressId": 0,
        "state": "",
        "zone": "",
        "wereda": "",
        "kebele": "",
        "street": "",
        "houseNo": "",
        "poBox": "",
        "requestPlace": ""
      },
      "familyRequests": []
    }
  ]
};

Map appointmentMap = {
  "id": 0,
  "isUrgent": true,
  "RequestTypeId": 2,
  "ProcessDays": 2,
};

Map paymentMap = {
  "Email": "",
  "Amount": 20000,
  "Currency": "ETB",
  "City": "Addis Ababa",
  "Country": "ET",
  "Channel": "Mobile",
};

int randomNumber = random.nextInt(9);
Map<String, String> headerMap = stateUrl.noHeaders
    ? {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        "origin": "https://www.ethiopianpassportservices.gov.et",
        HttpHeaders.refererHeader:
            "https://www.ethiopianpassportservices.gov.et/",
        HttpHeaders.authorizationHeader: 'Bearer ${appUserData.accessToken}',
        HttpHeaders.userAgentHeader: userAgents[random.nextInt(9)],
      }
    : {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        "origin": "https://www.ethiopianpassportservices.gov.et",
        HttpHeaders.refererHeader:
            "https://www.ethiopianpassportservices.gov.et/",
        HttpHeaders.acceptEncodingHeader: 'gzip, deflate, br, zstd',
        HttpHeaders.acceptLanguageHeader:
            'en-GB,en;q=0.9,ar;q=0.8,en-US;q=0.7,am;q=0.6',
        HttpHeaders.accessControlAllowCredentialsHeader: 'true',
        'priority': 'u=0;i',
        "sec-ch-ua":
            '"Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
        HttpHeaders.connectionHeader: 'keep-alive',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'cross-site',
        HttpHeaders.authorizationHeader: 'Bearer ${appUserData.accessToken}',
        HttpHeaders.userAgentHeader: userAgents[random.nextInt(9)],
      };

// ["officeId"] = location.officeId,
// ["deliverySiteId"] = location.deliveryId,
// ["appointmentIds"] = [appointment.appointCode],
// ["userName"] = email,
// ["email"] = email,
// ["applicants"]["firstName"] = eName,
// ["applicants"]["middleName"] = efName,
// ["applicants"]["lastName"] = egName,
// ["applicants"]["geezFirstName"] = gName,
// ["applicants"]["geezMiddleName"] = gfName,
// ["applicants"]["geezLastName"] = ggName,
// ["applicants"]["dateOfBirth"] = dob,
// ["applicants"]["gender"] = gender,
// ["applicants"]["birthPlace"] = birthPlace,
// ["applicants"]["isUnder18"] = isUnder18,
// ["applicants"]["phoneNumber"] = phone,
// ["applicants"]["address"]["city"] = city,
// ["applicants"]["address"]["region"] = region,

// appointment
// ["OfficeId"] = officeId,

// payment
// ["FirstName"] = eName,
// ["LastName"] = egName,
// ["Phone"] = "+251${user.phone.replaceFirst('0', '')}",
// ["PaymentOptionsId"] = payment,
// ["requestId"] = requestId,
