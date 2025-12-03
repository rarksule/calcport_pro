// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class TokensPage extends StatefulWidget {
  final bool invalidOnly;
  const TokensPage({super.key, this.invalidOnly = false});

  @override
  State<TokensPage> createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {
  bool invalidOnly = false;
  @override
  void initState() {
    super.initState();
    invalidOnly = widget.invalidOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokens'),
        centerTitle: true,
        actions: [
          // if (!invalidOnly)
          //   IconButton(
          //       onPressed: () {
          //         TokensPage(
          //           invalidOnly: true,
          //         ).launch(context);
          //       },
          //       icon: const Icon(Icons.unarchive)),
          // if (!invalidOnly)
            IconButton(
                onPressed: () {
                  stateTokens.data.removeWhere((tk) => !tk.isActive);
                  state.tokenChanged();
                  setState(() {});
                },
                icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: ListView.builder(
          itemCount:
              // invalidOnly ? invalidTokens.data.length :
               stateTokens.data.length,
          itemBuilder: (context, index) {
            final token = 
            // invalidOnly ? invalidTokens.data.elementAt(index) :
                 stateTokens.data.elementAt(index);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: context.width() * 0.6,
                      child: Marquee(
                          child: Text(
                        'Token ${token.value}',
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      )),
                    ),
                    Text(
                      token.isActive ? 'Valid' : 'Invalid',
                      style: boldTextStyle(
                          color: token.isActive ? Colors.green : Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        state.removeToken(token);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Divider()
              ],
            );
          }),
      // floatingActionButton: invalidOnly
      //     ? FloatingActionButton(
      //         onPressed: _save,
      //         child: Icon(Icons.file_download_done),
      //       )
      //     : null,
    );
  }

  // _save() async {
  //   final tokenString = [];
  //   final now = DateTime.now();
  //   for (var tkn in invalidTokens.data) {
  //     tokenString
  //         .add('Token ${tkn.id} is used at ${tkn.usedAt.toString()}\n \n');
  //   }
  //   try {
  //     Uint8List bytes = utf8.encode(tokenString.toString());

  //     // Pick a file
  //     final result = await FilePicker.platform.saveFile(
  //         type: FileType.custom,
  //         fileName:
  //             '${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second} tokens.log',
  //         bytes: bytes);

  //     toast('file saved at $result');
  //   } catch (e) {
  //     toast(e.toString());
  //   }
  // }
}
