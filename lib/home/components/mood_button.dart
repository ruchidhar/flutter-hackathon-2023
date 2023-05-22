import 'package:flutter/material.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({
    Key? key,
    required this.mood,
    required this.onPressed,
    this.isSelected = false,
    this.moodDesc,
  }) : super(key: key);

  final String mood;
  final bool isSelected;
  final VoidCallback onPressed;
  final String? moodDesc;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Colors.green : Colors.transparent,
        ),
        shadowColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            mood,
            style: const TextStyle(fontSize: 44),
          ),
          Text(moodDesc ?? ''),
        ],
      ),
    );
  }
}
