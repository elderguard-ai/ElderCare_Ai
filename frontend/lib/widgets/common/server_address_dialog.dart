import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/api_config.dart';
import '../../services/auth_session.dart';
import '../../state/mock_app_state.dart';

/// Lets the user point the app at another backend (e.g. the demo laptop) without rebuilding.
class ServerAddressDialog extends StatefulWidget {
  final String initial;
  const ServerAddressDialog({super.key, required this.initial});

  /// Asks for the address, saves it, reconnects and reports the result.
  static Future<void> edit(BuildContext context) async {
    final address = await showDialog<String>(
      context: context,
      builder: (_) => ServerAddressDialog(initial: ApiConfig.serverLabel),
    );
    if (address == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (ApiConfig.normalizeServerAddress(address) == null) {
      messenger.showSnackBar(const SnackBar(
        content: Text("Enter an address like 192.168.1.20:8000"),
        backgroundColor: AppColors.emergencyRed,
      ));
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text("Connecting to ${address.trim()}...")));
    final state = MockAppState();
    final reachable = await state.setServerAddress(address);
    messenger.hideCurrentSnackBar();
    final String message;
    if (!reachable) {
      message = "Could not reach ${ApiConfig.serverLabel}. Check the address and Wi-Fi; the app keeps working offline.";
    } else if (!AuthSession.isSignedIn) {
      message = "Server ${ApiConfig.serverLabel} found. Sign in or register to sync your data.";
    } else {
      message = "Connected to ${ApiConfig.serverLabel}";
    }
    messenger.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: reachable ? AppColors.successGreen : AppColors.emergencyRed,
    ));
  }

  @override
  State<ServerAddressDialog> createState() => _ServerAddressDialogState();
}

class _ServerAddressDialogState extends State<ServerAddressDialog> {
  late final TextEditingController _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Server Address"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wi-Fi address of the computer running the backend. The phone must be on the same network.",
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(hintText: "192.168.1.20:8000"),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        FilledButton(onPressed: () => Navigator.pop(context, _controller.text), child: const Text("Connect")),
      ],
    );
  }
}
