import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/cacl_scree.dart';
import '../utils/constants.dart';

class CalcButtonsWidget extends StatefulWidget {
  final int index;
  final Function(int) buttonTapped;
  const CalcButtonsWidget(
      {super.key, required this.index, required this.buttonTapped});

  @override
  State<CalcButtonsWidget> createState() => _CalcButtonsWidgetState();
}

class _CalcButtonsWidgetState extends State<CalcButtonsWidget> {
  late int index;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      // height: context.width() * 0.9,
      // width: context.width() * 0.9,
      child: Material(
        color: _buttonColor(index),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => widget.buttonTapped(index), //_buttonTapped(index),
          child: Center(
            child: Text(
              buttons[index],
              style: TextStyle(color: _buttonTextColor(index), fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }

  // _buttonTapped(int index) {
  //
  //   // @override
  //   // void dispose() {
  //   //   _controller.dispose();
  //   //   // _focusNode.dispose();
  //   //   super.dispose();
  //   // }

  //   // void _onKeyPressed(String key) {
  //     if (index == 0) {
  //       _controller.clear();
  //       return;
  //     }

  //     // if (index == 'DEL') {
  //     //   final text = _controller.text;
  //     //   if (text.isNotEmpty) {
  //     //     final newText = text.substring(0, text.length - 1);
  //     //     _controller.value = _controller.value.copyWith(
  //     //       text: newText,
  //     //       selection: TextSelection.collapsed(offset: newText.length),
  //     //     );
  //     //   }
  //     //   return;
  //     // }

  //     // default: append the key

  //   }
  // }

  _buttonColor(int index) {
    if (index == 19) {
      return const Color.fromARGB(255, 9, 153, 14);
    }
    return Colors.grey[900];
  }

  _buttonTextColor(int index) {
    if (index == 0) {
      return Colors.red;
    }
    if (index == 19) {
      return white;
    }
    if (operators.contains(index) || (index == 18 && remoteAllowed)) {
      return const Color.fromARGB(255, 10, 241, 18);
    }

    return white;
  }
}
