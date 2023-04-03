import 'package:flutter/material.dart';

import 'layout/body.dart';

class LogInView extends StatelessWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:LogInBody(),
    );
  }
}
