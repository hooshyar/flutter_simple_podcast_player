import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget whichSmallLoading() {
  return Container(
    alignment: Alignment.center,
    height: 30,
    child: Platform.isIOS
        ? CupertinoActivityIndicator()
        : Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          ),
  );
}
