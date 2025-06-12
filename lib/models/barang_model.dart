// models/barang_model.dart
class Barang {
  final int? id;
  final String cate;
  final String nama;
  final String kode;
  final int jumlah;
  final String deskripsi;
  final String tanggal;

  Barang({
    this.id,
    required this.cate,
    required this.nama,
    required this.kode,
    required this.jumlah,
    required this.deskripsi,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cate': cate, // Diperbaiki dari 'category' ke 'cate'
      'nama': nama,
      'kode': kode,
      'jumlah': jumlah,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    };
  }

  factory Barang.fromMap(Map<String, dynamic> map) {
    return Barang(
      id: map['id'],
      cate: map['cate'], // Diperbaiki dari 'category' ke 'cate'
      nama: map['nama'],
      kode: map['kode'],
      jumlah: map['jumlah'],
      deskripsi: map['deskripsi'],
      tanggal: map['tanggal'],
    );
  }
}
