import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class StatsCustomCard extends StatelessWidget {
  const StatsCustomCard({
    super.key,
    required this.icon,
    required this.cardTitle,
    required this.statsValue,
  });
  final IconData icon;
  final String cardTitle;
  final String statsValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 3,
        color: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colors.secondary),
              VerticalSpace(2),
              Text(
                cardTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              VerticalSpace(0.5),
              Text(
                statsValue,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
