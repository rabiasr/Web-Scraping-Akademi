import 'package:flutter/material.dart';
import 'package:web_scraping/models/makale.dart';

class MakaleDetay extends StatelessWidget {
  final Makale makale;

  const MakaleDetay({Key? key, required this.makale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 25, 120),
        title: const Text(
          "Web Scraping Akademi",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return const  Icon(
                Icons.my_library_books,
                color: Colors.white,
                            
            );
          },
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
             padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

    
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBaslik("MAKALE TÜRÜ"),
              _buildMetin("Makale Türü: ${makale.yayinturu}"),
              _buildBaslik("MAKALE BAŞLIĞI"),
              _buildMetin("Makale Başlığı: ${makale.yad}"),
              _buildBaslik("YAYIN TARİHİ"),
              _buildMetin("Yayın Tarihi: ${makale.yayintarihi}"),
              _buildBaslik("YAZARLAR"),
              _buildMetin("Yazarlar: ${makale.yazarlar.join(", ")}"),
              _buildBaslik("ANAHTAR KELİMELER (Arama Motoru)"),
              _buildMetin("Anahtar Kelimeler (Arama Motoru): ${makale.aranankelime}"),
              _buildBaslik("ANAHTAR KELİMELER (Makaleye Ait)"),
              _buildMetin("Anahtar Kelimeler (Makaleye Ait): ${makale.ykeywordler.join(", ")}"),
              _buildBaslik("ÖZET"),
              _buildMetin("Özet: ${makale.yozet}"),
              _buildBaslik("REFERANSLAR"),
              _buildMetin("Referanslar: ${makale.yreferanslar.join(", ")}"),
              _buildBaslik("ALINTI SAYISI"),
              _buildMetin("Alıntı Sayısı: ${makale.yalintisayisi}"),
              _buildBaslik("DOI NUMARASI"),
              _buildMetin("DOI Numarası: ${makale.ydoi}"),
              _buildBaslik("URL"),
              _buildMetin("URL: ${makale.ylink}"),
            ],
          ),
        ),
      ),
    ));
  }

 Widget _buildBaslik(String baslik) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Container(
      color: const Color.fromARGB(255, 136, 120, 140),
      padding: const EdgeInsets.all(16),
      child: Text(
        baslik,
        style: const TextStyle(
          color: Color.fromARGB(255, 252, 253, 254),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,  
          height: 0.11,
          letterSpacing: 0.07,
        ),
      ),
    ),
  );
}


Widget _buildMetin(String metin) {
  final sabitKisim = metin.split(":")[0];  
  final geriKalan = metin.substring(sabitKisim.length);  

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: sabitKisim,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: geriKalan,
          ),
        ],
      ),
    ),
  );
}


}

