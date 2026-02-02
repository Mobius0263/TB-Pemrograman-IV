import 'dart:convert'; // Diperlukan untuk jsonDecode
import 'package:http/http.dart' as http;
import 'package:logitrack_app/delivery_task_model.dart'; 

class ApiService {
  // URL endpoint dari API
  final String apiUrl = "https://jsonplaceholder.typicode.com/todos";
  
  // Fungsi untuk mengambil data
  Future<List<DeliveryTask>> fetchDeliveryTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      // Cek jika request berhasil (status code 200)
      if (response.statusCode == 200) {
        // Decode JSON response menjadi List<dynamic>
        List<dynamic> jsonList = jsonDecode(response.body);

        // Map setiap item di list mejadi objek DeliveryTask
        List<DeliveryTask> tasks = jsonList.map((dynamic item) => DeliveryTask.fromJson(item)).toList();

        return tasks;
      } else {
        throw Exception('Gagal memuat data dari API');
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
  }
}