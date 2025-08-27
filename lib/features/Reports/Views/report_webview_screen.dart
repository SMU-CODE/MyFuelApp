import 'package:flutter/material.dart';
import 'package:my_fuel/shared/api/ApiConstants.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart'; // <-- This import is CRUCIALستيراد جديد

class ReportWebViewScreen extends StatefulWidget {
  final String htmlContent;
  final String? reportTitle;

  const ReportWebViewScreen({
    super.key,
    required this.htmlContent,
    this.reportTitle,
  });

  @override
  State<ReportWebViewScreen> createState() => _ReportWebViewScreenState();
}

class _ReportWebViewScreenState extends State<ReportWebViewScreen> {
  late WebViewControllerPlus
  _controller; // تغيير النوع إلى WebViewPlusController

  @override
  void initState() {
    super.initState();
    // تهيئة WebViewPlusController
    _controller =
        WebViewControllerPlus()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {
                debugPrint('Web resource error: ${error.description}');
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          );

    // استخدام loadString بدلاً من loadHtmlString
    // loadString تعمل بشكل أفضل مع webview_flutter_plus للمحتوى من السلاسل
    _controller.loadHtmlString(
      widget.htmlContent,
      baseUrl: ApiConstants.baseUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reportTitle ?? 'تقرير')),
      body: WebViewWidget(
        controller: _controller,
      ), // استخدام WebViewPlus كـ Widget
    );
  }
}
