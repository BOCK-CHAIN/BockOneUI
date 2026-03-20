import 'package:flutter/material.dart';

class HomeScreenGridItem extends StatelessWidget {
  const HomeScreenGridItem({
    super.key,
    required this.image,
    required this.title,
    this.labelColor = Colors.purple,
    required this.onSelectApp,
  });

  final void Function() onSelectApp;
  final String image;
  final String title;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectApp,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: labelColor.withAlpha(120), width: 1.6),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  image,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
