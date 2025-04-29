import 'package:flutter/material.dart';
import 'package:admin_booking_application/services/assets_manager.dart';
import 'package:admin_booking_application/screens/bookingAdmin.dart';
import 'package:admin_booking_application/screens/laporan.dart';
import 'package:admin_booking_application/screens/setting.dart';

class DashboardModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardModel> dashboardBtnList(BuildContext context) => [
    DashboardModel(
      text: "Booking",
      imagePath: AssetsManager.booking,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminBookingScreen()));
      },
    ),
    DashboardModel(
      text: "laporan",
      imagePath: AssetsManager.laporan,
      onPressed: () {
        Navigator.push(context, 
            MaterialPageRoute(builder: (_) => Laporan(),
        )
        );
      },
    ),
    DashboardModel(
      text: "Setting",
      imagePath: AssetsManager.setting,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => Setting()
            )
        );
      },
    ),
  ];
}
