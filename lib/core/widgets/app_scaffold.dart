import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body, this.appBar, this.bottom});

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: SafeArea(child: body),
        bottomNavigationBar: bottom == null
            ? null
            : SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: bottom!,
                ),
              ),
      );
}
