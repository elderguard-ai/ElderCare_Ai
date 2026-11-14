import '../core/utils/phone.dart';

/// Elderly sign-up details collected across the three registration steps.
class ElderlyRegistrationDraft {
  String fullName = "";
  String phone = "";
  String password = "";
  int age = 0;
  String gender = "";
  String bloodGroup = "";
  String address = "";
  List<String> chronicConditions = [];
  List<String> allergies = [];
  String primaryDoctor = "";
  String emergencyContactName = "";
  String emergencyContactRelation = "";
  String emergencyContactPhone = "";

  /// Body for POST /auth/register/elderly.
  Map<String, dynamic> toJson() => {
        "full_name": fullName.trim(),
        "phone": normalizePhone(phone),
        "password": password,
        "age": age,
        "gender": gender,
        "blood_group": bloodGroup,
        "address": address.trim(),
        "chronic_conditions": chronicConditions,
        "allergies": allergies,
        if (primaryDoctor.trim().isNotEmpty) "primary_doctor": primaryDoctor.trim(),
        "emergency_contact_name": emergencyContactName.trim(),
        "emergency_contact_relation": emergencyContactRelation.trim(),
        "emergency_contact_phone": normalizePhone(emergencyContactPhone),
      };
}
