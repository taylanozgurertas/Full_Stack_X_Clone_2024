import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/models/user_model.dart';

class SmallRetweeterImage extends ConsumerWidget {
  final UserModel user;
  const SmallRetweeterImage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      backgroundImage: NetworkImage(user.profilePic),
    );
  }
}
