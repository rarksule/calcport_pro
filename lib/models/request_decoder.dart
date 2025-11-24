import 'user_model.dart';

class RequestDecoder {
  String requestId;
  String personId;
  String applicationNumber;
  String registeredAt;
  String office;
  String appointmanteDate;
  String firstName;
  String middleName;
  String lastName;
  String geezFirstName;
  String geezMiddleName;
  String geezLastName;
  String dateOfBirth;
  String gender;
  String phoneNumber;
  String birthPlace;
  String email;
  String region;
  String city;
  bool isUnder18;

  RequestDecoder({
    required this.requestId,
    required this.personId,
    required this.applicationNumber,
    required this.registeredAt,
    required this.office,
    required this.appointmanteDate,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.geezFirstName,
    required this.geezMiddleName,
    required this.geezLastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.birthPlace,
    required this.email,
    required this.region,
    required this.city,
    required this.isUnder18,
  });

  static RequestDecoder fromJson(Map<String, dynamic> json) {
    var serviceResponseList = json['serviceResponseList'][0];
    return RequestDecoder(
      requestId: serviceResponseList['requestId'],
      personId: serviceResponseList["personResponses"]['requestPersonId'],
      applicationNumber: serviceResponseList['personResponses']
          ['applicationNumber'],
      registeredAt: DateTime.parse(serviceResponseList["requestDate"])
          .add(Duration(hours: 3))
          .toString(),
      office: serviceResponseList['office'],
      appointmanteDate: serviceResponseList['appointmentDateDisplay'],
      firstName: serviceResponseList["personResponses"]['firstName'],
      middleName: serviceResponseList["personResponses"]['middleName'],
      lastName: serviceResponseList["personResponses"]['lastName'],
      geezFirstName: serviceResponseList["personResponses"]['geezFirstName'],
      geezMiddleName: serviceResponseList["personResponses"]['geezMiddleName'],
      geezLastName: serviceResponseList["personResponses"]['geezLastName'],
      dateOfBirth: serviceResponseList['birthDateDisplay'],
      gender: serviceResponseList["personResponses"]['gender'] == 0
          ? "Female"
          : "Male",
      phoneNumber: serviceResponseList["personResponses"]['phoneNumber'],
      birthPlace: serviceResponseList["personResponses"]['birthPlace'],
      email: serviceResponseList["personResponses"]['email'],
      region: serviceResponseList["personResponses"]['address']['region'],
      city: serviceResponseList["personResponses"]['address']['city'],
      isUnder18: serviceResponseList["personResponses"]['isUnder18'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["requestId"] = requestId;
    data["personId"] = personId;
    data["applicationNumber"] = applicationNumber;
    data["registeredAt"] = registeredAt;
    data["office"] = office;
    data["appointmanteDate"] = appointmanteDate;
    data["firstName"] = firstName;
    data["middleName"] = middleName;
    data["lastName"] = lastName;
    data["geezFirstName"] = geezFirstName;
    data["geezMiddleName"] = geezMiddleName;
    data["geezLastName"] = geezLastName;
    data["dateOfBirth"] = dateOfBirth;
    data["gender"] = gender;
    data["phoneNumber"] = phoneNumber;
    data["birthPlace"] = birthPlace;
    data["email"] = email;
    data["region"] = region;
    data["city"] = city;
    data["isUnder18"] = isUnder18;

    return data;
  }
}

class DataCollectionModel {
  String name;
  AppointmentStatusModel status;
  DataCollectionModel({required this.name, required this.status});
}

class AtachmentDecoder {
  String birthImagePath;
  String idImagePath;

  AtachmentDecoder({
    required this.birthImagePath,
    required this.idImagePath,
  });

  static AtachmentDecoder fromJson(Map<String, dynamic> json) {
    var attachmentList = json["attachments"];

    return AtachmentDecoder(
      birthImagePath: attachmentList[0]['attachmentPath'],
      idImagePath: attachmentList[1]['attachmentPath'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["birthImagePath"] = birthImagePath;
    data["idImagePath"] = idImagePath;

    return data;
  }
}
