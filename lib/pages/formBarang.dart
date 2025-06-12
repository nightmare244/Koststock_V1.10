import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/barang_model.dart';
import 'daftarBarang.dart';
import 'homePage.dart';
import 'profile_page.dart';

class FormBarangPage extends StatefulWidget {
  final Barang? barang;
  final String? initialName;
  final String? initialCategory;

  const FormBarangPage({
    super.key,
    this.barang,
    this.initialName,
    this.initialCategory,
  });

  @override
  _FormBarangPageState createState() => _FormBarangPageState();
}

class _FormBarangPageState extends State<FormBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _cateController = TextEditingController();
  final _namaController = TextEditingController();
  final _kodeController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _tanggal;

  // Color palette constants
  static const Color primaryPink = Color(0xFFFCE4EC);
  static const Color primaryWhite = Colors.white;
  static const Color primaryBlack = Colors.black;
  static const Color accentPink = Color(0xFFF48FB1);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color borderGrey = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    if (widget.barang != null) {
      _cateController.text = widget.barang!.cate;
      _namaController.text = widget.barang!.nama;
      _kodeController.text = widget.barang!.kode;
      _jumlahController.text = widget.barang!.jumlah.toString();
      _deskripsiController.text = widget.barang!.deskripsi;
      _tanggal = DateTime.parse(widget.barang!.tanggal);
    } else {
      _cateController.text = widget.initialCategory ?? '';
      _namaController.text = widget.initialName ?? '';
    }
  }

  @override
  void dispose() {
    _cateController.dispose();
    _namaController.dispose();
    _kodeController.dispose();
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print('Submit button pressed');
    if (_formKey.currentState!.validate() && _tanggal != null) {
      print('Form validated, tanggal: $_tanggal');
      try {
        final barang = Barang(
          id: widget.barang?.id,
          cate: _cateController.text.trim(),
          nama: _namaController.text.trim(),
          kode: _kodeController.text.trim(),
          jumlah: int.parse(_jumlahController.text.trim()),
          deskripsi: _deskripsiController.text.trim(),
          tanggal: _tanggal!.toIso8601String(),
        );
        print('Barang to save: ${barang.toMap()}');

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(
                child: CircularProgressIndicator(color: accentPink),
              ),
        );

        if (widget.barang == null) {
          await DatabaseHelper.instance.insertBarang(barang);
        } else {
          await DatabaseHelper.instance.updateBarang(barang);
        }

        if (mounted) {
          Navigator.pop(context); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Barang berhasil disimpan'),
              backgroundColor: accentPink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          print('Navigating to DaftarBarangPage');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DaftarBarangPage()),
            (Route<dynamic> route) => route.isFirst,
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          print('Error saving barang: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan barang: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } else {
      print('Validation failed or tanggal is null');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi semua field dan pilih tanggal'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: _tanggal ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        // Hilangkan locale parameter untuk menghindari LocaleDataException
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: accentPink,
                onPrimary: primaryWhite,
                onSurface: primaryBlack,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: accentPink),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null && mounted) {
        setState(() {
          _tanggal = picked;
        });
        print('Tanggal berhasil dipilih: $_tanggal');

        // Show feedback bahwa tanggal berhasil dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tanggal dipilih: ${DateFormat('dd/MM/yyyy').format(picked)}',
            ),
            backgroundColor: accentPink,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking date: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memilih tanggal: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DaftarBarangPage()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: primaryBlack, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: accentPink, size: 20)
                  : null,
          filled: true,
          fillColor: lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentPink, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: _pickDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderGrey),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: accentPink, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Masuk',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tanggal == null
                          ? 'Pilih tanggal masuk'
                          : DateFormat('dd/MM/yyyy').format(_tanggal!),
                      style: TextStyle(
                        color:
                            _tanggal == null ? Colors.grey[400] : primaryBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: accentPink, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: Text(
          widget.barang == null ? 'Tambah Barang' : 'Edit Barang',
          style: const TextStyle(
            color: primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlack),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryPink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: primaryBlack,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.barang == null
                                ? 'Form Tambah Barang'
                                : 'Form Edit Barang',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Lengkapi semua informasi barang',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _cateController,
                        label: 'Kategori',
                        prefixIcon: Icons.category,
                        validator:
                            (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Kategori tidak boleh kosong'
                                    : null,
                      ),
                      _buildTextField(
                        controller: _namaController,
                        label: 'Nama Barang',
                        prefixIcon: Icons.shopping_bag,
                        validator:
                            (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Nama barang tidak boleh kosong'
                                    : null,
                      ),
                      _buildTextField(
                        controller: _kodeController,
                        label: 'Kode Barang',
                        prefixIcon: Icons.qr_code,
                        validator:
                            (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Kode barang tidak boleh kosong'
                                    : null,
                      ),
                      _buildTextField(
                        controller: _jumlahController,
                        label: 'Jumlah',
                        prefixIcon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          try {
                            final number = int.parse(val.trim());
                            if (number <= 0) {
                              return 'Jumlah harus lebih dari 0';
                            }
                            return null;
                          } catch (e) {
                            return 'Masukkan angka yang valid';
                          }
                        },
                      ),
                      _buildTextField(
                        controller: _deskripsiController,
                        label: 'Deskripsi',
                        prefixIcon: Icons.description,
                        maxLines: 3,
                        validator:
                            (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Deskripsi tidak boleh kosong'
                                    : null,
                      ),
                      _buildDateSelector(),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPink,
                            foregroundColor: primaryWhite,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submit,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                widget.barang == null
                                    ? 'Simpan Barang'
                                    : 'Update Barang',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.pink.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryBlack,
          unselectedItemColor: Colors.black54,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          currentIndex: 1,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
