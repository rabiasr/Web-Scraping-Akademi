import 'package:flutter/material.dart';

class ListeBaslik extends StatelessWidget {
  const ListeBaslik({
    Key? key,
    required this.id,
    required this.baslik,
    required this.tarih,
    required this.alinti,
    required this.onPressed,
  }) : super(key: key);

  final String baslik;
  final String tarih;
  final int alinti;
  final int id;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: double.infinity,  
          height: 180,  
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          baslik,
                          maxLines: 2,  
                          overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Yayın Tarihi: $tarih',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Alıntı Sayısı: $alinti',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
