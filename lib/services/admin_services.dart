import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AdminBookingService {
  static Future<Map<String, dynamic>> fetchBookings() async {
    final now = DateTime.now().toIso8601String();

    final data = await supabase
        .from('bookings')
        .select('*, users(*)')
        .gte('tanggal_booking', now)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return {
      'data': List<Map<String, dynamic>>.from(data),
    };
  }


  static Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final response = await supabase
        .from('bookings')
        .update({'status': newStatus})
        .eq('id', bookingId)
        .select();

    if (response == null || response.isEmpty) {
      throw Exception("Gagal mengubah status booking.");
    }
  }
}
