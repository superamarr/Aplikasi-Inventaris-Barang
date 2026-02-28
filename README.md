# 📦 Dokumentasi Proyek — Inventaris Barang

> **Jenis Proyek:** Aplikasi Inventaris Barang
> **Tech Stack:** Flutter (Mobile & Web)  

---

## 📋 Daftar Isi

1. [Gambaran Umum](#1-gambaran-umum)
2. [Teknologi & Dependensi](#2-teknologi--dependensi)
3. [Struktur Direktori](#3-struktur-direktori)
4. [Arsitektur Aplikasi](#4-arsitektur-aplikasi)
5. [Design System](#5-design-system)
6. [Model Data](#6-model-data)
7. [Controller](#7-controller--state-management)
8. [Fitur & Tampilan](#8-fitur--tampilan)
   - [8.1 Halaman Utama (Inventaris Screen)](#81-halaman-utama--inventaris-screen)
   - [8.2 Tambah Barang](#82-tambah-barang--tambah-barang-screen)
   - [8.3 Edit Barang](#83-edit-barang--edit-barang-screen)
9. [Widget Reusable](#9-widget-reusable)
10. [Alur Navigasi](#10-alur-navigasi)
11. [Validasi Form](#11-validasi-form)
12. [Penanganan Error & Dialog](#12-penanganan-error--dialog)

---

## 1. Gambaran Umum

**Inventaris Barang** adalah aplikasi manajemen inventaris sederhana berbasis Flutter. Aplikasi ini memungkinkan pengguna untuk **mencatat**, **memperbarui**, dan **menghapus** data barang secara efisien melalui antarmuka yang bersih dan intuitif.

### ✨ Fitur Utama
| Fitur | Keterangan |
|---|---|
| **Tambah Barang** | Input data barang baru dengan formulir lengkap |
| **Lihat Daftar** | Tampilkan semua barang dalam bentuk kartu |
| **Edit Barang** | Perbarui informasi barang yang sudah ada |
| **Hapus Barang** | Hapus barang dengan konfirmasi dialog |
| **Foto Barang** | Lampirkan foto dari galeri perangkat |
| **Kategori Otomatis** | Ikon dan warna badge menyesuaikan kategori |

---

## 2. Teknologi & Dependensi

### Framework
- **Flutter SDK** `^3.10.8`
- **Material Design 3** (MD3) dengan `useMaterial3: true`

### Package / Dependensi

| Package | Versi | Fungsi |
|---|---|---|
| `get` | `^4.7.3` | State management, navigasi, dan snackbar/dialog |
| `image_picker` | `^1.1.2` | Memilih foto dari galeri perangkat |

---

## 3. Struktur Direktori

```
inventaris_barang/
│
├── lib/
│   ├── main.dart                    # Entry point & konfigurasi aplikasi
│   │
│   ├── controllers/
│   │   └── inventaris_controller.dart   # State management (GetX)
│   │
│   ├── models/
│   │   └── item.dart                # Model data barang & helper functions
│   │
│   ├── screens/
│   │   ├── inventaris_screen.dart       # Halaman utama (daftar barang)
│   │   ├── tambah_barang_screen.dart    # Halaman tambah barang baru
│   │   └── edit_barang_screen.dart      # Halaman edit barang
│   │
│   ├── widgets/
│   │   └── item_card.dart               # Komponen kartu barang (reusable)
│   │
│   └── utils/
│       └── app_colors.dart              # Konstanta warna aplikasi
│
├── pubspec.yaml                     # Konfigurasi dependensi
└── DOKUMENTASI.md                   # Dokumentasi proyek (file ini)
```

---

## 4. Arsitektur Aplikasi

Aplikasi menggunakan pola arsitektur **GetX MVC (Model-View-Controller)**:

```
┌─────────────────────────────────────────────────────┐
│                      View (Screens)                  │
│   InventarisScreen  ─  TambahBarangScreen            │
│                        EditBarangScreen              │
└─────────────────┬───────────────────────────────────┘
                  │  Observes & Calls
                  ▼
┌─────────────────────────────────────────────────────┐
│              Controller (GetX)                       │
│            InventarisController                      │
│   addItem() │ updateItem() │ deleteItem()            │
└─────────────────┬───────────────────────────────────┘
                  │  Manages
                  ▼
┌─────────────────────────────────────────────────────┐
│                 Model (Data)                         │
│                 Item (class)                         │
│   name, kode, category, stock, location, foto...     │
└─────────────────────────────────────────────────────┘
```

### Penjelasan Alur
1. **`main.dart`** mendaftarkan `InventarisController` sebagai *singleton* global melalui `initialBinding`.
2. **Screen** (View) mengakses controller melalui `GetView<InventarisController>` atau `Get.find()`.
3. **Controller** menyimpan state daftar barang dalam `RxList<Item>` yang reaktif (`items.obs`).
4. Perubahan data di controller akan otomatis memperbarui UI melalui `Obx(() => ...)`.

---

## 5. Design System

Semua konstanta visual terpusat di `lib/utils/app_colors.dart`.

### Palet Warna

| Nama Konstanta | Hex | Penggunaan |
|---|---|---|
| `primary` | `#E8601C` | Warna utama (tombol, FAB, aksen) |
| `primaryLight` | `#FFF3EE` | Background ringan berbasis primary |
| `background` | `#F5F5F5` | Latar belakang scaffold |
| `white` | `#FFFFFF` | Kartu, AppBar, input field |
| `textPrimary` | `#2D2D2D` | Teks utama / judul |
| `textSecondary` | `#757575` | Teks pendukung / hint |
| `edit` | `#455A64` | Tombol aksi edit (biru-abu) |
| `delete` | `#E8601C` | Tombol aksi hapus (sama dengan primary) |

### Warna Badge Kategori

| Kategori | Warna |
|---|---|
| Elektronik | `#E8601C` (orange) |
| Furnitur | `#E8601C` (orange) |
| Dekorasi | `#E8601C` (orange) |
| Logistik | `#E8601C` (orange) |

### Tema Global (`main.dart`)
- **`colorSchemeSeed`**: `#E8601C` — menghasilkan palet Material 3 otomatis
- **AppBar**: Background putih bersih, tanpa elevation, teks bold 20px
- **Input Fields**: Rounded corners `12px`, warna primary saat focus

---

## 6. Model Data

**File:** `lib/models/item.dart`

### Class `Item`

```dart
class Item {
  String id;           // ID unik (timestamp millisecond)
  String name;         // Nama barang
  String kodeBarang;   // Kode unik barang (misal: BRG-001)
  String category;     // Kategori barang (huruf kapital)
  int stock;           // Jumlah stok
  String satuan;       // Satuan stok (Pcs, Unit, Set, dsb.)
  String location;     // Lokasi penyimpanan
  DateTime? tanggalMasuk;  // Tanggal masuk barang (opsional)
  Uint8List? imageBytes;   // Data foto barang dalam bytes (opsional)
  IconData icon;       // Icon Material sesuai kategori
  Color iconBgColor;   // Warna latar icon di kartu
  Color categoryColor; // Warna badge label kategori
}
```

### Method `copyWith()`
Digunakan oleh `EditBarangScreen` untuk membuat salinan objek `Item` dengan beberapa field yang diperbarui, tanpa mengubah field lainnya (immutable-style update).

```dart
Item copyWith({ String? name, int? stock, ... }) { ... }
```

### Helper Functions

| Fungsi | Input | Output |
|---|---|---|
| `getIconForCategory(category)` | String kategori | `IconData` yang sesuai |
| `getBgColorForCategory(category)` | String kategori | `Color` latar icon |
| `getCategoryBadgeColor(category)` | String kategori | `Color` badge kategori |

**Pemetaan Ikon per Kategori:**
| Kategori | Icon |
|---|---|
| ELEKTRONIK | `Icons.laptop_mac` |
| FURNITUR | `Icons.chair` |
| DEKORASI | `Icons.watch_later_outlined` |
| LOGISTIK | `Icons.local_shipping` |
| *(lainnya)* | `Icons.inventory_2` |

---

## 7. Controller — State Management

**File:** `lib/controllers/inventaris_controller.dart`  
**Pattern:** GetX Controller

```dart
class InventarisController extends GetxController {
  final items = <Item>[].obs;   // RxList — reaktif, otomatis rebuild UI
  ...
}
```

### Daftar Method

---

#### `addItem(Item item)`
Menambahkan barang baru ke dalam daftar inventaris.

```
Dipanggil oleh: InventarisScreen (setelah navigasi dari TambahBarangScreen berhasil)
```

---

#### `updateItem(int index, Item item)`
Mengganti barang pada indeks tertentu dengan data yang sudah diperbarui.

```
Dipanggil oleh: InventarisScreen (setelah navigasi dari EditBarangScreen berhasil)
```

---

#### `deleteItem(int index)`
Menghapus barang dari daftar, lalu menampilkan **Snackbar** konfirmasi berhasil.

```
Snackbar:
  - Judul   : "Berhasil"
  - Pesan   : '"[NamaBarang]" telah dihapus dari inventaris'
  - Warna   : AppColors.primary (orange)
  - Durasi  : 2 detik
  - Posisi  : Bottom
```

---

#### `confirmDelete(int index)` — *async*
Menampilkan **AlertDialog** konfirmasi sebelum menghapus. Memanggil `deleteItem()` hanya jika pengguna menekan tombol "Hapus".

```
Dialog:
  - Judul   : "Hapus Barang?"
  - Tombol  : "Batal" | "Hapus" (merah)
```

---

## 8. Fitur & Tampilan

---

### 8.1 Halaman Utama — Inventaris Screen

**File:** `lib/screens/inventaris_screen.dart`  
**Widget Type:** `GetView<InventarisController>` (StatelessWidget + GetX)

> Halaman ini adalah halaman pertama yang dibuka saat aplikasi dijalankan.

---

#### 🖥️ Tampilan & Komponen UI

<table>
<tr>
<td width="65%" valign="top">

**AppBar:**
- Icon inventaris berlatar `primaryLight` di sebelah kiri
- Judul **"Inventaris"** bold di sebelah kanan icon
- Background putih tanpa shadow

**Body — Kondisi Kosong:**
Saat belum ada barang terdaftar, ditampilkan tampilan *empty state*:
- Ikon `inventory_2_outlined` besar berlatar orange muda
- Teks **"Belum ada barang"**
- Teks panduan untuk menekan tombol `+`

**Body — Ada Data:**
Daftar barang ditampilkan menggunakan `ListView.builder` yang memuat widget `ItemCard` untuk setiap item. Daftar ini **reaktif**: otomatis memperbarui tampilan ketika data berubah melalui `Obx(() => ...)`.

**Floating Action Button (FAB):**
- Tombol bulat berwarna `primary` (orange)
- Icon `+` putih
- Mengarahkan ke halaman **Tambah Barang**

</td>
<td width="35%" valign="top" align="center">

<!-- Tambahkan screenshot halaman utama di sini -->
<img width="331" height="626" alt="image" src="https://github.com/user-attachments/assets/d95baa79-54b8-48c6-9bd9-aab669818d58" />


</td>
</tr>
</table>

---

#### ⚙️ Logika Navigasi

```dart
// Navigasi ke Tambah Barang
Future<void> _navigateToTambah() async {
  final result = await Get.to<Item>(() => const TambahBarangScreen());
  if (result != null) {
    controller.addItem(result); // Simpan barang ke daftar
  }
}

// Navigasi ke Edit Barang
Future<void> _navigateToEdit(int index) async {
  final result = await Get.to<Item>(
    () => EditBarangScreen(item: controller.items[index]),
  );
  if (result != null) {
    controller.updateItem(index, result); // Perbarui barang
  }
}
```

**Pola yang digunakan:** Navigasi berbasis *return value* — screen anak mengembalikan objek `Item` ke parent melalui `Get.back(result: item)`.

---

### 8.2 Tambah Barang — Tambah Barang Screen

**File:** `lib/screens/tambah_barang_screen.dart`  
**Widget Type:** `StatefulWidget`

> Formulir untuk mendaftarkan barang baru ke dalam sistem inventaris.

---

#### 🖥️ Tampilan & Komponen UI

<table>
<tr>
<td width="65%" valign="top">

**AppBar:**
- Tombol back kiri dengan logika konfirmasi
- Judul **"Tambah Barang Baru"**

**Header Section:**
- Banner informasi dengan ikon dan deskripsi formulir
- Teks *"Informasi Detail Barang"* dan *"Lengkapi formulir di bawah..."*

**Form Fields (urutan):**

| No | Field | Tipe Input | Validasi |
|----|---|---|---|
| 1 | **Kode Barang** | `TextFormField` | Wajib diisi |
| 2 | **Nama Barang** | `TextFormField` | Wajib diisi |
| 3 | **Kategori** | `DropdownButtonFormField` | Wajib dipilih |
| 4 | **Jumlah Stok** | `TextFormField` (angka) | Wajib, > 0 |
| 5 | **Satuan** | `DropdownButtonFormField` | Wajib dipilih |
| 6 | **Lokasi Penyimpanan** | `TextFormField` | Wajib diisi |
| 7 | **Tanggal Masuk** | Date Picker (read-only) | Wajib dipilih |
| 8 | **Foto Barang** | Image Picker | Opsional |

**Tombol Simpan:**
- `ElevatedButton` lebar penuh
- Label **"Simpan Barang"** dengan ikon simpan
- Warna `primary` (orange)

</td>
<td width="35%" valign="top" align="center">

<!-- Tambahkan screenshot halaman Tambah Barang di sini -->
<img width="326" height="619" alt="image" src="https://github.com/user-attachments/assets/763e6546-e3c5-4e9a-9e6d-85d6b0ff71de" />


</td>
</tr>
</table>

---

#### ⚙️ Logika & State

**State variables:**
```dart
final _formKey = GlobalKey<FormState>();     // Kunci validasi form
final _kodeController = TextEditingController();
final _namaController = TextEditingController();
final _stokController = TextEditingController();
final _lokasiController = TextEditingController();
DateTime? _tanggalMasuk;       // Tanggal yang dipilih
String? _selectedKategori;     // Kategori yang dipilih
String? _selectedSatuan;       // Satuan yang dipilih
Uint8List? _imageBytes;        // Byte data foto yang dipilih
```

**`_pickImage()`** — Membuka galeri foto menggunakan `ImagePicker`:
- Ukuran maksimal: 800×800 px
- Kualitas kompresi: 80%
- Hasil disimpan sebagai `Uint8List` di `_imageBytes`

**`_pickDate()`** — Membuka kalender Material:
- Range: tahun 2020 — 2030
- Default: tanggal hari ini

**`_simpan()`** — Dipanggil saat tombol **Simpan Barang** ditekan:
1. Validasi form dengan `_formKey.currentState!.validate()`
2. Cek kategori, satuan, tanggal — tampilkan snackbar merah jika kosong
3. Buat objek `Item` baru dengan `id` = `DateTime.now().millisecondsSinceEpoch.toString()`
4. Ikon dan warna ditentukan otomatis dari kategori via helper function
5. Kembalikan item ke parent: `Get.back(result: item)`

**`_hasAnyInput`** (getter) — Mendeteksi apakah form sudah memiliki input untuk memicu dialog konfirmasi saat back.

**`_onWillPop()`** — Dialog konfirmasi **"Batalkan Pengisian?"** jika form sudah ada isian.

---

#### 📋 Daftar Kategori & Satuan

```
Kategori: Elektronik | Audio | Furnitur | Dekorasi | Logistik
Satuan  : Pcs / Buah | Unit | Set | Lusin | Kg
```

---

### 8.3 Edit Barang — Edit Barang Screen

**File:** `lib/screens/edit_barang_screen.dart`  
**Widget Type:** `StatefulWidget`

> Formulir untuk memperbarui data barang yang sudah ada. Diinisialisasi dengan data barang yang dipilih.

---

#### 🖥️ Tampilan & Komponen UI

<table>
<tr>
<td width="65%" valign="top">

**AppBar:**
- Tombol back kiri dengan logika konfirmasi
- Judul **"Edit Barang"**

**Form Fields (urutan):**

| No | Field | Keterangan |
|----|---|---|
| 1 | **Nama Barang** | Pre-filled dengan nilai sebelumnya |
| 2 | **Kategori** | Pre-filled, dropdown pilihan |
| 3 | **Stok Saat Ini** | Pre-filled + suffix teks satuan |
| 4 | **Lokasi Penyimpanan** | Pre-filled dengan nilai sebelumnya |
| 5 | **Edit Foto** | Tampilkan foto saat ini, ketuk untuk ganti |

> **Catatan:** Kode Barang, Satuan, dan Tanggal Masuk **tidak dapat diubah** pada halaman edit untuk menjaga konsistensi data.

**Bottom Action Bar:**
- Tombol **"Batal"** (outlined) — konfirmasi jika ada perubahan
- Tombol **"Update Barang"** (filled, orange) — simpan perubahan

</td>
<td width="35%" valign="top" align="center">

<!-- Tambahkan screenshot halaman Edit Barang di sini -->
<img width="330" height="627" alt="image" src="https://github.com/user-attachments/assets/24fa0417-456c-4036-a7f4-0bbcddc91d04" />


</td>
</tr>
</table>

---

#### ⚙️ Logika & State

**State variables:**
```dart
bool _imageChanged = false;  // Penanda apakah foto sudah diganti
```

**Inisialisasi (`initState`):**
```dart
// Pre-fill semua controller dengan data awal
_namaController = TextEditingController(text: widget.item.name);
_stokController  = TextEditingController(text: widget.item.stock.toString());
_lokasiController = TextEditingController(text: widget.item.location);
// Konversi kategori dari UPPERCASE ke Title Case untuk dropdown
final cat = widget.item.category[0] + widget.item.category.substring(1).toLowerCase();
_selectedKategori = _kategoriList.contains(cat) ? cat : null;
_imageBytes = widget.item.imageBytes;
```

**`_hasChanges`** (getter) — Mendeteksi apakah ada perubahan yang dilakukan user. Membandingkan nilai controller saat ini dengan nilai awal di `widget.item`. Memastikan dialog konfirmasi hanya muncul jika benar-benar ada perubahan.

**`_editFoto()`** — Sama seperti `_pickImage()` di TambahBarang, namun juga mengubah flag `_imageChanged = true`.

**`_update()`** — Dipanggil saat tombol **"Update Barang"** ditekan:
1. Validasi form
2. Cek kategori tidak kosong
3. Buat `Item` baru menggunakan `widget.item.copyWith(...)` — **ID dan field yang tidak bisa diubah tetap dipertahankan**
4. Kembalikan ke parent: `Get.back(result: updated)`

**`_onWillPop()`** — Dialog konfirmasi **"Batalkan Perubahan?"** jika ada perubahan yang belum disimpan.

---

## 9. Widget Reusable

### `ItemCard`

**File:** `lib/widgets/item_card.dart`  
**Type:** `StatelessWidget`

Widget kartu yang menampilkan **ringkasan informasi** satu barang dalam daftar inventaris.

---

#### 🖥️ Tampilan & Komponen UI

<table>
<tr>
<td width="65%" valign="top">

**Struktur Visual Kartu:**

```
┌──────────────────────────────────────┐
│  [Foto/Icon]  Nama Barang  [KATEGORI]│
│               📦 Stok: 10 Pcs        │
│               📍 Lokasi: Rak A-1     │
├──────────────────────────────────────┤
│   ✏️ Edit           🗑️ Hapus          │
└──────────────────────────────────────┘
```

**Bagian Atas (Info):**
- Area gambar/icon berukuran 72×72 px, sudut rounded
- Jika `imageBytes` tersedia: tampilkan foto dengan `Image.memory()`
- Jika kosong: tampilkan `IconData` sesuai kategori
- Nama barang (bold, ellipsis jika terlalu panjang)
- Badge kategori (rounded rectangle, warna sesuai kategori)
- Teks stok dengan icon inventori kecil
- Teks lokasi dengan icon pin lokasi kecil

**Bagian Bawah (Aksi):**
- Dibatasi oleh `Divider` horizontal
- Dua tombol `InkWell` dibagi rata: **Edit** (biru-abu) dan **Hapus** (orange)
- Dibatasi oleh `VerticalDivider` di tengah

</td>
<td width="35%" valign="top" align="center">

<!-- Tambahkan screenshot Item Card di sini -->
> 📷 *Tambahkan screenshot*
> *widget item card di sini*

</td>
</tr>
</table>

---

#### Props (Constructor Parameters)

| Parameter | Tipe | Keterangan |
|---|---|---|
| `item` | `Item` | Data barang yang ditampilkan *(required)* |
| `onEdit` | `VoidCallback?` | Callback saat tombol Edit ditekan |
| `onDelete` | `VoidCallback?` | Callback saat tombol Hapus ditekan |

---

## 10. Alur Navigasi

```
                    ┌──────────────────────┐
                    │   InventarisScreen    │  ← Halaman Utama
                    │   (GetView)           │
                    └──────┬───────┬────────┘
                           │       │
             Tekan(+) │       │ Tekan "Edit" di ItemCard
                           ▼       ▼
                ┌──────────────┐  ┌──────────────────┐
                │  TambahBarang│  │  EditBarang       │
                │  Screen      │  │  Screen           │
                └──────┬───────┘  └────────┬──────────┘
                       │                   │
            Get.back(result: newItem)   Get.back(result: updatedItem)
                       │                   │
                       └─────────┬─────────┘
                                 ▼
                    controller.addItem()  atau
                    controller.updateItem()
```

**Mekanisme:** GetX digunakan untuk navigasi dengan `Get.to<T>()` yang mendukung *return value* bertipe generik. Pola ini menghindari kebutuhan callback atau event bus.

---

## 11. Validasi Form

### Halaman Tambah Barang

| Field | Aturan Validasi | Pesan Error |
|---|---|---|
| Kode Barang | Tidak boleh kosong | *"Kode barang wajib diisi"* |
| Nama Barang | Tidak boleh kosong | *"Nama barang wajib diisi"* |
| Kategori | Harus dipilih | *"Pilih kategori terlebih dahulu"* (Snackbar) |
| Jumlah Stok | Tidak kosong, angka valid, > 0 | *"Jumlah stok wajib diisi"* / *"Masukkan angka yang valid"* / *"Stok harus lebih dari 0"* |
| Satuan | Harus dipilih | *"Pilih satuan terlebih dahulu"* (Snackbar) |
| Lokasi | Tidak boleh kosong | *"Lokasi penyimpanan wajib diisi"* |
| Tanggal Masuk | Harus dipilih | *"Pilih tanggal masuk terlebih dahulu"* (Snackbar) |
| Foto | —  | *Opsional, tidak divalidasi* |

### Halaman Edit Barang

| Field | Aturan Validasi |
|---|---|
| Nama Barang | Tidak boleh kosong |
| Kategori | Harus dipilih |
| Stok | Tidak kosong, angka valid, > 0 |
| Lokasi | Tidak boleh kosong |

---

## 12. Penanganan Error & Dialog

### Dialog Konfirmasi yang Digunakan

| Situasi | Judul Dialog | Opsi |
|---|---|---|
| Back dari Tambah Barang (ada isian) | *"Batalkan Pengisian?"* | Tetap Mengisi / Ya, Kembali |
| Back dari Edit Barang (ada perubahan) | *"Batalkan Perubahan?"* | Tetap Mengedit / Ya, Kembali |
| Hapus barang | *"Hapus Barang?"* | Batal / Hapus |

### Snackbar Notifikasi

| Kondisi | Judul | Warna |
|---|---|---|
| Barang berhasil dihapus | *"Berhasil"* | Orange (primary) |
| Kategori belum dipilih | *"Peringatan"* | Merah |
| Satuan belum dipilih | *"Peringatan"* | Merah |
| Tanggal belum dipilih | *"Peringatan"* | Merah |

Semua Snackbar menggunakan:
- Posisi: **Bottom**
- Border radius: **12**
- Margin: **16** dari semua sisi
- Teks: **Putih**

---

## 📝 Catatan Pengembangan

> **Data tidak persisten** — Semua data barang disimpan di memori (in-memory `RxList`) dan akan hilang saat aplikasi ditutup. Untuk persistensi data, pertimbangkan integrasi dengan **SQLite** (`sqflite`), **SharedPreferences**, atau **Hive**.

> **ID Barang** — Dibuat dari `DateTime.now().millisecondsSinceEpoch.toString()` sehingga unik secara praktis, namun tidak dijamin unik dalam kasus ekstrem (barang ditambah bersamaan).

> **Foto** — Disimpan sebagai `Uint8List` (byte array) di memori. Untuk skala produksi, sebaiknya disimpan ke penyimpanan lokal atau cloud storage.

---
