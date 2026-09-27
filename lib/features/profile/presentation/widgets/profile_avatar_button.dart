import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_routes.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../application/profile_providers.dart';

/// The signed-in user's avatar for app bars (`users.avatar_url`, else a
/// gradient initial); tap opens Profile.
class ProfileAvatarButton extends ConsumerWidget {
  const ProfileAvatarButton({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => context.push(AppRoutes.profile),
      child: AssetThumb(
        imageRef: profile?.avatarUrl,
        size: size,
        radius: size / 2,
        fallback: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Color(0xFFF1C27D), Color(0xFFD68B5C)]),
          ),
          alignment: Alignment.center,
          child: profile == null
              ? Icon(Icons.person, color: Colors.white, size: size * 0.56)
              : Text(profile.initial,
                  style: TextStyle(fontSize: size * 0.44, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}
