import 'package:flutter/material.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  final String url;

  const AppWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading:FreeIndeedBackButton(),
      ),
      body: WebViewWidget(

        controller: controller,
      ),
    );
  }
}
