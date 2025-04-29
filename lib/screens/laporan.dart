import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:flutter/material.dart';
import 'package:admin_booking_application/services/laporan_services.dart';
import 'package:admin_booking_application/widget/subtitle_text.dart';
import 'package:intl/intl.dart';
import 'package:admin_booking_application/services/print_laporan_services.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<Laporan> {
  List<Map<String, dynamic>> allBookings = [];
  List<Map<String, dynamic>> currentBookings = [];

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  int page = 0;
  final int limit = 5;

  int get jumlahBooking => allBookings.length;

  String searchQuery = '';

  double get totalPendapatan {
    return allBookings.fold(0, (sum, booking) {
      final bayar = double.tryParse(booking['total_harga'].toString()) ?? 0;
      return sum + bayar;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllReport();
  }

  Future<void> loadAllReport() async {
    final data = await fetchReportDataPaginated(startDate, endDate, page: 0, limit: 1000);
    setState(() {
      allBookings = data;
      page = 0;
      updateCurrentPage();
    });
  }

  void updateCurrentPage() {
    final filteredBookings = searchQuery.isEmpty
        ? allBookings
        : allBookings.where((booking) {
      final name = (booking['users']['name'] ?? '').toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final start = page * limit;
    final end = start + limit;
    setState(() {
      currentBookings = filteredBookings.sublist(
        start,
        end > filteredBookings.length ? filteredBookings.length : end,
      );
    });
  }


  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      await loadAllReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final formatter = DateFormat('dd MMM yyyy');

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);
              },
            ),
            title: Row(
              children: [
              SubtitleTextWidget(label: "Laporan", color: Colors.white, fontWeight: FontWeight.bold),

              ]
            )
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleTextWidget(
                  label: "Rentang: ${formatter.format(startDate)} - ${formatter.format(endDate)}",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: pickDateRange,
                      icon: const Icon(Icons.date_range, color: Colors.black, size: 25,),
                      style: IconButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        printLaporan(
                          startDate: startDate,
                          endDate: endDate,
                          bookings: allBookings,
                        );
                      },
                      icon: const Icon(Icons.print, color: Colors.black, size: 25,),
                      style: IconButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      page = 0;
                      updateCurrentPage();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama pengguna...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryBox("Jumlah Booking", jumlahBooking.toString()),
                      _summaryBox("Pendapatan", "Rp ${totalPendapatan.toStringAsFixed(0)}"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SubtitleTextWidget(label: "Detail Booking", fontWeight: FontWeight.bold, fontSize: 16),
                const SizedBox(height: 10),
                Expanded(
                  child: allBookings.isEmpty
                      ? const Center(child: SubtitleTextWidget(label: 'Tidak ada data booking'))
                      : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: currentBookings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final b = currentBookings[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: SubtitleTextWidget(
                                  label: b['users']['name'] ?? 'Tanpa Nama',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    SubtitleTextWidget(label: "Tanggal: ${b['tanggal_booking']}", fontSize: 16),
                                    SubtitleTextWidget(label: "Waktu: ${b['waktu']}", fontSize: 16,),
                                    SubtitleTextWidget(label: "Pembayaran: ${b['metode']}", fontSize: 16),
                                  ],
                                ),
                                trailing: SubtitleTextWidget(
                                  label: "Rp ${b['total_harga']}",
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: page > 0 ? () {
                              setState(() => page--);
                              updateCurrentPage();
                            } : null,
                            child: SubtitleTextWidget(label: 'Sebelumnya'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: ((page + 1) * limit < allBookings.length) ? () {
                              setState(() => page++);
                              updateCurrentPage();
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: SubtitleTextWidget(label: "Selanjutnya"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _summaryBox(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, color: Colors.deepPurple)),
      ],
    );
  }
}