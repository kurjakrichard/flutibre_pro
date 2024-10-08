import 'package:flutter/material.dart';
import 'package:flutter_wizard/flutter_wizard.dart';

class FinishedButton extends StatelessWidget {
  const FinishedButton({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<bool>(
      stream: context.wizardController.getIsGoNextEnabledStream(),
      initialData: context.wizardController.getIsGoNextEnabled(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        }
        final enabled = snapshot.data!;
        return ElevatedButton(
          onPressed: enabled
              ? () {
                  _onPressed(context);
                }
              : null,
          child: const Text("Finish"),
        );
      },
    );
  }

  void _onPressed(context) {
    debugPrint("### Finished!");
    Navigator.pop(context);
    Navigator.pushNamed(context, '/homescreen');
  }
}
