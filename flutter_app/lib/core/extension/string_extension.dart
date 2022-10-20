import 'package:easy_localization/easy_localization.dart';

import '../constants/app/app_constants.dart';

extension StringLocalization on String {
  String get locale => this.tr();

  // email validation
  String? get isValidEmail => contains(RegExp(ApplicationConstants.instance.EMAIL_REGEX)) ? null : 'Email does not valid';

  bool get isValidEmails => RegExp(ApplicationConstants.instance.EMAIL_REGEX).hasMatch(this);
  bool get isStrongPassword => RegExp(ApplicationConstants.instance.STRONG_PASSWORD_REGEX).hasMatch(this);
}

extension ImagePathExtension on String {
  String get toSVG => 'asset/svg/$this.svg';
}