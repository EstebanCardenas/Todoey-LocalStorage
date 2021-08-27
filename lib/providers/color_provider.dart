import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoey/providers/preferences_provider.dart';
import 'package:todoey/extensions/map_extensions.dart';

/// Providers

final availableColorsProvider = Provider<Map<Color, String>>((ref) {
  return <Color, String>{
    Colors.lightBlueAccent: 'Light Blue',
    Colors.redAccent: 'Red',
    Colors.purple: 'Purple',
    Colors.teal: 'Teal',
    Colors.indigo: 'Indigo',
  };
});

final colorProvider = StateNotifierProvider<ColorNotifier, Color?>((ref) {
  Map<Color, String> availableColors = ref.watch(availableColorsProvider);
  SharedPreferencesClient prefsClient = ref.watch(preferencesProvider);

  return ColorNotifier(
    prefsClient: prefsClient,
    availableColors: availableColors,
  );
});

/// Notifiers

class ColorNotifier extends StateNotifier<Color?> {
  final SharedPreferencesClient prefsClient;
  final Map<Color, String> availableColors;

  ColorNotifier({
    required this.prefsClient,
    required this.availableColors,
  }) : super(null);

  Future<bool> loadPrimaryColor() async {
    try {
      String primaryColor = await prefsClient.getPrimaryColor();
      state = availableColors.getInverted()[primaryColor];
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> setPrimaryColor(Color newColor) async {
    await prefsClient.setPrimaryColor(availableColors[newColor]!);
    state = newColor;
  }
}
