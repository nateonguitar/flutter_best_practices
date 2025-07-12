import 'package:flutter/material.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with Logging {
  @override
  void initState() {
    super.initState();
    logWidgetMounted();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Landing Page'),
      ),
    );
  }
}
