import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class LoadingBody extends StatelessWidget {
  const LoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.primary),
          VerticalSpace(2),
          Text(
            'Finding charging stations...',
            style: TextStyle(color: colors.onBackground),
          ),
        ],
      ),
    );
  }
}
