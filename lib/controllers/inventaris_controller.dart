import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/app_colors.dart';

class InventarisController extends GetxController {
  final items = <Item>[].obs;

  void addItem(Item item) {
    items.add(item);
  }

  void updateItem(int index, Item item) {
    items[index] = item;
  }

  void deleteItem(int index) {
    final itemName = items[index].name;
    items.removeAt(index);
    Get.snackbar(
      'Berhasil',
      '"$itemName" telah dihapus dari inventaris',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> confirmDelete(int index) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Barang?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${items[index].name}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.delete),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (result == true) {
      deleteItem(index);
    }
  }
}
