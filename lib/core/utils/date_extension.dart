// lib/core/utils/date_extension.dart

extension StringDateExtension on String {
  String toIndoDateTime() {
    if (this.isEmpty) return '-';

    try {
      // 'this' merujuk pada string yang sedang dipanggil
      DateTime date = DateTime.parse(this).toLocal();

      List<String> hari = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu'
      ];
      List<String> bulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      String namaHari = hari[date.weekday - 1];
      String tanggal = date.day.toString().padLeft(2, '0');
      String namaBulan = bulan[date.month - 1];
      String tahun = date.year.toString();

      String jam = date.hour.toString().padLeft(2, '0');
      String menit = date.minute.toString().padLeft(2, '0');
      String detik = date.second.toString().padLeft(2, '0');

      return '$namaHari, $tanggal $namaBulan $tahun $jam:$menit:$detik';
    } catch (e) {
      return '-';
    }
  }
  String toIndoDateOnly() {
    if (this.isEmpty) return '-';

    try {
      DateTime date = DateTime.parse(this).toLocal();
      List<String> bulan = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];

      String tanggal = date.day.toString().padLeft(2, '0');
      String namaBulan = bulan[date.month - 1];
      String tahun = date.year.toString();

      return '$tanggal $namaBulan $tahun';
    } catch (e) {
      return '-';
    }
  }
}
