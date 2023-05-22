import 'package:flutter/material.dart';

import '../../shared/components/skeleton_widget.dart';

class UserAccountButton extends StatelessWidget {
  const UserAccountButton({
    Key? key,
    required this.image,
    this.size,
    this.isLoading = true,
  }) : super(key: key);

  final String image;
  final double? size;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: isLoading
          ? const SkeletonAvatar(height: 48, width: 48)
          : Image.network(
              image,
              width: size ?? 48,
              height: size ?? 48,
            ),
    );
  }
}
