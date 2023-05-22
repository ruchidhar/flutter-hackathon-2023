import 'package:flutter/material.dart';
import 'package:supabasetime/home/components/account_button.dart';

import '../../shared/components/skeleton_widget.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({
    Key? key,
    required this.title,
    required this.desc,
    required this.date,
    required this.onPressed,
    required this.isLoading,
    required this.image,
  }) : super(key: key);

  final String title, desc, date;
  final Function(int) onPressed;
  final bool isLoading;
  final String image;

  @override
  State<StatefulWidget> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  Color bgColor = Colors.white,
      fgColor = Colors.green,
      iconColor = Colors.white,
      mainTextColor = const Color.fromRGBO(15, 23, 42, 1),
      secondaryTextColor = Colors.white.withOpacity(0.9);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onPressed(1),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[500]),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAccountButton(
            image: widget.image,
            isLoading: widget.isLoading,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SkeletonWidget(
                  isLoading: widget.isLoading,
                  height: 20,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: mainTextColor,
                          fontSize: 20,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonWidget(
                  isLoading: widget.isLoading,
                  height: 20,
                  child: Text(
                    widget.desc,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: secondaryTextColor,
                          fontSize: 18,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonWidget(
                  isLoading: widget.isLoading,
                  height: 20,
                  child: Text(
                    widget.date,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: mainTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
