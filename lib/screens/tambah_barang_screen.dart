import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';
import '../utils/app_colors.dart';

class TambahBarangScreen extends StatefulWidget {
  const TambahBarangScreen({super.key});

  @override
  State<TambahBarangScreen> createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _lokasiController = TextEditingController();
  DateTime? _tanggalMasuk;
  String? _selectedKategori;
  String? _selectedSatuan;
  Uint8List? _imageBytes;

  final List<String> _kategoriList = [
    'Elektronik',
    'Audio',
    'Furnitur',
    'Dekorasi',
    'Logistik',
  ];

  final List<String> _satuanList = [
    'Pcs / Buah',
    'Unit',
    'Set',
    'Lusin',
    'Kg',
  ];

  bool get _hasAnyInput {
    return _kodeController.text.isNotEmpty ||
        _namaController.text.isNotEmpty ||
        _stokController.text.isNotEmpty ||
        _lokasiController.text.isNotEmpty ||
        _selectedKategori != null ||
        _selectedSatuan != null ||
        _tanggalMasuk != null ||
        _imageBytes != null;
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _stokController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasAnyInput) return true;
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan Pengisian?'),
        content: const Text(
          'Data yang sudah diisi akan hilang. Apakah Anda yakin ingin kembali?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Tetap Mengisi'),
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

  Future<void> _pickImage() async {
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
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _tanggalMasuk = picked;
      });
    }
  }

  void _simpan() {
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
    if (_selectedSatuan == null) {
      Get.snackbar(
        'Peringatan',
        'Pilih satuan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    if (_tanggalMasuk == null) {
      Get.snackbar(
        'Peringatan',
        'Pilih tanggal masuk terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final category = _selectedKategori!.toUpperCase();
    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _namaController.text.trim(),
      kodeBarang: _kodeController.text.trim(),
      category: category,
      stock: int.parse(_stokController.text.trim()),
      satuan: _selectedSatuan!,
      location: _lokasiController.text.trim(),
      tanggalMasuk: _tanggalMasuk,
      imageBytes: _imageBytes,
      icon: getIconForCategory(category),
      iconBgColor: getBgColorForCategory(category),
      categoryColor: getCategoryBadgeColor(category),
    );

    Get.back(result: item);
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
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
              if (shouldPop) {
                Get.back();
              }
            },
          ),
          title: const Text(
            'Tambah Barang Baru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header info
                Container(
                  width: double.infinity,
                  color: AppColors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Detail Barang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Lengkapi formulir di bawah untuk mendaftarkan barang baru ke sistem.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Kode Barang
                      _buildLabel('Kode Barang'),
                      TextFormField(
                        controller: _kodeController,
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: BRG-001',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kode barang wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Nama Barang
                      _buildLabel('Nama Barang'),
                      TextFormField(
                        controller: _namaController,
                        decoration: _buildInputDecoration(
                          hintText: 'Masukkan nama barang',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama barang wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Kategori
                      _buildLabel('Kategori'),
                      DropdownButtonFormField<String>(
                        value: _selectedKategori,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Kategori',
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                        items: _kategoriList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategori = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Jumlah Stok
                      _buildLabel('Jumlah Stok'),
                      TextFormField(
                        controller: _stokController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          hintText: 'Masukkan jumlah stok',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Jumlah stok wajib diisi';
                          }
                          final stok = int.tryParse(value.trim());
                          if (stok == null) {
                            return 'Masukkan angka yang valid';
                          }
                          if (stok <= 0) {
                            return 'Stok harus lebih dari 0';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Satuan
                      _buildLabel('Satuan'),
                      DropdownButtonFormField<String>(
                        value: _selectedSatuan,
                        decoration: _buildInputDecoration(
                          hintText: 'Pcs / Buah',
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                        items: _satuanList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSatuan = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Lokasi Penyimpanan
                      _buildLabel('Lokasi Penyimpanan'),
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

                      const SizedBox(height: 20),

                      // Tanggal Masuk
                      _buildLabel('Tanggal Masuk'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: _buildInputDecoration(
                              hintText: _tanggalMasuk != null
                                  ? '${_tanggalMasuk!.day.toString().padLeft(2, '0')}/${_tanggalMasuk!.month.toString().padLeft(2, '0')}/${_tanggalMasuk!.year}'
                                  : 'dd/mm/yyyy',
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Foto Barang
                      _buildLabel('Foto Barang'),
                      Row(
                        children: [
                          if (_imageBytes != null) ...[
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    _imageBytes!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _imageBytes = null;
                                      });
                                    },
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                          ],
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 24,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tambah',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Simpan Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _simpan,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            'Simpan Barang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
