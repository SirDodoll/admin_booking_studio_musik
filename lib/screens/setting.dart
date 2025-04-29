import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:admin_booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<Setting> {
  final supabase = Supabase.instance.client;
  final TextEditingController igController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  File? _imageFile;
  String? _alatMusikUrl;

  TimeOfDay? jamBuka;
  TimeOfDay? jamTutup;
  int? settingId;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Future<String?> uploadImage() async {
  //   if (_imageFile == null) return null;
  //
  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   final path = '$fileName';
  //
  //   try {
  //     await supabase.storage.from('gambar').upload(path, _imageFile!,
  //         fileOptions: const FileOptions(upsert: true));
  //     return path;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload gagal: $e')),
  //     );
  //     return null;
  //   }
  // }

  Future<void> loadSetting() async {
    final response = await supabase.from('settings').select().limit(1).maybeSingle();
    if (!mounted) return;
    if (response != null) {
      setState(() {
        settingId = response['id'];
        igController.text = response['instagram'] ?? '';
        waController.text = response['whatsApp'] ?? '';
        lokasiController.text = response['lokasi'] ?? '';
        hargaController.text = response['harga']?.toString() ?? '';
        jamBuka = _parseTime(response['jamBuka']);
        jamTutup = _parseTime(response['jamTutup']);
        _alatMusikUrl = response['alat_musik'];
      });
    }
  }

  TimeOfDay _parseTime(String? time) {
    if (time == null) return const TimeOfDay(hour: 0, minute: 0);
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> saveSetting() async {
    if (settingId == null) return;

    String? imagePath;
    if (_imageFile != null) {
      // imagePath = await uploadImage();
      if (imagePath != null) {
        _alatMusikUrl = imagePath;
      }
    }

    await supabase.from('settings').update({
      'instagram': igController.text,
      'whatsApp': waController.text,
      'lokasi': lokasiController.text,
      'harga': int.tryParse(hargaController.text) ?? 0,
      'jamBuka':
      "${jamBuka!.hour.toString().padLeft(2, '0')}:${jamBuka!.minute.toString().padLeft(2, '0')}",
      'jamTutup':
      "${jamTutup!.hour.toString().padLeft(2, '0')}:${jamTutup!.minute.toString().padLeft(2, '0')}",
      'alat_musik': _alatMusikUrl,
    }).eq('id', settingId!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: SubtitleTextWidget(label: "Berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> DashboardScreen()), (route)=> false);
            },
          ),
          title: SubtitleTextWidget(label: "Setting", color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("Edit URL"),
            TextField(
              controller: igController,
              decoration: const InputDecoration(
                label: SubtitleTextWidget(label: "Instagram"),
                prefixIcon: Icon(FontAwesomeIcons.instagram),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: waController,
              decoration: const InputDecoration(
                label: SubtitleTextWidget(label: "WhatsApp"),
                prefixIcon: Icon(FontAwesomeIcons.whatsapp),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lokasiController,
              decoration: const InputDecoration(
                label: SubtitleTextWidget(label: "Lokasi"),
                prefixIcon: Icon(Icons.location_on_outlined, size: 28,),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            sectionTitle("Edit Harga"),
            TextField(
              controller: hargaController,
              decoration: const InputDecoration(
                label: SubtitleTextWidget(label: "Harga"),
                prefixIcon: Icon(FontAwesomeIcons.moneyBillWave, color: Colors.green,),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            sectionTitle("Jam Operasional"),
            _timePickerRow("Jam Buka", jamBuka, (picked) => setState(() => jamBuka = picked)),
            _timePickerRow("Jam Tutup", jamTutup, (picked) => setState(() => jamTutup = picked)),
            // const Divider(),
            // sectionTitle("Foto Alat Musik"),
            // const SizedBox(height: 8),
            // Center(
            //   child: _imageFile != null
            //       ? ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
            //   )
            //       : _alatMusikUrl != null && _alatMusikUrl!.isNotEmpty
            //       ? ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.network(
            //       supabase.storage.from('gambar').getPublicUrl(_alatMusikUrl!),
            //       height: 150,
            //       fit: BoxFit.cover,
            //       errorBuilder: (_, __, ___) => SubtitleTextWidget(label: "Gagal memuat gambar"),
            //     ),
            //   )
            //       :  SubtitleTextWidget(label: "Belum ada gambar"),
            // ),
            // const SizedBox(height: 8),
            // Center(
            //   child: TextButton.icon(
            //     onPressed: pickImage,
            //     icon: const Icon(Icons.image),
            //     label: const Text("Pilih Gambar"),
            //   ),
            // ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveSetting,
                  icon: const Icon(Icons.save),
                  label: SubtitleTextWidget(label: "Simpan Pengaturan"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),

    );
  }

  Widget _timePickerRow(String label, TimeOfDay? time, Function(TimeOfDay) onPicked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SubtitleTextWidget(label: "$label: ${time?.format(context) ?? '-'}", fontSize: 16,),
        TextButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time ?? TimeOfDay.now(),
            );
            if (picked != null) {
              if(!mounted) return;
              final rounded = TimeOfDay(hour: picked.hour, minute: 0);
              onPicked(rounded);
            }
          },
          child: Icon( FontAwesomeIcons.clock, size: 22,),
        ),

      ],
    );
  }

  @override
  void dispose() {
    igController.dispose();
    waController.dispose();
    lokasiController.dispose();
    hargaController.dispose();
    super.dispose();
  }
}

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: SubtitleTextWidget(
      label: title,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  );
}

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
