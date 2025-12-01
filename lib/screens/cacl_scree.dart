// ignore_for_file: use_build_context_synchronously

import '../widgets/calc_buttons_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/constants.dart';
import '../utils/network.dart';
import 'main_screen.dart';
import 'url_manager_screen.dart';
import 'user_info.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

bool get remoteAllowed => _CalculatorState._remoteAllowed;

class _CalculatorState extends State<Calculator> {
  final _questionController = TextEditingController();
  String result = '';
  bool showingresult = false;
  static bool _remoteAllowed = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 16),
            child: AppTextField(
              textFieldType: TextFieldType.NUMBER,
              controller: _questionController,
              textAlign: TextAlign.end,
              autoFocus: true,
              showCursor: true,
              cursorHeight: 46,
              keyboardType: TextInputType.none,
              cursorColor: Colors.cyan,
              textStyle: TextStyle(
                color: showingresult
                    ? const Color.fromARGB(255, 18, 155, 25)
                    : Colors.white,
                fontSize: 40,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            result,
            style: TextStyle(fontSize: 32, color: Colors.grey),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 0, 36, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 32,
                  children: [
                    Image.asset("history.png",
            color: Colors.white,
                    fit: BoxFit.fill),
                    Image.asset("convertor.png",
            color: Colors.white,
                    fit: BoxFit.fill),
                    Image.asset("scientific.png",
            color: Colors.white,)
                  ],
                ),
                8.width,
                8.width,
                Image.asset("delete.png",
            color: Colors.green,
                    fit: BoxFit.fill).onTap(() => clearTapped()),
              ],
            ),
          ),
          Divider(
            thickness: 0.5,
          ),
          SizedBox(
            height: context.height() * 0.52,
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return CalcButtonsWidget(
                  index: index,
                  buttonTapped: buttunTapped,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buttunTapped(int index) {
    HapticFeedback.vibrate();
    String label = buttons[index];
    if (label == 'C') {
      authenticate();
      return;
    }
    if (label == "=") {
      evaluate(true);
      return;
    }
    if (index == 16) {
      if (_questionController.text.startsWith("-")) {
        _questionController.text =
            _questionController.text.replaceFirst('-', '');
      } else {
        _questionController.text = '-${_questionController.text}';
      }
      setState(() {});
      return;
    }
    if (index == 1) {
      if (_questionController.text.characters.where((c) => c == "(").length >
          _questionController.text.characters.where((c) => c == ")").length) {
        label = ')';
      } else {
        label = "(";
      }
    }

    final fullText = _questionController.text;
    final sel = _questionController.selection;

    // If selection is invalid, treat as caret at end
    int start = (sel.isValid && sel.start >= 0) ? sel.start : fullText.length;
    int end = (sel.isValid && sel.end >= 0) ? sel.end : fullText.length;

    // Clamp values
    start = start.clamp(0, fullText.length);
    end = end.clamp(0, fullText.length);

    final newText = fullText.replaceRange(start, end, label);
    final newOffset = start + label.length;

    _questionController.value = _questionController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    evaluate();
  }

  clearTapped() {
    HapticFeedback.vibrate();
    final fullText = _questionController.text;
    final sel = _questionController.selection;

    // If there is an active selection, delete that range
    if (sel.isValid && sel.start >= 0 && sel.end > sel.start) {
      final start = sel.start.clamp(0, fullText.length);
      final end = sel.end.clamp(0, fullText.length);
      final newText = fullText.replaceRange(start, end, '');
      _questionController.value = _questionController.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: start),
      );
      evaluate();
      return;
    }

    // Otherwise act like backspace: remove character before caret
    int pos = (sel.isValid && sel.start >= 0) ? sel.start : fullText.length;
    pos = pos.clamp(0, fullText.length);
    if (pos == 0) return; // nothing to delete

    final newText = fullText.replaceRange(pos - 1, pos, '');
    final newOffset = pos - 1;
    _questionController.value = _questionController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    evaluate();
  }

  void evaluate([isFinal = false]) {
    final String finalQuestion = _questionController.text
        .replaceAll('x', '*')
        .replaceAll('÷', '/')
        .replaceAll('%', '/100');
    if (finalQuestion.isEmpty) {
      setState(() {
        result = '';
      });
      return;
    }
    if (finalQuestion.characters.last.contains(RegExp(r'\*|/|/100|\+|-'))) {
      return;
    }
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    final inteval = eval.toInt();
    if (isFinal) {
      showingresult = true;
      if (inteval == eval) {
        _questionController.text = inteval.toString();
      } else {
        _questionController.text = eval.toString();
      }
      result = '';
    } else {
      showingresult = false;
      if (inteval == eval) {
        result = inteval.toString();
      } else {
        result = eval.toString();
      }
      // result = eval.toString();
    }
    setState(() {});
  }

  authenticate() async {
    if (_questionController.text == "1234567890") {
      UrlManagerScreen().launch(context);
    } else if (_remoteAllowed) {
      final now = DateTime.now();
      if (_questionController.text ==
          '${now.weekday}${now.hour}${now.minute}') {
        appUserData.authExpireTime = now.add(Duration(minutes: 40));
        if (appUserData.iam.isEmpty) {
          UserInfo(init: true).launch(context, isNewTask: true);
        } else {
          setValue(APPUSERDATA, appUserData.toJson());
          const MainScreen().launch(context, isNewTask: true);
        }
      }
    } else {
      String pincode = _questionController.text.isEmpty
          ? appUserData.remoteCode
          : _questionController.text;
      await autenticateApi(pincode).then((onValue) {
        if (onValue) {
          appUserData.remoteCode = pincode;
          _remoteAllowed = true;
          if (appUserData.authExpireTime.isAfter(DateTime.now())) {
            if (appUserData.iam.isEmpty) {
              UserInfo().launch(context, isNewTask: true);
            } else {
              setValue(APPUSERDATA, appUserData.toJson());
              const MainScreen().launch(context, isNewTask: true);
            }
          }
        }
      }).catchError((onError) {
        log(onError.toString());
      });
    }
    _questionController.clear();
    result = '';
    setState(() {});
  }

  void init() async {
    if (appUserData.remoteCode.isNotEmpty) {
      await autenticateApi(appUserData.remoteCode).then((onValue) {
        setState(() {
          _remoteAllowed = true;
        });
        if (onValue && appUserData.authExpireTime.isAfter(DateTime.now())) {
          if (appUserData.iam.isEmpty) {
            UserInfo().launch(context, isNewTask: true);
          } else {
            setValue(APPUSERDATA, appUserData.toJson());
            const MainScreen().launch(context, isNewTask: true);
          }
        }
      });
    }
  }
}
