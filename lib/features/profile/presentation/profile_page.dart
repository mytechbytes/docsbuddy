import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/loader.dart';
import '../../../core/media/media_picker.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/adaptive_layout.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/settings_list.dart';
import '../../auth/application/auth_controller.dart';
import '../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../family/application/family_controller.dart';
import '../../family/domain/family_models.dart';
import '../application/profile_providers.dart';
import '../domain/profile.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Design screen 14 — Profile: avatar (tap to change), identity + Verified
/// badge, stats row, family card with invite, and account actions.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text(context.l10n.profileTitle, style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: profile.when(
        loading: () => LoadingView(message: context.l10n.loadingProfile),
        error: (e, _) => Center(child: Text(context.failureText(e))),
        data: (p) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Center(child: _Avatar(profile: p, onChange: () => _changeAvatar(context, ref))),
            const SizedBox(height: 12),
            Center(
              child: Text(p.displayName,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: context.palette.text)),
            ),
            const SizedBox(height: 2),
            Center(child: Text(p.email, style: TextStyle(fontSize: 13, color: context.palette.textMuted))),
            if (p.verified) ...[
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: context.palette.successSoft, borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_outlined, size: 14, color: context.palette.successStrong),
                      SizedBox(width: 4),
                      Text(context.l10n.profileVerified,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.palette.successStrong)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const _StatsRow(),
            const SizedBox(height: 14),
            const _FamilyCard(),
            const SizedBox(height: 16),
            SettingsCard(children: [
              _MenuRow(
                icon: Icons.person_outline,
                title: context.l10n.profileEditInfo,
                onTap: () => _editInfo(context, ref, p),
              ),
              _MenuRow(
                icon: Icons.lock_outline,
                title: context.l10n.commonChangePassword,
                onTap: () => context.push(AppRoutes.changePassword),
              ),
              _MenuRow(
                icon: Icons.notifications_none,
                title: context.l10n.profileNotificationPrefs,
                onTap: () => context.pop(), // managed on the Settings tab
                subtitle: context.l10n.profileManagedInSettings,
              ),
            ]),
            const SizedBox(height: 16),
            SettingsCard(children: [
              _MenuRow(
                icon: Icons.logout,
                title: context.l10n.commonSignOut,
                danger: true,
                onTap: () async {
                  final ok = await withLoader(
                    context,
                    context.l10n.loadingSigningOut,
                    () => ref.read(authControllerProvider.notifier).signOut(),
                  );
                  if (ok && context.mounted) context.go(AppRoutes.signIn);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _changeAvatar(BuildContext context, WidgetRef ref) async {
    final f = await pickImage(context);
    if (f == null || !context.mounted) return;
    await runAction(
      context,
      () => ref.read(profileProvider.notifier).setAvatar(f),
      loading: context.l10n.loadingUploadingPhoto,
    );
  }

  Future<void> _editInfo(BuildContext context, WidgetRef ref, Profile p) async {
    final name = TextEditingController(text: p.displayName);
    final phone = TextEditingController(text: p.phone ?? '');
    String? phoneError;
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.profileEditInfo,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
                  const SizedBox(height: 16),
                  AppTextField(label: context.l10n.profileDisplayName, controller: name, icon: Icons.person_outline),
                  const SizedBox(height: 12),
                  AppTextField(
                      label: context.l10n.profilePhone,
                      controller: phone,
                      icon: Icons.phone_outlined,
                      hint: '+91 9812345678',
                      keyboardType: TextInputType.phone,
                      errorText: phoneError),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: context.l10n.commonSave,
                    onPressed: () async {
                      try {
                        await withLoader(
                          context,
                          context.l10n.loadingSavingProfile,
                          () => ref.read(profileProvider.notifier).updateInfo(displayName: name.text, phone: phone.text),
                        );
                        if (context.mounted) Navigator.of(context).pop(true);
                      } on ValidationFailure catch (e) {
                        setSheetState(() => phoneError = e.message);
                      } catch (e, stack) {
                        if (context.mounted) context.showFailure(e, stack);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    name.dispose();
    phone.dispose();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile, required this.onChange});
  final Profile profile;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onChange,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AssetThumb(
            imageRef: profile.avatarUrl,
            size: 96,
            radius: 48,
            fallback: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: AppColors.avatarGradient),
              ),
              alignment: Alignment.center,
              child: Text(profile.initial,
                  textScaler: TextScaler.noScaling,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: context.palette.inverseSurface,
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.background, width: 2.5),
              ),
              child: Icon(Icons.photo_camera_outlined, size: 14, color: context.palette.onInverse),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(profileStatsProvider).value;
    final entries = [
      ('${stats?.assets ?? '—'}', context.l10n.navAssets),
      ('${stats?.reminders ?? '—'}', context.l10n.catalogReminders),
      ('${stats?.documents ?? '—'}', context.l10n.profileDocuments),
    ];
    Widget cell(String value, String label) => Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.palette.text)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: context.palette.textMuted)),
          ],
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Three columns need ~80dp each; with large text they become three
          // lines, label beside count, rather than labels that break mid-word.
          if (fitsAtScale(context, constraints.maxWidth, 240)) {
            return Row(children: [for (final (value, label) in entries) Expanded(child: cell(value, label))]);
          }
          return Column(
            children: [
              for (final (value, label) in entries)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: context.palette.textMuted))),
                      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: context.palette.text)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FamilyCard extends ConsumerWidget {
  const _FamilyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(familyControllerProvider).value;
    final family = view?.family;
    final members = view?.members ?? const <FamilyMember>[];
    if (family == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(family.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.palette.text)),
                const SizedBox(height: 2),
                Text(context.l10n.memberCount(members.length),
                    style: TextStyle(fontSize: 12.5, color: context.palette.textMuted)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: Stack(
                    children: [
                      for (var i = 0; i < members.length && i < 5; i++)
                        PositionedDirectional(
                          start: i * 20.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: context.palette.surface, width: 2),
                            ),
                            child: AssetThumb(
                              imageRef: members[i].avatarUrl,
                              size: 24,
                              radius: 12,
                              fallback: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(color: context.palette.accent, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(members[i].initial,
                                    textScaler: TextScaler.noScaling,
                                    style: const TextStyle(
                                        fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.familyManage),
            icon: const Icon(Icons.person_add_alt_outlined, size: 16),
            label: Text(context.l10n.profileInvite, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.title, this.subtitle, this.onTap, this.danger = false});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      danger: danger,
      trailing: danger ? null : Icon(Icons.chevron_right, color: context.palette.textMuted),
    );
  }
}
