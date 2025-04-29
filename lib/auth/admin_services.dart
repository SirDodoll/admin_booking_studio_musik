import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await supabase
        .from('users')
        .select('name, email, foto, telepon, role')
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> signInAsAdmin(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception("Login gagal: user tidak ditemukan.");

    final userData = await getUserData();

    if (userData == null || userData['role'] != 'admin') {
      await signOut();
      throw Exception("Akses ditolak: kamu bukan admin.");
    }
  }


  // Sign Out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception("Error saat logout: $e");
    }
  }
}



