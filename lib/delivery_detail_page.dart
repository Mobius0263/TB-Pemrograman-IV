import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'package:logitrack_app/geolocator.dart';

class DeliveryDetailPage extends StatefulWidget {
  final DeliveryTask task;

  const DeliveryDetailPage({super.key, required this.task});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  XFile? _imageFile;
  Position? _currentPosition; // State to store position
  final LocationService _locationService = LocationService(); // State untuk menyimpan file gambar

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Handle error, misal pengguna menolak izin
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengakses kamera.')),
      );
    }
  }

  Future<void> getCurrentLocationAndCompleteDelivery() async {
  try {
    final position = await _locationService.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    // Show success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pengiriman Selesai di Lat: ${position.latitude}, Lon: ${position.longitude}')),
    );
  } catch (e) {
    // Show error notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail: ${widget.task.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Status: ${widget.task.isCompleted ? "Selesai" : "Dalam Proses"}'),
            const SizedBox(height: 24),
            const Text('Bukti Pengiriman:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Area untuk menampilkan gambar atau placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageFile == null
                  ? const Center(child: Text('Belum ada gambar'))
                  : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto Bukti'),
                onPressed: pickImageFromCamera,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Widget to display location data
            if (_currentPosition != null)
              Text(
                'Lokasi Terekam:\nLat: ${_currentPosition!.latitude}\nLon: ${_currentPosition!.longitude}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),

            if (_currentPosition == null)
              const Text(
                'Lokasi belum direkam.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),

            const SizedBox(height: 16),

            // Button to complete delivery
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text('Selesaikan Pengiriman & Rekam Lokasi'),
                onPressed: getCurrentLocationAndCompleteDelivery,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}