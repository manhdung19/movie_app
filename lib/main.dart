import 'package:flutter/material.dart';
import 'injection_container.dart' as di; // Import file DI vừa tạo

void main() async {
  // Bắt buộc phải có dòng này khi khởi tạo các Future trước runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Service Locator (Bắt đầu đăng ký tất cả các lớp)
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      home: Scaffold(
        appBar: AppBar(title: const Text('Movie Explorer')),
        body: const Center(child: Text('Setup DI Thành công!')),
      ),
    );
  }
}