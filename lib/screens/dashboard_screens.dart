import 'package:admin_booking_application/providers/theme_providers.dart';
import 'package:admin_booking_application/widget/dashboard_widget.dart';
import 'package:admin_booking_application/models/dashboard_model.dart';
import 'package:admin_booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:TitlesTextWidget(label: "Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
                  themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(
              themeProvider.getIsDarkTheme
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          )
        ],
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
