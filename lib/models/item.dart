import 'dart:typed_data';
import 'package:flutter/material.dart';

class Item {
  String id;
  String name;
  String kodeBarang;
  String category;
  int stock;
  String satuan;
  String location;
  DateTime? tanggalMasuk;
  Uint8List? imageBytes;
  IconData icon;
  Color iconBgColor;
  Color categoryColor;

  Item({
    required this.id,
    required this.name,
    required this.kodeBarang,
    required this.category,
    required this.stock,
    required this.satuan,
    required this.location,
    this.tanggalMasuk,
    this.imageBytes,
    required this.icon,
    required this.iconBgColor,
    required this.categoryColor,
  });

  Item copyWith({
    String? name,
    String? kodeBarang,
    String? category,
    int? stock,
    String? satuan,
    String? location,
    DateTime? tanggalMasuk,
    Uint8List? imageBytes,
    IconData? icon,
    Color? iconBgColor,
    Color? categoryColor,
  }) {
    return Item(
      id: id,
      name: name ?? this.name,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      satuan: satuan ?? this.satuan,
      location: location ?? this.location,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      imageBytes: imageBytes ?? this.imageBytes,
      icon: icon ?? this.icon,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }
}

// Helper untuk mendapatkan icon dan warna berdasarkan kategori
IconData getIconForCategory(String category) {
  switch (category.toUpperCase()) {
    case 'ELEKTRONIK':
      return Icons.laptop_mac;
    case 'AUDIO':
      return Icons.headphones;
    case 'FURNITUR':
      return Icons.chair;
    case 'DEKORASI':
      return Icons.watch_later_outlined;
    case 'LOGISTIK':
      return Icons.local_shipping;
    default:
      return Icons.inventory_2;
  }
}

Color getBgColorForCategory(String category) {
  switch (category.toUpperCase()) {
    case 'ELEKTRONIK':
      return const Color(0xFFE0E0E0);
    case 'AUDIO':
      return const Color(0xFFF5F5F5);
    case 'FURNITUR':
      return const Color(0xFFFFF3E0);
    case 'DEKORASI':
      return const Color(0xFFE8EAF6);
    case 'LOGISTIK':
      return const Color(0xFFE0F2F1);
    default:
      return const Color(0xFFE0E0E0);
  }
}

Color getCategoryBadgeColor(String category) {
  switch (category.toUpperCase()) {
    case 'AUDIO':
      return const Color(0xFF90A4AE);
    default:
      return const Color(0xFFE8601C);
  }
}
