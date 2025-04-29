import 'package:admin_booking_application/auth/admin_services.dart';
import 'package:admin_booking_application/screens/login.dart';
import 'package:admin_booking_application/widget/dashboard_widget.dart';
import 'package:admin_booking_application/models/dashboard_model.dart';
import 'package:admin_booking_application/widget/subtitle_text.dart';
import 'package:admin_booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const routName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitlesTextWidget(label: "Admin Dashboard", color: secondaryColor,),
            IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const SubtitleTextWidget(label: "yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const SubtitleTextWidget(label: "Batal"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const SubtitleTextWidget(label: "Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm != true) return;
                try {
                  await AuthService().signOut();
                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginAdminScreen()),
                        (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal logout: $e')),
                  );
                }
              },
              icon: Icon(Icons.logout, color: secondaryColor, size: 30,),
            ),
          ],

        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(3, (index)=>Padding(
            padding: const EdgeInsets.all(8),
          child: DashboardWidget(
              title: DashboardModel.dashboardBtnList(context)[index].text,
              imagePath: DashboardModel.dashboardBtnList(context)[index].imagePath,
              onPressed: DashboardModel.dashboardBtnList(context)[index].onPressed,
          ),
        ),
        ),
      ),
    );
  }
}
