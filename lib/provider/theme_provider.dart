import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the current ThemeMode (defaulting to system settings)
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
