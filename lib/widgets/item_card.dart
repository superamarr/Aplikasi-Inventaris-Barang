import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/app_colors.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto barang atau icon placeholder
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: item.iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: item.imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            item.imageBytes!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Icon(
                              item.icon,
                              size: 36,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Icon(
                          item.icon,
                          size: 36,
                          color: AppColors.textSecondary,
                        ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama + Kategori
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.categoryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Stok
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stok: ${item.stock} ${item.satuan}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Lokasi
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lokasi: ${item.location}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          // Action buttons
          IntrinsicHeight(
            child: Row(
              children: [
                // Edit button
                Expanded(
                  child: InkWell(
                    onTap: onEdit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.edit,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.edit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Garis pembatas vertikal
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
                // Hapus button
                Expanded(
                  child: InkWell(
                    onTap: onDelete,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: AppColors.delete,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hapus',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.delete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
