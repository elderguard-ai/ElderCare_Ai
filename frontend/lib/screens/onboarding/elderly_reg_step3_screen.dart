import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/clinical_button.dart';
import '../../widgets/common/step_progress_bar.dart';
import '../../widgets/common/clinical_card.dart';
import '../../models/registration_draft.dart';
import '../../state/mock_app_state.dart';
import '../../widgets/common/server_address_dialog.dart';
import '../elderly/health_dashboard_screen.dart';
import '../wearable/bluetooth_pairing_screen.dart';

class ElderlyRegStep3Screen extends StatefulWidget {
  final ElderlyRegistrationDraft draft;
  const ElderlyRegStep3Screen({super.key, required this.draft});

  @override
  State<ElderlyRegStep3Screen> createState() => _ElderlyRegStep3ScreenState();
}

class _ElderlyRegStep3ScreenState extends State<ElderlyRegStep3Screen> {
  // The backend creates the real family linking code together with the account
  static const String _codePlaceholder = "EG-····-··";

  String _contactName = "Nimal Perera";
  String _contactRelation = "Son";
  String _contactPhone = "+94 71 987 6543";
  bool _submitting = false;

  Future<void> _editContact() async {
    final contact = await showDialog<List<String>>(
      context: context,
      builder: (_) => _EmergencyContactDialog(name: _contactName, relation: _contactRelation, phone: _contactPhone),
    );
    if (contact == null) return;
    setState(() {
      _contactName = contact[0];
      _contactRelation = contact[1];
      _contactPhone = contact[2];
    });
  }

  Future<void> _complete() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_contactName.trim().length < 2 || _contactPhone.replaceAll(RegExp(r"\D"), "").length < 7) {
      messenger.showSnackBar(const SnackBar(
        content: Text("Tap the emergency contact card and enter a name and phone number"),
        backgroundColor: AppColors.emergencyRed,
      ));
      return;
    }
    widget.draft
      ..emergencyContactName = _contactName
      ..emergencyContactRelation = _contactRelation
      ..emergencyContactPhone = _contactPhone;

    setState(() => _submitting = true);
    final result = await MockAppState().registerElderly(widget.draft);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result.error != null) {
      messenger.showSnackBar(SnackBar(
        content: Text(result.error!),
        backgroundColor: AppColors.emergencyRed,
        action: SnackBarAction(
          label: "Server",
          textColor: Colors.white,
          onPressed: () => ServerAddressDialog.edit(context),
        ),
      ));
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LinkingCodeDialog(code: result.linkingCode ?? ""),
    );
    if (!mounted) return;
    // The account exists now: registration steps are no longer reachable with Back
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HealthDashboardScreen()),
      (route) => false,
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => const BluetoothPairingScreen()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Emergency & Linking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator (Step 3 of 3)
            const StepProgressBar(currentStep: 3),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emergency Contacts",
                      style: AppTypography.headlineLg.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Designate who will be contacted immediately during fall or SOS events.",
                      style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 18),

                    // Primary Emergency Contact Card (tap to edit)
                    ClinicalCard(
                      onTap: _editContact,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryLight,
                                ),
                                child: const Icon(
                                  Icons.contact_phone_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _contactName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "$_contactRelation • $_contactPhone",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successSoftBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Priority 1",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.successGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.edit_rounded, size: 18, color: AppColors.textMuted),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.notifications_active_rounded,
                                    size: 16, color: AppColors.emergencyRed),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Instant push alert, automated SMS & loud siren",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text(
                        "Add Another Emergency Contact",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Family Linking Code Card
                    ClinicalCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0xFFF0FDF4),
                      borderColor: const Color(0xFFBBF7D0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.qr_code_rounded,
                                  color: AppColors.secondary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Family Linking Code",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textNavy,
                                      ),
                                    ),
                                    Text(
                                      "Share with your caregiver to connect",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Highlighted Code Container
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.secondary, width: 1.5),
                            ),
                            child: const Center(
                              child: Text(
                                _codePlaceholder,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Your code is created when you complete registration"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy_rounded, size: 18),
                                  label: const Text("Copy Code"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.textNavy,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(color: AppColors.borderLight),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share_rounded, size: 18),
                                  label: const Text("Share"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action: Complete & Pair Wearable
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClinicalButton(
                text: _submitting ? "Creating Account..." : "Complete Registration & Pair Device",
                showChevron: !_submitting,
                onPressed: _submitting ? null : _complete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContactDialog extends StatefulWidget {
  final String name;
  final String relation;
  final String phone;
  const _EmergencyContactDialog({required this.name, required this.relation, required this.phone});

  @override
  State<_EmergencyContactDialog> createState() => _EmergencyContactDialogState();
}

class _EmergencyContactDialogState extends State<_EmergencyContactDialog> {
  late final _name = TextEditingController(text: widget.name);
  late final _relation = TextEditingController(text: widget.relation);
  late final _phone = TextEditingController(text: widget.phone);

  @override
  void dispose() {
    _name.dispose();
    _relation.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Emergency Contact"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: "Full name")),
          TextField(controller: _relation, decoration: const InputDecoration(labelText: "Relationship (e.g. Son)")),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: "Mobile phone (receives alerts)"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        FilledButton(
          onPressed: () => Navigator.pop(context, [_name.text.trim(), _relation.text.trim(), _phone.text.trim()]),
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class _LinkingCodeDialog extends StatelessWidget {
  final String code;
  const _LinkingCodeDialog({required this.code});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Account Created"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Share this family linking code with your caregiver so they can connect to your profile. "
            "You can also find it later in Menu & Settings.",
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text(
            code,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 4, color: AppColors.primary),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Linking code copied to clipboard!"), duration: Duration(seconds: 2)),
            );
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text("Copy"),
        ),
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text("Continue")),
      ],
    );
  }
}
