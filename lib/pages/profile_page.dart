import 'package:flutter/material.dart';
import 'homePage.dart';
import 'daftarBarang.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Color palette constants
  static const Color primaryPink = Color(0xFFFCE4EC);
  static const Color primaryWhite = Colors.white;
  static const Color primaryBlack = Colors.black;
  static const Color accentPink = Color(0xFFF48FB1);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Data anggota kelompok 1 - dengan path gambar (8 orang)
  final List<Map<String, String>> members = [
    {
      'name': 'Yohanes Soni Beda Ongololong',
      'nim': '16231007',
      'role': 'Frontend Developer',
      'image': 'assets/soni.png.jpeg',
    },
    {
      'name': 'Zaenal Ahmad Asori',
      'nim': '16231010',
      'role': 'Backend Developer',
      'image': 'assets/zaen.jpeg',
    },
    {
      'name': 'Raditha Sabila',
      'nim': '16231009',
      'role': 'UI/UX Designer',
      'image': 'assets/dita.jpeg',
    },
    {
      'name': 'Yasmin Salsabila',
      'nim': '16232002',
      'role': 'UI/UX Designer',
      'image': 'assets/min.jpeg',
    },
    {
      'name': 'Muhammad Nasrulloh Alutfi',
      'nim': '16232009',
      'role': 'Frontend Developer',
      'image': 'assets/srul.jpg',
    },
    {
      'name': 'Mochamad Sapta Maulana Surya',
      'nim': '16232004',
      'role': 'Backend Developer',
      'image': 'assets/sapt.jpeg',
    },
    {
      'name': 'Fani Rahma Oktaviani',
      'nim': '16232003',
      'role': 'UI/UX Designer',
      'image': 'assets/fani.jpeg',
    },
    {
      'name': 'Esi Mayangsari',
      'nim': '16232008',
      'role': 'UI/UX Designer',
      'image': 'assets/rina.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
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
    }
    // Index 2 is current page (Profile)
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryPink, accentPink.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Group Logo/Icon - Logo Kost Stock
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primaryWhite,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/LogoKostStock.jpg',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.store, size: 40, color: Colors.black54),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Group Title
          const Text(
            'KELOMPOK 1',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryWhite.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Aplikasi Kost Stock Inventory',
              style: TextStyle(
                fontSize: 14,
                color: primaryBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(String imagePath, String fallbackText) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: accentPink.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback jika gambar tidak ditemukan
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accentPink, accentPink.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  fallbackText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryWhite,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, String> member, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 24 : 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar dengan gambar
                  Hero(
                    tag: 'avatar_$index',
                    child: _buildAvatarImage(
                      member['image']!,
                      member['name']![0], // Fallback ke huruf pertama nama
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Member Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: ${member['nim']!}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member['role']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: primaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: accentPink,
                        size: 20,
                      ),
                      onPressed: () {
                        // Show member details or actions
                        _showMemberDetails(member);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogAvatar(String imagePath, String fallbackText) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentPink, accentPink.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  fallbackText,
                  style: const TextStyle(
                    color: primaryWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMemberDetails(Map<String, String> member) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                _buildDialogAvatar(member['image']!, member['name']![0]),
                const SizedBox(width: 12),
                const Text('Detail Anggota'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nama', member['name']!),
                _buildDetailRow('NIM', member['nim']!),
                _buildDetailRow('Posisi', member['role']!),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: accentPink),
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: primaryBlack)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: const Text(
          'Profile Kelompok',
          style: TextStyle(color: primaryBlack, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlack),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Tentang Aplikasi'),
                      content: const Text(
                        'Aplikasi Inventory Barang\nDikembangkan oleh Kelompok 1\nMata Kuliah: Pemrograman Mobile\nFakultas Teknologi Informasi\nJurusan Sistem Informasi',
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: accentPink,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(),

              // Members List
              ...members
                  .map(
                    (member) =>
                        _buildMemberCard(member, members.indexOf(member)),
                  )
                  ,

              // Footer
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryPink),
                ),
                child: Column(
                  children: [
                    // Logo Kampus
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: primaryWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/ars.png', // Ganti dengan path logo kampus Anda
                          width: 60,
                          height: 60,
                          fit:
                              BoxFit
                                  .contain, // Menggunakan contain agar logo tidak terpotong
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: primaryPink,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.school,
                                color: accentPink,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Informasi Kampus
                    const Text(
                      'ARS University - 2025',
                      style: TextStyle(
                        color: primaryBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fakultas Teknologi Informasi',
                      style: TextStyle(
                        color: primaryBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Jurusan Sistem Informasi',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryPink,
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
          currentIndex: 2, // Profile is selected
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Keranjang',
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
                child: const Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
