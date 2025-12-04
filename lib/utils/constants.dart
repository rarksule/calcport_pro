// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../models/user_model.dart';

const primaryColor = Colors.brown;

const anonymous =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJKV1RfQ1VSUkVOVF9VU0VSIjoiQW5vbnltb3VzQGV0aGlvcGlhbmFpcmxpbmVzLmNvbSIsIm5iZiI6MTczMjA4MjQzNSwiZXhwIjoxNzQyNDUwNDM1LCJpYXQiOjE3MzIwODI0MzV9.9trNDDeFAMR6ByGB5Hhv8k5Q-16RGpPuGKmCpw95niY';

int upload = 0;
const List<String> buttons = [
  'C',
  '( )',
  '%',
  '÷',
  '7',
  '8',
  '9',
  'x',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '+/-',
  '0',
  '.',
  '=',
];
List<int> operators = [0, 1, 2, 3, 7, 11, 15, 19];

const userAgents = [
  "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36",
  "Mozilla/5.0 (Linux; Android 15; SM-S931B Build/AP3A.240905.015.A2; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/127.0.6533.103 Mobile Safari/537.36",
  "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36",
  "Mozilla/5.0 (iPhone17,5; CPU iPhone OS 18_3_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 FireKeepers/1.7.0",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/13.2b11866 Mobile/16A366 Safari/605.1.15",
  "Mozilla/5.0 (Linux; Android 12; SM-X906C Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/80.0.3987.119 Mobile Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Edg/134.0.0.0",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3.1 Safari/605.1.15",
  "Mozilla/5.0 (Apple-iPhone7C2/1202.466; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"
];

const setStateM = "setState";
const setStateU = "setStateU";

String localurl = "10.177.62.70";
DateTime now = DateTime.now();

List<String> invalidAppointmentId = [];
Map<int, Set<String>> retrivedappointments = {};

final List<String> logstring = [];
const line =
    '------------------------------------------***--------------------------------------------\n';

const APPUSERDATA = "APPUSERDATA";
const USERS = "USERS";
const Oromia = "Oromia";
const cities = [jimma, addis, dessie, hossana, adama, hawassa];

const mypurple = Color(0xFFff69ff);

const jimma = LocationModel(
  officeId: 33,
  label: 'JIMMA',
  deliveryId: 13,
);

const adama = LocationModel(
  officeId: 32,
  label: 'ADAMA',
  deliveryId: 12,
);

const dessie = LocationModel(
  officeId: 27,
  label: 'DESSIE',
  deliveryId: 6,
);

const addis = LocationModel(
  officeId: 24,
  label: 'Addis Ababa',
  deliveryId: 1,
);

const hawassa = LocationModel(
  officeId: 28,
  label: 'Hawassa',
  deliveryId: 16,
);

const hossana = LocationModel(
  officeId: 39,
  label: 'HOSSANA',
  deliveryId: 19,
);

Map<int, String> officeRegion = {
  33: Oromia,
  32: Oromia,
  27: "Amhara",
  24: "Addis Ababa",
  28: "Sidama",
  39: "South West Ethiopia",
};
