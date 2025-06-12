import 'package:flutter/material.dart';
import 'formBarang.dart';
import 'daftarBarang.dart';
import 'profile_page.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> categories = [
    {
      'icon': Icons.restaurant,
      'label': 'Makanan',
      'items': [
        {'name': 'Roti Tawar', 'image': 'assets/rotitawar.avif'},
        {'name': 'Es Cream', 'image': 'assets/escream.webp'},
        {'name': 'Coklat', 'image': 'assets/silverqueen.avif'},
        {'name': 'Permen', 'image': 'assets/permen.webp'},
      ],
    },
    {
      'icon': Icons.local_drink,
      'label': 'Minuman',
      'items': [
        {'name': 'Air Aqua', 'image': 'assets/aqua.jpg'},
        {'name': 'Kopi', 'image': 'assets/kopi.jpg'},
        {'name': 'Susu', 'image': 'assets/susu.jpg'},
        {'name': 'Yogurt', 'image': 'assets/yougurt.jpg'},
      ],
    },
    {
      'icon': Icons.cleaning_services,
      'label': 'Perawatan Rumah',
      'items': [
        {'name': 'Detergen', 'image': 'assets/detergen.jpg'},
        {'name': 'Pembersih Lantai', 'image': 'assets/soklin.avif'},
        {'name': 'Pewangi Baju', 'image': 'assets/molto.avif'},
        {'name': 'Pewangi Ruangan', 'image': 'assets/stela.webp'},
      ],
    },
    {
      'icon': Icons.kitchen,
      'label': 'Kebutuhan Dapur',
      'items': [
        {'name': 'Kenzler Nugget', 'image': 'assets/nugget.jpg'},
        {'name': 'Minyak Goreng', 'image': 'assets/minyak.jpg'},
        {'name': 'Beras', 'image': 'assets/beras.jpg'},
        {'name': 'Telur Ayam', 'image': 'assets/telur.jpg'},
      ],
    },
    {
      'icon': Icons.face_retouching_natural,
      'label': 'Perawatan Tubuh',
      'items': [
        {'name': 'Shampo', 'image': 'assets/shampo.jpg'},
        {'name': 'Sabun Mandi', 'image': 'assets/sabunmandi.jpg'},
        {'name': 'Lipstik', 'image': 'assets/lipstik.jpg'},
        {'name': 'Parfum', 'image': 'assets/parfum.jpg'},
        {'name': 'Pasta Gigi', 'image': 'assets/pastagigi.jpg'},
        {'name': 'Pembalut', 'image': 'assets/pembalut.jpg'},
        {'name': 'Sabun Muka Pria', 'image': 'assets/sabunmukapria.jpg'},
        {'name': 'Sunscreen', 'image': 'assets/sunscreen.jpg'},
      ],
    },
  ];

  String? selectedCategory; // Ubah ke nullable untuk mode "semua barang"
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredItems = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = null; // Tampilkan semua barang saat awal
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _searchController.addListener(_onSearchChanged);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      isSearching = _searchController.text.isNotEmpty;
      if (isSearching) {
        _filterItems();
      }
    });
  }

  void _filterItems() {
    setState(() {
      filteredItems = [];
      String searchText = _searchController.text.toLowerCase();

      // Search across all categories when searching
      for (var category in categories) {
        final items = category['items'];
        if (items is List) {
          filteredItems.addAll(
            (items as List<Map<String, String>>).where(
              (item) => item['name']!.toLowerCase().contains(searchText),
            ),
          );
        }
      }
    });
  }

  List<Map<String, String>> get selectedItems {
    if (selectedCategory == null) {
      // Kembalikan semua barang dari semua kategori
      List<Map<String, String>> allItems = [];
      for (var category in categories) {
        final items = category['items'];
        if (items is List<Map<String, String>>) {
          allItems.addAll(items);
        }
      }
      return allItems;
    }

    final category = categories.firstWhere(
      (cat) => cat['label'] == selectedCategory,
      orElse: () => {'label': '', 'items': []},
    );
    final items = category['items'];
    if (items is List<Map<String, String>>) {
      return items;
    }
    return [];
  }

  // Method to get items to display based on search state
  List<Map<String, String>> get itemsToDisplay {
    return isSearching ? filteredItems : selectedItems;
  }

  // Method to get title based on search state
  String get displayTitle {
    return isSearching
        ? 'Hasil Pencarian'
        : (selectedCategory ?? 'Semua Barang');
  }

  Widget buildCategoryRow() {
    // Tambahkan kategori "Semua" ke daftar
    final allCategories = [
      {'icon': Icons.all_inclusive, 'label': 'Semua', 'items': []},
      ...categories,
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected =
              selectedCategory == category['label'] ||
              (selectedCategory == null && category['label'] == 'Semua');

          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory =
                      category['label'] == 'Semua'
                          ? null
                          : category['label'] as String;
                  _searchController.clear();
                  isSearching = false;
                });
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pink.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected
                            ? Colors.pink.shade200
                            : Colors.grey.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        category['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildGridSection(String title, List<Map<String, String>> items) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink.shade100, width: 2),
              ),
              child: Icon(
                isSearching ? Icons.search_off : Icons.inventory_2_outlined,
                size: 48,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Text(
              isSearching
                  ? 'Tidak ada barang ditemukan'
                  : 'Belum ada barang di kategori ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Coba kata kunci yang berbeda'
                  : 'Barang akan muncul di sini',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSearching ? Icons.search : Icons.category,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.shade100, width: 1),
                ),
                child: Text(
                  '${items.length} item',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pink.shade100, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              items[index]['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.pink.shade50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 32,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Gambar tidak\nditemukan',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    items[index]['name']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (_, __, ___) => FormBarangPage(
                                              initialName: items[index]['name'],
                                              initialCategory:
                                                  isSearching
                                                      ? _getCategoryForItem(
                                                        items[index]['name']!,
                                                      )
                                                      : selectedCategory ??
                                                          'Semua',
                                            ),
                                        transitionsBuilder: (
                                          _,
                                          animation,
                                          __,
                                          child,
                                        ) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(0.0, 1.0),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeOutCubic,
                                              ),
                                            ),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade100,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Tambah',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
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
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to find which category an item belongs to
  String _getCategoryForItem(String itemName) {
    for (var category in categories) {
      final items = category['items'] as List<Map<String, String>>;
      if (items.any((item) => item['name'] == itemName)) {
        return category['label'] as String;
      }
    }
    return selectedCategory ?? 'Semua'; // fallback
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
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
    // Index 0 adalah HomePage, tidak perlu navigasi ulang
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'KOST STOCK',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header section with search and logo
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Cari barang...',
                            hintStyle: TextStyle(color: Colors.black54),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          isSearching = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.black54,
                                      ),
                                    )
                                    : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Logo section
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
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
                                child: Icon(
                                  Icons.store,
                                  size: 40,
                                  color: Colors.black54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Categories section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Kategori',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildCategoryRow(),
                SizedBox(height: 24),
                // Grid section
                buildGridSection(displayTitle, itemsToDisplay),
                SizedBox(height: 20),
              ],
            ),
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
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration:
                    _selectedIndex == 0
                        ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                        : null,
                child: Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration:
                    _selectedIndex == 1
                        ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                        : null,
                child: Icon(Icons.shopping_cart),
              ),
              label: 'Keranjang',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration:
                    _selectedIndex == 2
                        ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        )
                        : null,
                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
