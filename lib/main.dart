import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todoey/providers/color_provider.dart';
import 'package:todoey/screens/task_screen.dart';

void main() {
  runApp(ProviderScope(
    child: App(),
  ));
}

Widget errorScreen = MaterialApp(
  home: Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(height: 14.0),
          Text(
            'Failed to load app settings',
            style: TextStyle(
              color: Colors.red,
              decoration: TextDecoration.none,
              fontSize: 15.0,
            ),
          )
        ],
      ),
    ),
  ),
);

Widget mainScreen(Color primaryColor) => MaterialApp(
      theme: ThemeData(primaryColor: primaryColor),
      home: TaskScreen(),
    );

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    ColorNotifier colorNotifier = useProvider(colorProvider.notifier);
    Color? primaryColor = useProvider(colorProvider);
    return FutureBuilder(
      future: colorNotifier.loadPrimaryColor(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = mainScreen(primaryColor!);
        } else if (snapshot.hasError) {
          child = errorScreen;
        } else {
          child = Center(
            child: CircularProgressIndicator(),
          );
        }
        return child;
      },
    );
  }
}
