import 'dart:convert';
import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_scraping/containers/kategori_container.dart';
import 'package:web_scraping/containers/liste_baslik.dart';
import 'package:web_scraping/sayfalar/makale_detay.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
//import 'package:web_scraping/dbHelper/mongodb.dart';
import 'package:web_scraping/models/makale.dart';
//import 'package:html/dom.dart' as dom;

void main() async {
  runApp(Web());
}

class Web extends StatefulWidget {
  String aranankelime = "";
  static String kategori = "";
  static int yid = 0;
  static bool flag = false;
  static String aranan = "";
  static int index = 0;
  static List<Makale> makaleler = [];
  late IO.Socket socket;
  static bool kontrolflag = false;
  static String dogrusu = "";
  static late List basliklar = [];
  static bool listeflag = false;
  static List<Widget> listeWidgetler = [];
  static late List koleksiyonlar = [];
  static bool tabanflag = false;
  static bool aramaflag = false;
  static bool docflag = false;
  static String Dogru="";
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> with AutomaticKeepAliveClientMixin {
  late IO.Socket socket;
  static List<Makale> makaleListesi = [];
  static List<Makale> makaleListesik = [];
  
  late TextEditingController
      _searchController; // TextField controller'ını tanımlayın

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(); // TextEditingController'ı başlatın

    connect();
  }

  @override
  void dispose() {
    _searchController.dispose(); // TextEditingController'ı temizleyin
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // Sekmenin içeriğini korumak için

  List<Makale> fromJsonList(List<dynamic> jsonList) {
    List<Makale> makaleler = [];
    for (var item in jsonList) {
      print("giriyor");
      item.remove('_id');
      makaleler.add(Makale.fromJson(item));
    }
    return makaleler;
  }

  void connect() {
    socket = IO.io("http://localhost:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("/test", "Hello world");
    socket.onConnect((data) => print("Connected"));
    print(socket.connected);
  }

  makaleGonder(Makale makale) {
    socket.emit("ekle", makale.toJson());
  }

  void atifsirala(List<Makale> liste) {
    setState(() {
      liste.sort((a, b) =>
         (b.yalintisayisi).compareTo(a.yalintisayisi));
    });
   /* makaleListesik.forEach((makale) {
      print(
          "Makale başlık: ${makale.yad}, Yayın tarihi: ${makale.yayintarihi}");
    });*/
  }

  void tarihsirala(List<Makale> liste) {
    // Makaleleri tarihlerine göre sırala
    setState(() {
      liste.sort((a, b) =>
          _parseDate(b.yayintarihi).compareTo(_parseDate(a.yayintarihi)));
    });
    /*makaleListesik.forEach((makale) {
      print(
          "Makale başlık: ${makale.yad}, Yayın tarihi: ${makale.yayintarihi}");
    });*/
  }

  DateTime _parseDate(String dateString) {
    // Tarih stringini parçalara bölebiliriz
    if (dateString.contains('.')) {
      final parts = dateString.split('.');

      // Parçaları integer'a dönüştürerek DateTime nesnesi oluştur
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } else {
      return DateTime(0000, 0, 0);
    }
  }

  dokumancek(String aranan) {
    // connect();

    /*setState(() {
      Web.docflag = true;
    });*/
    socket.emit("dokumancek", aranan);
    socket.on("dokumanlar", (data) {
      setState(() {
        makaleListesi = fromJsonList(data);
        makaleListesi.sort((a, b) => a.yid.compareTo(b.yid));

        //Web.listeflag=true;
        /* for (var makale in makaleListesi) {
          print('Makale Adı: ${makale.yad}');
          print('Yazarlar: ${makale.yazarlar}');
          // Diğer alanlar için de benzer şekilde erişebilirsiniz.
        }*/
      });
      // Gelen koleksiyon isimlerini al
    });
  }

  dokumancekk(String aranan) {
    // connect();

    setState(() {
      Web.docflag = true;
    });
    socket.emit("dokumancekk", aranan);
    socket.on("dokumanlarr", (data) {
      setState(() {
        makaleListesik = fromJsonList(data);
        makaleListesik.sort((a, b) => a.yid.compareTo(b.yid));

        //Web.listeflag=true;
        /* for (var makale in makaleListesi) {
          print('Makale Adı: ${makale.yad}');
          print('Yazarlar: ${makale.yazarlar}');
          // Diğer alanlar için de benzer şekilde erişebilirsiniz.
        }*/
      });
      // Gelen koleksiyon isimlerini al
    });
  }

  kategoricek() {
    setState(() {
      Web.tabanflag = true;
      Web.docflag = false;
    });
    socket.emit("kategoricek");
    socket.on("koleksiyonlar", (data) {
      setState(() {
        Web.koleksiyonlar = data;
        print("KONTROL  ${data.toString()} ");

        //   makaleListesi.clear();
      });
      // Gelen koleksiyon isimlerini al
    });
  }

  void aramaYap(String kelime) {
    List<String> kelimeleri = kelime.split(" ");

    for (int i = 0; i < kelimeleri.length; i++) {
      if (i != kelimeleri.length - 1) {
        kelimeleri[i] = kelimeleri[i] + "+";
      }
    }

    widget.aranankelime = kelimeleri.join('');
    //connect();
    kontrol(widget.aranankelime);
    setState(() {
      Web.yid = 0;
      Web.flag = false;
      Web.makaleler.clear();
      Web.listeflag = false;
      makaleListesi.clear();

      //Web.tabanflag = false;
    });
  }

  Future<void> kontrol(String aranankelime) async {
    final response = await http.get(Uri.parse(
        'https://scholar.google.com/scholar?hl=tr&as_sdt=0%2C5&q=${aranankelime}&btnG=&oq=de'));

    await Future.delayed(const Duration(seconds: 1));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      var dolumu = document.getElementById('gs_res_ccl_top');

      if (dolumu != null && dolumu.children.isNotEmpty) {
        print("{$aranankelime} kelime yanlış yazılmış");
        var element = document.querySelector('div.gs_r > h2.gs_rt > a');
        var href = element?.attributes['href'];

        if (href != null) {
          List<String> parts = href.split('5&q=');
          Web.dogrusu = parts.length > 1 ? parts[1] : '';
          print("Dogru kelime: ${Web.dogrusu}");
        }

        setState(() {
          Web.kontrolflag = true;
          fetchArticles(Web.dogrusu);
          Web.Dogru=Web.dogrusu;
        });
      } else {
        setState(() {
          Web.kontrolflag = false;
          Web.Dogru = aranankelime;
          fetchArticles(aranankelime);
        });
        // Element boş. Yani kelime doğru yazılmış :
        //print("Doğru yazılmış");
      }
    }
  }

  Future<void> fetchArticles(String aranankelime) async {
    String dergiIsmi = " ";
    String icerik;
    var articleUrl;
    Web.aranan = aranankelime;
    final response = await http.get(Uri.parse(
        'https://dergipark.org.tr/tr/search?q=${aranankelime}&section=articles'));

    await Future.delayed(const Duration(seconds: 1));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final elements = document.getElementsByClassName('card-title');

      for (var element in elements) {
        String icerik = element.innerHtml
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll('  ', '');

        //URL adresi
        var link = element.getElementsByTagName('a').first;
        articleUrl = link.attributes['href'];

        //Yayıncı adı
        RegExp exp = RegExp(
            r'<a class="fw-500" href="/tr/pub/.*?">(.*?)</a>\s*(?:</small>|\s*,|)\s*(?:Cilt\s*\d+|)(?:,\s*Sayı\s*\d+|)(?:,\s*\d{4},\s*\d+\s*-\s*\d+\s*|)');
        Match? dergi = exp.firstMatch(icerik);
        if (dergi != null) {
          dergiIsmi = dergi.group(1)?.trim() ?? " Dergi ismi bulunamadı";
          // print('Dergi İsmi: $dergiIsmi');
        } else {
          print("dergi ismi bulunamadı");
        }

        await scrapeArticle(articleUrl, dergiIsmi);
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> scrapeArticle(String url, String dergiIsmi) async {
    var response = await http.get(Uri.parse(url));
    final document;
    String _htmlVeri = '';
    String pdfhtml = '';
    String mbaslik = "";
    String myaz = "";
    String mbasyazar = "";
    var makaleyayintarihi;
    String makaleturu = "";
    var manahtarlar;
    String referans;
    String doi_number = "";
    var pdflink;
    int alintisayisii = 0;
    String alinti_sayisi = "";
    List<String> referanslar = [];
    List<String> yazarlar = [];
    List<String> anahtarlarr = [];
    List<String> ozetler = [];
    late Iterable<Match> eslesenlinkler;
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        _htmlVeri = response.body
            .replaceAll('\n', '')
            .replaceAll('\t', '')
            .replaceAll('  ', '');

        //Yayın adı
        final RegExp baslik = RegExp(
            r'<h3\s+class="article-title"\s+aria-label="Makale Başlığı:\s*([^"]+)"[^>]*>([^<]+)</h3>');
        final eslesenbaslik = baslik.firstMatch(_htmlVeri);
        mbaslik = eslesenbaslik!.group(2).toString();

        //Yazarların isimleri
        final yazarElements =
            document.getElementsByClassName("article-authors");
        for (var element in yazarElements) {
          var yazarAdi = element.text;
          yazarlar.add(yazarAdi.replaceAll(RegExp(r'\s+'), ' ').trim());
        }
        yazarlar = yazarlar.toSet().toList();
        //  print("Yazarlar: $yazarlar");

        //Yayın türü
        RegExp tur = RegExp(r'<span class="kt-font-bold">(.*?)<\/span>');
        Match? match = tur.firstMatch(_htmlVeri);
        if (match != null) {
          makaleturu = match!.group(1) ?? "Makale türü bulunamadı";
          // print("Makale türü: $makaleturu");
        } else {
          print("Makale türü bulunamadı");
        }

        //Yayımlanma tarihi
        final yayinTarihi = document.querySelector('span.article-subtitle');
        if (yayinTarihi != null) {
          String yayinTarihii = yayinTarihi.text!.trim();
          makaleyayintarihi = yayinTarihii.split(',').last.trim();
          //   print("Yayın tarihi: $makaleyayintarihi");
        } else {
          // print("Yayın tarihi bulunamadı.");
        }

        //Makaleye ait anahtar kelimeler
        final anahtarlar = document.querySelector('.article-keywords p');
        if (anahtarlar != null) {
          manahtarlar = anahtarlar.text.trim();
          anahtarlarr.add(manahtarlar.replaceAll(RegExp(r'\s+'), ' ').trim());
          anahtarlarr = anahtarlarr.toSet().toList();
          //print("anahtarlar: $anahtarlarr");
        } else {
          print("Anahtar kelimeler bulunamadı.");
        }

        //Özet
        final RegExp ozet = RegExp(
            r'<div class="article-abstract data-section">\s*<h3[^>]*>\s*Öz\s*<\/h3>\s*<p[^>]*>(.*?)<\/p>',
            dotAll: true);

        final eslesenOzetler = ozet.allMatches(_htmlVeri);
        for (final eslesenOzet in eslesenOzetler) {
          ozetler.add(eslesenOzet
              .group(1)!
              .replaceAll('<br />', '')
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .trim());
        }

        //Referanslar
        var kaynakca =
            document.querySelectorAll('.article-citations .fa-ul li');

        if (kaynakca.isNotEmpty) {
          kaynakca.forEach((element) {
            referanslar.add(element.text.trim());
          });
          //  print("referanslar: ${referanslar} \n ****************************\n ");
        } else {
          //print("Kaynakça bulunamadı.");
        }

        //Doi Numarası
        final doiLink = document.querySelector('.doi-link');

        if (doiLink != null) {
          String doiNumber = doiLink.text;
          doi_number = doiNumber.split("/")[3] + "/" + doiNumber.split("/")[4];
          //   print("DOI Numarası: $doi_number");
        } else {
          // print("DOI numarası bulunamadı.");
        }

        //pdf indirme linki
        var elementlink = document.getElementById("article-toolbar");
        if (elementlink != null) {
          var link = elementlink.getElementsByTagName('a').first;
          pdflink = link.attributes['href'];
          pdflink = "https://dergipark.org.tr${pdflink}";
          // print("URL : $pdflink");
        }

        //alıntı sayısı
        final alintisayisi =
            document.querySelector('a[href*="cited_by_articles"]');
        if (alintisayisi != null) {
          alinti_sayisi = alintisayisi.text.trim();
          List<String> parts = alinti_sayisi.split(":");
          alintisayisii = int.parse(parts[1].trim());
        } else {
          // print("alıntı sayısı bulunamadı.");
        }
        int id = Web.yid++;

        Makale makale = Makale(
          yid: id,
          yad: mbaslik,
          yazarlar: yazarlar,
          yayinturu: makaleturu,
          yayintarihi: makaleyayintarihi,
          ydergi: dergiIsmi,
          aranankelime: Web.aranan,
          ykeywordler: anahtarlarr,
          yozet: ozetler,
          yreferanslar: referanslar,
          ydoi: doi_number,
          ylink: pdflink,
          yalintisayisi: alintisayisii,
        );

        Web.makaleler.add(makale);

        // makaleGonder(makale);

        if (Web.makaleler.length == 24 && Web.flag == false) {
          for (int i = 0; i < Web.makaleler.length; i++) {
            makaleGonder(Web.makaleler[i]);
          }

          setState(() {
            dokumancek(Web.dogrusu);
            Web.aramaflag = true;
            // Web.listeflag = true;
          });

          /* 
         if (Web.listeflag) {
                print("sonraaaa: ${Web.listeflag}");
    for(int i=0; i < makaleListesi.length; i++) {
      print("***********************\n ${makaleListesi[i].yid}");
         }
         }*/
        }

// registerUser("rabia", "123456");

        /*  print(
            "Yayın id: ${makale.yid}\n Yayın adı: ${makale.yad}\n Yazarlar: ${makale.yazarlar}\n Yayın türü: ${makale.yayinturu} \n Yayımlanma tarihi: ${makale.yayintarihi}\n Yayınlandığı dergi: ${makale.ydergi} \n Anahtar Kelimeler: ${makale.ykeywordler}\nÖzet: ${makale.yozet} \n Referanslar: ${makale.yreferanslar} \n Doi Numarası:${makale.ydoi}\nURL adresi: ${makale.ylink} \n***********************************************************\n");
    */
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Hata durumunda _htmlVeri'yi temizle
      /* setState(() {
        _htmlVeri = '';
      });*/
    }
  }

  List<String> articles = [];
  List<Makale> makales = [];
  int index = 0;
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin'i etkinleştir

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 83, 25, 120),
          title: const Text(
            "Web Scraping Akademi",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.category_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  kategoricek();
                },
              ),
            ),
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            },
          ),
          centerTitle: false,
          bottom: const TabBar(
            labelColor: Color.fromARGB(
                255, 255, 255, 255), // Aktif sekmenin metin rengi
            unselectedLabelColor: Color.fromARGB(255, 255, 255, 255), // A
            tabs: [
              Tab(text: 'Arama Sonuçları'), // İlk sekme başlığı
              Tab(text: 'Kategoriler'), // İkinci sekme başlığı
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      controller:
                          _searchController, // TextField controller'ını atayın

                      onSubmitted: (text) {
                        setState(() {
                          searchText = text;
                        });
                        aramaYap(searchText);
                      },
                      decoration: const InputDecoration(
                        labelText: "Search Anything...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFFD1D5DB),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Web.kontrolflag
                            ? Text(
                                " Yazımı düzeltilmiş şu sorgu için sonuçları görüyorsunuz --> ${Web.Dogru.replaceAll("+", " ")} ",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )
                            : const Text(""),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (Web.aramaflag == true)
                        Card(
                           elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        tarihsirala(makaleListesi);
                                      },
                                      child:const Text('Tarihe Göre Sırala'),
                                    ),
                                    const SizedBox(
                                        width: 10), // Butonlar arasındaki boşluk
                                    ElevatedButton(
                                      onPressed: () {
                                        atifsirala(makaleListesi);
                                      },
                                      child:const Text('Atıf Sayısına Göre Sırala'),
                                    ),
                                  ],
                                ),
                            const SizedBox(height:10),
                              for (int i = 0; i < makaleListesi.length; i++)
                                ListeBaslik(
                                  id: makaleListesi[i].yid,
                                  baslik: makaleListesi[i].yad,
                                  alinti: makaleListesi[i].yalintisayisi,
                                  tarih: makaleListesi[i].yayintarihi,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MakaleDetay(
                                            makale: makaleListesi[i],
                                          ), // Hedef sayfaya yönlendirme
                                        ));
                                  },
                                )
                            ]),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  if (Web.tabanflag == true && Web.docflag == false)
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: Web.koleksiyonlar.length,
                      itemBuilder: (BuildContext context, int index) {
                        String kelime = Web.koleksiyonlar[index]['name'];
                        return KategoriContainer(
                          kelime: kelime,
                          onPressed: () {
                            dokumancekk(kelime);
                            Web.kategori = kelime;
                          },
                        );
                      },
                    )
                  else if (Web.tabanflag == true && Web.docflag == true)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    tarihsirala(makaleListesik);
                                  },
                                  child: const Text('Tarihe Göre Sırala'),
                                ),
                                const SizedBox(
                                    width: 10), // Butonlar arasındaki boşluk
                                ElevatedButton(
                                  onPressed: () {
                                    atifsirala(makaleListesik);
                                  },
                                  child: const Text('Atıf Sayısına Göre Sırala'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            for (int i = 0; i < makaleListesik.length; i++)
                              ListeBaslik(
                                id: makaleListesik[i].yid,
                                baslik: makaleListesik[i].yad,
                                tarih: makaleListesik[i].yayintarihi,
                                alinti:  makaleListesik[i].yalintisayisi,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MakaleDetay(
                                        makale: makaleListesik[i],
                                      ), // Hedef sayfaya yönlendirme
                                    ),
                                  );
                                },
                              ),
                            // Butonlar arasındaki boşluk
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 50),
              ListTile(
                leading: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.insert_drive_file_outlined)),
                title: Text("Tüm Veritabanını Tarihe Göre Sırala"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}