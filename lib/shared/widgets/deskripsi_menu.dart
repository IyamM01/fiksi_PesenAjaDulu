import 'package:flutter/material.dart';

class MenuDescriptionPopup extends StatelessWidget {
  final String title;
  final String nameresto;
  final String description;
  final String? imageUrl;

  const MenuDescriptionPopup({
    super.key,
    required this.title,
    required this.nameresto,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 180,
                      child:
                          imageUrl!.startsWith('http')
                              ? Image.network(
                                imageUrl!,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage();
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              )
                              : Image.asset(
                                imageUrl!,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage();
                                },
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by $nameresto',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String nameresto,
    required String description,
    String? imageUrl,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => MenuDescriptionPopup(
            title: title,
            nameresto: nameresto,
            description: description,
            imageUrl: imageUrl,
          ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
      ),
    );
  }
}
