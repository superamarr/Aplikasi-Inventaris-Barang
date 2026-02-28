import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inventaris_controller.dart';
import '../models/item.dart';
import '../utils/app_colors.dart';
import '../widgets/item_card.dart';
import 'edit_barang_screen.dart';
import 'tambah_barang_screen.dart';

class InventarisScreen extends GetView<InventarisController> {
  const InventarisScreen({super.key});

  Future<void> _navigateToTambah() async {
    final result = await Get.to<Item>(() => const TambahBarangScreen());
    if (result != null) {
      controller.addItem(result);
    }
  }

  Future<void> _navigateToEdit(int index) async {
    final result = await Get.to<Item>(
      () => EditBarangScreen(item: controller.items[index]),
    );
    if (result != null) {
      controller.updateItem(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Inventaris',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Belum ada barang',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tekan tombol + untuk menambahkan\nbarang baru ke inventaris',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            return ItemCard(
              item: controller.items[index],
              onEdit: () => _navigateToEdit(index),
              onDelete: () => controller.confirmDelete(index),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTambah,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
