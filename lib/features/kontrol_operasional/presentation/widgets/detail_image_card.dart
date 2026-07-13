import 'package:flutter/material.dart';

class DetailImageCard extends StatelessWidget {
  final String? imageUrl; // Jika null, otomatis tampilkan placeholder abu-abu
  final double size;

  const DetailImageCard({
    super.key,
    this.imageUrl,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    // Fungsi internal untuk placeholder
    Widget buildPlaceholder() => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              Icon(Icons.image, color: Colors.grey.shade400, size: size * 0.4),
        );

    // Jika url kosong/null, langsung return placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return buildPlaceholder();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => buildPlaceholder(),
        ),
      ),
    );
  }
}
