import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/clinical_button.dart';
import '../../widgets/common/step_progress_bar.dart';
import '../../widgets/common/clinical_card.dart';
import '../../models/registration_draft.dart';
import 'elderly_reg_step2_screen.dart';

class ElderlyRegStep1Screen extends StatefulWidget {
  const ElderlyRegStep1Screen({super.key});

  @override
  State<ElderlyRegStep1Screen> createState() => _ElderlyRegStep1ScreenState();
}

class _ElderlyRegStep1ScreenState extends State<ElderlyRegStep1Screen> {
  final _nameController = TextEditingController(text: "Kamala Perera");
  final _dobController = TextEditingController(text: "15 / 04 / 1952 (72 yrs)");
  String _selectedGender = "Female";
  String _selectedBlood = "O+";
  final _phoneController = TextEditingController(text: "+94 77 123 4567");
  final _addressController = TextEditingController(text: "No. 42, Temple Road, Colombo 03");
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Age from "DD / MM / YYYY"; null when the date can't be read
  int? _ageFromDob(String text) {
    final match = RegExp(r"(\d{1,2})\D+(\d{1,2})\D+(\d{4})").firstMatch(text);
    if (match == null) return null;
    final day = int.parse(match.group(1)!), month = int.parse(match.group(2)!), year = int.parse(match.group(3)!);
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) age--;
    return age;
  }

  void _next() {
    final messenger = ScaffoldMessenger.of(context);
    final age = _ageFromDob(_dobController.text);
    final String? problem;
    if (_nameController.text.trim().length < 2) {
      problem = "Enter the full name";
    } else if (age == null) {
      problem = "Enter the date of birth as DD / MM / YYYY";
    } else if (age < 40 || age > 120) {
      problem = "ElderGuard accounts are for people aged 40 to 120";
    } else if (_phoneController.text.replaceAll(RegExp(r"\D"), "").length < 7) {
      problem = "Enter a valid phone number";
    } else if (_passwordController.text.length < 6) {
      problem = "Password must be at least 6 characters";
    } else if (_addressController.text.trim().isEmpty) {
      problem = "Enter the home address";
    } else {
      problem = null;
    }
    if (problem != null) {
      messenger.showSnackBar(SnackBar(content: Text(problem), backgroundColor: AppColors.emergencyRed));
      return;
    }
    final draft = ElderlyRegistrationDraft()
      ..fullName = _nameController.text
      ..age = age!
      ..gender = _selectedGender
      ..bloodGroup = _selectedBlood
      ..phone = _phoneController.text
      ..password = _passwordController.text
      ..address = _addressController.text;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ElderlyRegStep2Screen(draft: draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Elderly Registration"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            const StepProgressBar(currentStep: 1),

            // Form Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's get to know you",
                      style: AppTypography.headlineLg.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Please provide your basic information",
                      style: AppTypography.bodyMd.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 20),

                    // Full Name Card
                    ClinicalCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Full Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textNavy,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date of Birth / Age Card
                    ClinicalCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.textDark,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date of Birth & Age",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TextField(
                                  controller: _dobController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textNavy,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Gender & Blood Group Row
                    Row(
                      children: [
                        // Gender
                        Expanded(
                          child: ClinicalCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Gender",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedGender,
                                    isDense: true,
                                    isExpanded: true,
                                    items: ["Female", "Male", "Other"].map((g) {
                                      return DropdownMenuItem(
                                        value: g,
                                        child: Text(
                                          g,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textNavy,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedGender = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Blood Group
                        Expanded(
                          child: ClinicalCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Blood Group",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedBlood,
                                    isDense: true,
                                    isExpanded: true,
                                    items: ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"].map((b) {
                                      return DropdownMenuItem(
                                        value: b,
                                        child: Text(
                                          b,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.emergencyRed,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedBlood = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Primary Phone
                    ClinicalCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.textDark,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Primary Phone Number",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textNavy,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password (needed to sign in again later)
                    ClinicalCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: AppColors.textDark,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Create a Password",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textNavy,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: "At least 6 characters",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Home Address
                    ClinicalCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              color: AppColors.textDark,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Home Address",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                TextField(
                                  controller: _addressController,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textNavy,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClinicalButton(
                text: "Next",
                showChevron: true,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
