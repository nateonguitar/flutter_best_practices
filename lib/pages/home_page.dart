import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeData _theme;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      appBar: _appBar(),
      body: _bodyWidget(),
      floatingActionButton: _incrementCounterButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Home Page'),
    );
  }

  Widget _bodyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text(
            '$_counter',
            style: _theme.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _incrementCounterButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }
}
