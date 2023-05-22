import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:supabasetime/calendar/view_model/calendar_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../shared/models/mood_model.dart';
import '../../shared/resources/resource.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late CalendarViewModel viewModel;
  DateTime today = DateTime.now();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    viewModel = context.read();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar'),
        leading: BackButton(
          onPressed: () {
            viewModel.navToHome();
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<CalendarViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return child!;
            }

            return Column(
              children: [
                const SizedBox(height: 18),
                const ListTile(
                  title: Text(
                    'Tip: Long Press on date to enable/disable range Mode',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onRangeSelected: _onRangeSelected,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: _onDaySelected,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Mood Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: viewModel.moodEntries.length,
                    itemBuilder: (context, index) {
                      final data = viewModel.moodEntries[index];
                      final mood = data.moodName;
                      final emoji =
                          ConstantsResource.emojiMap(mapStringToMood(mood));

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: null,
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              emoji,
                              textScaleFactor: 2,
                            ),
                          ),
                          title: Text(mood),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 4);
                    },
                  ),
                )
              ],
            );
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(today, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    } else {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    }

    if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
      return;
    }

    await viewModel.fetchMoodRecords(
      _focusedDay.toString(),
      _selectedDay!.add(const Duration(days: 1)).toString(),
    );
  }

  void _onRangeSelected(
      DateTime? start, DateTime? end, DateTime focusedDay) async {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (_rangeEnd != null) {
      await viewModel.fetchMoodRecords(
        _rangeStart.toString(),
        _rangeEnd.toString(),
      );
    }
  }
}
