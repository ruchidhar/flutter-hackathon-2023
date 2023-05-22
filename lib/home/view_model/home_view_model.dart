import 'package:flutter/foundation.dart';
import 'package:supabasetime/shared/models/mood_model.dart';

import '../../shared/models/quote_model.dart';
import '../../shared/routes/routes.dart';
import '../../shared/services/navigation/navigation_service.dart';
import '../../shared/services/supabase/supabase_service.dart';
import '../../shared/view_models/loading_view_model.dart';
import '../repository/home_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HomeViewModel extends LoadingViewModel {
  HomeViewModel({
    required NavigationService navigationService,
    required SupabaseService supabaseService,
    required HomeRepository homeRepository,
  })  : _navigationService = navigationService,
        _supabaseService = supabaseService,
        _homeRepository = homeRepository;

  final NavigationService _navigationService;
  final SupabaseService _supabaseService;
  final HomeRepository _homeRepository;

  QuoteResponse? quoteToday;

  void navToAccount() {
    _navigationService.pushNamed(AppRoutes.accountRoute).then((value) async {
      await fetchProfile();
    });
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    appModel.userProfile = await _supabaseService.getProfile();
    isLoading = false;
  }

  Future<void> updateMood(String currMood) async {
    try {
      isLoading = true;

      final mood = MoodEntry(
        moodName: currMood,
        updatedAt: DateTime.now().toIso8601String(),
        userId: appModel.userProfile.id,
        date: _selectedDay(DateTime.now()),
      );

      await _supabaseService.updateMood(mood);
    } catch (err) {
      debugPrint('Error in updateMood ${err.toString()}');
    }

    isLoading = false;
  }

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour <= 12) {
      return 'Good Morning';
    } else if (hour > 12 && hour <= 16) {
      return 'Good Afternoon';
    } else if (hour > 16 && hour <= 20) {
      return 'Good Evening';
    }

    return 'Good Night';
  }

  Future<QuoteResponse?> getQuote() async {
    isLoading = true;

    try {
      quoteToday = await _homeRepository.getQuote();
      isLoading = false;

      return quoteToday;
    } catch (err) {
      debugPrint('Error in getQuote ${err.toString()}');
    }

    isLoading = false;

    return null;
  }

  Future<void> navToCalendar() async {
    _navigationService.pushNamed(AppRoutes.calendarRoute);
  }

  String moodSubText(MoodType moodType) {
    switch (moodType) {
      case MoodType.Awesome:
        return 'Woo hoo!!! Keep shining and spreading your awesomeness wherever you go.';

      case MoodType.Good:
        return 'Embrace the goodness within and let it radiate outwards, inspiring others to find their own light';

      case MoodType.Neutral:
        return 'In the calm of neutrality, lies the power to explore endless possibilities and discover hidden treasures within';

      case MoodType.Sad:
        return ' Embrace your sadness and let it be the fuel that ignites your inner light';
    }
  }

  // INTERNALS

  String _selectedDay(DateTime today) {
    return DateFormat('yyyy-MM-dd ').format(today);
  }
}
