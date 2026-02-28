import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';
import '../utils/app_colors.dart';

class EditBarangScreen extends StatefulWidget {
  final Item item;

  const EditBarangScreen({super.key, required this.item});

  @override
  State<EditBarangScreen> createState() => _EditBarangScreenState();
}

class _EditBarangScreenState extends State<EditBarangScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  late TextEditingController _lokasiController;
  String? _selectedKategori;
  Uint8List? _imageBytes;
  bool _imageChanged = false;

  final List<String> _kategoriList = [
    'Elektronik',
    'Audio',
    'Furnitur',
    'Dekorasi',
    'Logistik',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item.name);
    _stokController = TextEditingController(text: widget.item.stock.toString());
    _lokasiController = TextEditingController(text: widget.item.location);
    final cat = widget.item.category.substring(0, 1) +
        widget.item.category.substring(1).toLowerCase();
    _selectedKategori = _kategoriList.contains(cat) ? cat : null;
    _imageBytes = widget.item.imageBytes;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _namaController.text != widget.item.name ||
        _stokController.text != widget.item.stock.toString() ||
        _lokasiController.text != widget.item.location ||
        _selectedKategori !=
            (widget.item.category.substring(0, 1) +
                widget.item.category.substring(1).toLowerCase()) ||
        _imageChanged;
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan Perubahan?'),
        content: const Text(
          'Perubahan yang belum disimpan akan hilang. Apakah Anda yakin ingin kembali?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Tetap Mengedit'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.delete),
            child: const Text('Ya, Kembali'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _editFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageChanged = true;
      });
    }
  }

  void _update() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedKategori == null) {
      Get.snackbar(
        'Peringatan',
        'Pilih kategori terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final category = _selectedKategori!.toUpperCase();
    final updated = widget.item.copyWith(
      name: _namaController.text.trim(),
      category: category,
      stock: int.parse(_stokController.text.trim()),
      location: _lokasiController.text.trim(),
      imageBytes: _imageBytes,
      icon: getIconForCategory(category),
      iconBgColor: getBgColorForCategory(category),
      categoryColor: getCategoryBadgeColor(category),
    );

    Get.back(result: updated);
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop) Get.back();
            },
          ),
          title: const Text(
            'Edit Barang',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: false,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Nama Barang
                      _buildSectionLabel('NAMA BARANG'),
                      TextFormField(
                        controller: _namaController,
                        decoration: _buildInputDecoration(hintText: 'Nama barang'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama barang wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Kategori
                      _buildSectionLabel('KATEGORI'),
                      DropdownButtonFormField<String>(
                        value: _selectedKategori,
                        decoration: _buildInputDecoration(hintText: 'Pilih Kategori'),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                        items: _kategoriList.map((item) {
                          return DropdownMenuItem(value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategori = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Stok Saat Ini
                      _buildSectionLabel('STOK SAAT INI'),
                      TextFormField(
                        controller: _stokController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          hintText: 'Jumlah stok',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 16, top: 14, bottom: 14),
                            child: Text(
                              widget.item.satuan,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stok wajib diisi';
                          }
                          final stok = int.tryParse(value.trim());
                          if (stok == null) return 'Masukkan angka yang valid';
                          if (stok <= 0) return 'Stok harus lebih dari 0';
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Lokasi Penyimpanan
                      _buildSectionLabel('LOKASI PENYIMPANAN'),
                      TextFormField(
                        controller: _lokasiController,
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Rak A-12, Lantai 2',
                          prefixIcon: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lokasi penyimpanan wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Edit Foto
                      _buildSectionLabel('EDIT FOTO'),
                      GestureDetector(
                        onTap: _editFoto,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _imageBytes != null
                                  ? Image.memory(
                                      _imageBytes!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0E0E0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.photo_camera_outlined,
                                        size: 32,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                            ),
                            // Edit overlay badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ketuk untuk ganti foto',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () async {
                            final shouldPop = await _onWillPop();
                            if (shouldPop) {
                              Get.back();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _update,
                          icon: const Icon(Icons.save, color: Colors.white, size: 18),
                          label: const Text(
                            'Update Barang',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
