import 'package:admin_booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  final String title, imagePath;
  final Function onPressed;
  const DashboardWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 65,
            width: 65,
          ),
          const SizedBox(
            height: 15,
          ),
          SubtitleTextWidget(label: title, fontSize: 18,),

        ],
      ),
    );
  }
}
