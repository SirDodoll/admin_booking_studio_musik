import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:admin_booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:admin_booking_application/services/admin_services.dart';
import 'package:admin_booking_application/widget/subtitle_text.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  bool loading = true;
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> filteredBookings = [];

  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  int currentPage = 0;
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    fetchBookings();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterBookings();
  }

  void _filterBookings() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBookings = bookings.where((booking) {
        final user = booking['users'] ?? {};
        final name = user['name']?.toString().toLowerCase() ?? '';
        final metode = booking['metode']?.toString().toLowerCase() ?? '';
        final tanggalBookingStr = booking['tanggal_booking']?.toString() ?? '';
        final tanggalBooking = DateTime.tryParse(tanggalBookingStr);
        final matchesSearch = name.contains(query) || metode.contains(query);

        bool matchesDate = true;
        if (_startDate != null && _endDate != null && tanggalBooking != null) {
          matchesDate = tanggalBooking.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              tanggalBooking.isBefore(_endDate!.add(const Duration(days: 1)));
        }

        return matchesSearch && matchesDate;
      }).toList();
      currentPage = 0;
    });
  }

  Future<void> fetchBookings() async {
    try {
      final result = await AdminBookingService.fetchBookings();
      setState(() {
        bookings = List<Map<String, dynamic>>.from(result['data'] ?? []);
        loading = false;
      });
      _filterBookings();
    } catch (e) {
      print('Error saat fetch bookings: $e');
      setState(() => loading = false);
    }
  }

  List<Map<String, dynamic>> get paginatedBookings {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredBookings.sublist(
      startIndex,
      endIndex > filteredBookings.length ? filteredBookings.length : endIndex,
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _filterBookings();
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final user = booking['users'] ?? {};
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubtitleTextWidget(
              label: user['name']?.toString() ?? 'Nama tidak diketahui',
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
            const SizedBox(height: 11),
            SubtitleTextWidget(label: "Tanggal: ${booking['tanggal_booking']}"),
            SubtitleTextWidget(label: "Waktu: ${booking['waktu']}"),
            SubtitleTextWidget(label: "Metode Pembayaran: ${booking['metode']}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const SubtitleTextWidget(label: "Konfirmasi booking ini?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const SubtitleTextWidget(label: "Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const SubtitleTextWidget(label: "Ya"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await AdminBookingService.updateBookingStatus(
                        booking['id'].toString(), 'confirmed',
                      );
                      fetchBookings();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const SubtitleTextWidget(label: 'Konfirmasi', color: Colors.white),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final cancel = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const SubtitleTextWidget(label: "Batalkan Booking?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const SubtitleTextWidget(label: "Tidak"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: SubtitleTextWidget(label: "Ya"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white
                            ),
                          ),
                        ],
                      ),
                    );

                    if (cancel == true) {
                      await AdminBookingService.updateBookingStatus(
                        booking['id'].toString(),
                        'canceled',
                      );
                      fetchBookings();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const SubtitleTextWidget(label: 'Batal', color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (route) => false,
              );
            },
          ),
          title: const SubtitleTextWidget(
            label: "Booking",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 12),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   ElevatedButton.icon(
                     onPressed: _selectDateRange,
                     icon: const Icon(Icons.date_range, color: Colors.black,),
                     label: const SubtitleTextWidget(
                       label: 'Filter',
                     ),
                     style: ElevatedButton.styleFrom(
                         backgroundColor: secondaryColor,
                         foregroundColor: Colors.black
                     ),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       SizedBox(
                         width: 190,
                         child: TextField(
                           controller: _searchController,
                           decoration: InputDecoration(
                             hintText: 'Cari...',
                             prefixIcon: const Icon(Icons.search),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(12),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
              SizedBox(width: 20),
              const SizedBox(width: 10),
              if (_startDate != null || _endDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                    _filterBookings();
                  },
                ),
              const SizedBox(height: 12),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredBookings.isEmpty
                    ? const Center(child: SubtitleTextWidget(label: 'Tidak ditemukan booking'))
                    : ListView.builder(
                  itemCount: paginatedBookings.length,
                  itemBuilder: (context, index) =>
                      _buildBookingCard(paginatedBookings[index]),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 0
                        ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                        : null,
                    child: const SubtitleTextWidget(label: "Sebelumnya"),
                  ),
                  ElevatedButton(
                    onPressed: (currentPage + 1) * itemsPerPage < filteredBookings.length
                        ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const SubtitleTextWidget(label: "Selanjutnya"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
