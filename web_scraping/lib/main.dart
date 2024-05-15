import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_scraping/containers/liste_baslik.dart';
import 'package:web_scraping/sayfalar/makale_detay.dart';
import 'package:web_scraping/sayfalar/web.dart';
import 'containers/kategori_container.dart';


Future<void> main() async {
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Scraping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Web(),
    );
    
  }
}
