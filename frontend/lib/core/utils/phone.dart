/// Phone numbers are stored without spaces or dashes, so "+94 77 123 4567" and "+94771234567"
/// are the same account at registration and sign-in.
String normalizePhone(String input) => input.replaceAll(RegExp(r"[\s\-()]"), "");
