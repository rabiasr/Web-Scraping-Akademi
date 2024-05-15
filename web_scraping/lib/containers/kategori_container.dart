import 'package:flutter/material.dart';

class KategoriContainer extends StatelessWidget {
  const KategoriContainer({
    Key? key,
    required this.kelime,
    required this.onPressed,
  }) : super(key: key);

  final String kelime;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 200,  
        height: 100,  
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
             
                Center(
                  child: Text(
                    kelime.replaceAll("+", " "),
                    style: TextStyle(
                      fontSize: 30,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = const Color.fromARGB(255, 83, 25, 120),
                    ),
                  ),
                ),
              
                Center(
                  child: Text(
                    kelime.replaceAll("+", " "),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 