import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/inventaris_controller.dart';
import 'screens/inventaris_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventaris Barang',
      initialBinding: BindingsBuilder(() {
        Get.put(InventarisController());
      }),
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE8601C),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF2D2D2D)),
          displayMedium: TextStyle(color: Color(0xFF2D2D2D)),
          displaySmall: TextStyle(color: Color(0xFF2D2D2D)),
          headlineLarge: TextStyle(color: Color(0xFF2D2D2D)),
          headlineMedium: TextStyle(color: Color(0xFF2D2D2D)),
          headlineSmall: TextStyle(color: Color(0xFF2D2D2D)),
          titleLarge: TextStyle(color: Color(0xFF2D2D2D)),
          titleMedium: TextStyle(color: Color(0xFF2D2D2D)),
          titleSmall: TextStyle(color: Color(0xFF2D2D2D)),
          bodyLarge: TextStyle(color: Color(0xFF2D2D2D)),
          bodyMedium: TextStyle(color: Color(0xFF2D2D2D)),
          bodySmall: TextStyle(color: Color(0xFF757575)),
          labelLarge: TextStyle(color: Color(0xFF2D2D2D)),
          labelMedium: TextStyle(color: Color(0xFF2D2D2D)),
          labelSmall: TextStyle(color: Color(0xFF757575)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF2D2D2D),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Color(0xFF2D2D2D)),
        ),
      ),
      home: const InventarisScreen(),
    );
  }
}
