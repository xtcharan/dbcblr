import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Widget? fallback;

  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return fallback ??
                Container(
                  width: radius * 2,
                  height: radius * 2,
                  color: Colors.grey[400],
                  child: Icon(
                    Icons.person,
                    size: radius,
                    color: Colors.white,
                  ),
                );
          },
        ),
      ),
    );
  }
}