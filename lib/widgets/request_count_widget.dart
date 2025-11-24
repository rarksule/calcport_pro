import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../main.dart';

class RequestCount extends StatelessWidget {
  const RequestCount({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("| A ${state.requestsCount.appt.length} | ",
              style: TextStyle(fontSize: 14, color: mypurple)),
          Text("R ${state.requestsCount.req.length} | ",
              style: TextStyle(fontSize: 14, color: mypurple)),
          Text("U ${state.requestsCount.img.length} | ",
              style: TextStyle(fontSize: 14, color: mypurple)),
          Text("P ${state.requestsCount.pay.length} |",
              style: TextStyle(fontSize: 14, color: mypurple)),
        ],
      );
    });
  }
}
