import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final Widget destination;
  final String description;

  const SelectionCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.destination,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
