import '../../shared/routes/routes.dart';
import '../../shared/services/input_validator/input_validator_service.dart';
import '../../shared/services/navigation/navigation_service.dart';
import '../../shared/services/supabase/supabase_service.dart';
import '../../shared/view_models/loading_view_model.dart';

class LoginViewModel extends LoadingViewModel {
  LoginViewModel({
    required NavigationService navigationService,
    required SupabaseService supabaseService,
    required InputValidatorService inputValidatorService,
  })  : _navigationService = navigationService,
        _supabaseService = supabaseService,
        _inputValidatorService = inputValidatorService;

  final NavigationService _navigationService;
  final SupabaseService _supabaseService;
  final InputValidatorService _inputValidatorService;

  Future<void> navToHome() async {
    _navigationService.pushReplacementNamed(AppRoutes.homeRoute);
  }

  Future<void> login(String email) async {
    await _supabaseService.signIn(email);
  }

  void validateEmail(String email) {
    final isValid = _inputValidatorService.validateEmail(email);
    _enableSignIn = isValid;
    notifyListeners();
  }

  bool get enableSignIn => _enableSignIn;

  // INTERNALS
  bool _enableSignIn = false;

  set enableSignIn(bool value) {
    _enableSignIn = value;
    notifyListeners();
  }
}
