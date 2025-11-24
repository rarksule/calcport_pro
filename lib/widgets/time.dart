import 'dart:async';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TimeWidget extends StatefulWidget {
  const TimeWidget({super.key});

  @override
  State<TimeWidget> createState() => TimeWidgetState();
}

DateTime get time => TimeWidgetState.time;

class TimeWidgetState extends State<TimeWidget> {
  static DateTime time = DateTime.now();

  @override
  setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(milliseconds: 500), (t) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${time.hour < 10 ? '0' : ''}${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}:${time.second < 10 ? '0' : ''}${time.second} ${upload != 0 && upload != 100 ? upload : ""}",
    );
  }
}
