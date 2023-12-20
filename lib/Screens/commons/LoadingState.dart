import 'package:flutter/material.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({Key? key}) : super(key: key);

  @override
  _LoadingStateState createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading .. "),
      ),
    );
  }
}
