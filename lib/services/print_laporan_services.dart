import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

Future<void> printLaporan({
  required DateTime startDate,
  required DateTime endDate,
  required List<Map<String, dynamic>> bookings,
}) async {
  final pdfDoc = pw.Document();
  final formatter = DateFormat('dd MMM yyyy');

  final jumlahBooking = bookings.length;
  final totalPendapatan = bookings.fold(0.0, (sum, booking) {
    final bayar = double.tryParse(booking['total_harga'].toString()) ?? 0;
    return sum + bayar;
  });

  pdfDoc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Laporan Booking', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Periode: ${formatter.format(startDate)} - ${formatter.format(endDate)}'),
        pw.SizedBox(height: 10),
        pw.Text('Total Booking: $jumlahBooking'),
        pw.Text('Total Pendapatan: Rp ${totalPendapatan.toStringAsFixed(0)}'),
        pw.SizedBox(height: 20),
        pw.Text('Detail Booking:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        ...bookings.map((b) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Nama: ${b['users']['name'] ?? 'Tanpa Nama'}'),
              pw.Text('Tanggal: ${b['tanggal_booking']} | Jam: ${b['waktu']}'),
              pw.Text('Pembayaran: ${b['metode']}'),
              pw.Text('Total: Rp ${b['total_harga']}'),
              pw.Divider(),
            ],
          );
        }).toList(),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) => pdfDoc.save());
}
