import 'package:ev_app/features/history/presentation/view_model/cubit/history_cubit.dart';
import 'package:ev_app/features/history/presentation/widgets/history_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main history screen that displays battery usage graph and charging history.
///
/// Features:
/// - Battery usage visualization over time
/// - List of charging sessions with details
/// - Time range filtering (daily, weekly, monthly)
/// - Pull-to-refresh functionality
/// - Loading and error states
class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..loadHistory(),
      child: const HistoryViewBody(),
    );
  }
}
