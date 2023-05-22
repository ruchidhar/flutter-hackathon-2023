import 'package:flutter/foundation.dart';
import 'package:supabasetime/shared/models/mood_model.dart';

import '../../shared/services/navigation/navigation_service.dart';
import '../../shared/services/supabase/supabase_service.dart';
import '../../shared/view_models/loading_view_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CalendarViewModel extends LoadingViewModel {
  CalendarViewModel({
    required NavigationService navigationService,
    required SupabaseService supabaseService,
  })  : _navigationService = navigationService,
        _supabaseService = supabaseService;

  final NavigationService _navigationService;
  final SupabaseService _supabaseService;

  List<MoodEntry> moodEntries = [];

  Future<void> fetchMoodRecords(String dateFrom, String dateTo) async {
    isLoading = true;

    try {
      moodEntries = await _supabaseService.fetchMoodRecords(dateFrom, dateTo);
    } catch (err) {
      debugPrint('Error in fetchMoodRecords ${err.toString()}');
    }

    isLoading = false;
  }

  String selectedDay(DateTime today) {
    return DateFormat('dd-MM-yyyy ').format(today);
  }

  Future<void> navToHome() async {
    _navigationService.pop();
  }
}
