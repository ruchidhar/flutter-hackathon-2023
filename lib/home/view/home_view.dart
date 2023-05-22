import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:supabasetime/home/components/quote_card.dart';
import 'package:supabasetime/home/view_model/home_view_model.dart';
import 'package:supabasetime/shared/models/mood_model.dart';
import 'package:supabasetime/shared/resources/resource.dart';

import '../../shared/components/custom_button.dart';
import '../components/mood_button.dart';
import '../../shared/extensions/snackbar_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel viewModel;
  late String selectedMood = '';

  @override
  void initState() {
    super.initState();
    viewModel = context.read();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await viewModel.fetchProfile();
      await viewModel.getQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
      ),
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return child!;
            }

            final url = viewModel.appModel.userProfile.avatarUrl;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "${viewModel.greeting}, ${viewModel.appModel.userProfile.username}",
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                      const Spacer(),
                      IconButton.filled(
                        onPressed: () {
                          viewModel.navToAccount();
                        },
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  QuoteCard(
                    title: viewModel.appModel.userProfile.username!,
                    desc: viewModel.quoteToday?.content ?? 'What\'s up?',
                    date: viewModel.quoteToday?.author ?? "",
                    onPressed: (int val) {
                      viewModel.navToAccount();
                    },
                    isLoading: viewModel.quoteToday == null,
                    image: url!,
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: moodList(),
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    buttonText: 'Check your Calendar',
                    onPressed: () {
                      viewModel.navToCalendar();
                    },
                    isEnabled: !viewModel.isLoading,
                  ),
                ],
              ),
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

  List<Widget> moodList() {
    List<Widget> list = [];

    for (var i = 0; i < MoodType.values.length; i++) {
      final emoji = ConstantsResource.emojiMap(MoodType.values[i]);
      final moodDesc = describeEnum(MoodType.values[i]);

      list.add(
        MoodButton(
          mood: emoji,
          isSelected: selectedMood == emoji,
          onPressed: () async {
            selectMood(emoji);
            await viewModel.updateMood(moodDesc);

            if (mounted) {
              context.showSnackBar(
                message: 'Mood logged!!',
              );
            }
          },
          moodDesc: moodDesc,
        ),
      );
    }

    return list;
  }

  void selectMood(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }
}
