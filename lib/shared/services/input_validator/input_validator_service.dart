import 'package:email_validator/email_validator.dart';

abstract class InputValidatorService {
  bool validateEmail(String email);
}

class InputValidatorServiceImpl implements InputValidatorService {
  // validates the inputted string as an email
  @override
  bool validateEmail(String email) {
    bool valid = EmailValidator.validate(email);

    return valid;
  }
}
