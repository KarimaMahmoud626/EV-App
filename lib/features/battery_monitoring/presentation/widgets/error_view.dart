import 'package:ev_app/features/battery_monitoring/presentation/view_model/cubit/battery_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.context});

  final String message;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: colors.error),
          const SizedBox(height: 24),
          Text(
            'Error',
            style: TextStyle(
              color: colors.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<BatteryCubit>().startMonitoring();
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
