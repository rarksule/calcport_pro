import 'package:mobx/mobx.dart';

class RequestCountModel {
  ObservableList<int> appt;
  ObservableList<int> req;
  ObservableList<int> pay;
  ObservableList<int> img;
  RequestCountModel({
    required this.appt,
    required this.req,
    required this.pay,
    required this.img,
  });

  bool get isAllEmpty =>
      appt.isEmpty && req.isEmpty && pay.isEmpty && img.isEmpty;
}

enum RequestType { appointment, request, upload, payment, myapi }
