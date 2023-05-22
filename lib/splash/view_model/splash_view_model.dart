import 'dart:async';

import 'package:supabasetime/shared/routes/routes.dart';

import '../../shared/services/navigation/navigation_service.dart';
import '../../shared/services/supabase/supabase_service.dart';
import '../../shared/view_models/loading_view_model.dart';

class SplashViewModel extends LoadingViewModel {
  SplashViewModel({
    required NavigationService navigationService,
    required SupabaseService supabaseService,
  })  : _navigationService = navigationService,
        _supabaseService = supabaseService;

  final NavigationService _navigationService;
  final SupabaseService _supabaseService;

  void redirectAfterAuth() {
    final session = _supabaseService.supabaseClient.auth.currentSession;

    Timer(
      const Duration(milliseconds: 1800),
      () {
        if (session != null) {
          _navigationService.pushNamedAndRemoveUntil(
            AppRoutes.homeRoute,
            (_) => false,
          );
        } else {
          _navigationService.pushNamedAndRemoveUntil(
            AppRoutes.loginRoute,
            (_) => false,
          );
        }
      },
    );
  }
}
