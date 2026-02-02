import 'package:flutter/material.dart';
import 'package:logitrack_app/api_service.dart';
import 'package:logitrack_app/delivery_task_model.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:logitrack_app/delivery_detail_page.dart';
import 'package:logitrack_app/qr_scanner_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}
  class DashboardPageState extends State<DashboardPage> {
    void _navigateToScanner() async {
  // Wait for result from QRScannerPage
  final result = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (context) => const QRScannerPage()),
  );

  if (result != null && mounted) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      // Show scan result in SnackBar
      ..showSnackBar(SnackBar(content: Text("Kode terdeteksi: $result")));
      
    // Logic to search and open task detail (optional but recommended)
    // You need access to 'tasks' list from FutureBuilder
    // This is advanced implementation requiring state management
    // For now, we only display the result.
  }
  }
  // 1. Buat instance ApiService
  final ApiService apiService = ApiService();

  // 2. Buat variabel untuk menampung hasil dari future
  late Future<List<DeliveryTask>> tasksFuture;

  @override
  void initState() {
    super.initState();
    // 3. Panggil API dan simpan future-nya ke variabel
    tasksFuture = apiService.fetchDeliveryTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // Assumed based on context
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // Call function to open scanner
              _navigateToScanner();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DeliveryTask>>( 
        future: tasksFuture, // Gunakan future dari state
        builder: (context, snapshot) {
          // Kondisi 1: Saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Kondisi 2: Jika terjadi error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Kondisi 3: Jika data berhasil dimuat dan tidak kosong
          else if (snapshot.hasData) { 
            final tasks = snapshot.data!; 
            // Panggil ListView.builder di sini
            return ListView.builder(
              itemCount: tasks.length, 
              itemBuilder: (context, index) { 
                final task = tasks[index]; 
                return Card( 
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), 
                  child: ListTile( 
                    leading: Icon( 
                      task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, 
                      color: task.isCompleted ? Colors.green : Colors.grey, 
                    ),
                    title: Text(task.title), 
                    subtitle: Text('ID Tugas: ${task.id}'), 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryDetailPage(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          // Kondisi 4: Jika data kosong atau state lainnya
          else { 
            return const Center(child: Text('Tidak ada data pengiriman.')); 
          }
        },
      ),
    );
  }
}