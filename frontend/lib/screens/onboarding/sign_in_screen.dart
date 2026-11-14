import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/api_config.dart';
import '../../services/auth_session.dart';
import '../../state/mock_app_state.dart';
import '../../widgets/common/clinical_button.dart';
import '../../widgets/common/clinical_text_field.dart';
import '../../widgets/common/server_address_dialog.dart';
import '../caregiver/caregiver_portal_screen.dart';
import '../elderly/health_dashboard_screen.dart';

/// Sign in to an existing elderly or caregiver account.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text("Enter your phone number (or email) and password")));
      return;
    }
    setState(() => _submitting = true);
    final error = await MockAppState().signIn(_usernameController.text, _passwordController.text);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.emergencyRed));
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AuthSession.isCaregiver ? const CaregiverPortalScreen() : const HealthDashboardScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Sign In"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome back", style: AppTypography.headlineLg.copyWith(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                "Sign in with the phone number (or caregiver email) you registered with.",
                style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              ClinicalTextField(
                label: "Phone Number or Email",
                hintText: "e.g. +94 77 123 4567",
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 12),
              ClinicalTextField(
                label: "Password",
                hintText: "Enter your password",
                controller: _passwordController,
                obscureText: true,
                icon: Icons.lock_rounded,
              ),
              const SizedBox(height: 28),
              ClinicalButton(
                text: _submitting ? "Signing In..." : "Sign In",
                showChevron: !_submitting,
                onPressed: _submitting ? null : _signIn,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await ServerAddressDialog.edit(context);
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.dns_rounded, size: 18),
                  label: Text("Server: ${ApiConfig.serverLabel}  ·  Change"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
