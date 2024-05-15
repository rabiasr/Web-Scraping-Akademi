import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

class Makale {
  final int yid;
  final String yad;
  final List<String> yazarlar;
  final String yayinturu;
  late final String yayintarihi;
  final String ydergi;
  final String aranankelime;
  final List<String> ykeywordler;
  final List<String> yozet; 
  final List<String> yreferanslar;
  final String ydoi;
  final String ylink;
  final int yalintisayisi;
  

  Makale({
    required this.yid,
    required this.yad,
    required this.yazarlar,
    required this.yayinturu,
    required this.yayintarihi,
    required this.ydergi,
    required this.aranankelime,
    required this.ykeywordler,
    required this.yozet,
    required this.yreferanslar,
    required this.ydoi,
    required this.ylink,
    required this.yalintisayisi
  });
  
Map<String, dynamic> toJson() {
  return {
    'id': yid ?? 0,
    'ad': yad ?? '',
    'yazarlar': List<String>.from(yazarlar ?? []),
    'yayinturu': yayinturu ?? '',
    'yayintarihi': yayintarihi ?? '',
    'dergi': ydergi ?? '',
    'aranankelime': aranankelime ?? '',
    'keywordler': List<String>.from(ykeywordler ?? []),
    'ozet': List<String>.from(yozet ?? []),
    'referanslar': List<String>.from(yreferanslar ?? []),
    'doi': ydoi ?? '',
    'link': ylink ?? '',
    'alintisayisi':yalintisayisi ?? 0,
  };
}

factory Makale.fromJson(Map<String, dynamic> json) {
    return Makale(
      yid: json['id'],
      yad: json['ad'],
      yazarlar: List<String>.from(json['yazarlar']),
      yayinturu: json['yayinturu'],
      yayintarihi: json['yayintarihi'],
      ydergi: json['dergi'],
      aranankelime: json['aranankelime'],
      ykeywordler: List<String>.from(json['keywordler']),
      yozet: List<String>.from(json['ozet']),
      yreferanslar: List<String>.from(json['referanslar']),
      ydoi: json['doi'],
      ylink: json['link'],
      yalintisayisi: json['alintisayisi'],
    );
  }



}