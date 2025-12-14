import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String previewUrl;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.previewUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(previewUrl);

        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication, // mở Chrome ngoài app
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không thể mở liên kết 🙁")),
          );
        }
      },

      child: Container(
        width: 120,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl ?? "",
              height: 150,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/default_book.png",
                  height: 150,
                  width: 120,
                  fit: BoxFit.cover,
                );
              },
            ),

            const SizedBox(height: 6),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
