import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget{
  final String error;
  ErrorText({super.key,
  required this.error,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(error),
    );
  }
}