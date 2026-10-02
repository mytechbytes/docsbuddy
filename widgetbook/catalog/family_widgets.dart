import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:docsbuddy/features/family/presentation/widgets/family_widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import '../support/demo_data.dart';
import '../support/use_cases.dart';

void _noop() {}

WidgetbookFolder familyWidgets() => WidgetbookFolder(
      name: 'Family',
      children: [
        WidgetbookComponent(name: 'FamilyEmptyState', useCases: [
          filling('Default', (_) => FamilyEmptyState(onCreate: _noop, onJoin: _noop)),
        ]),
        WidgetbookComponent(name: 'FamilyOverview', useCases: [
          filling(
            'Owner',
            (_) => FamilyOverview(
              view: demoFamilyView(),
              onInvite: _noop,
              onLeave: _noop,
              onChangeRole: (_) {},
              onRemove: (_) {},
            ),
          ),
          filling(
            'Plain member',
            (_) => FamilyOverview(
              view: demoFamilyView(myUserId: 'u3'),
              onInvite: _noop,
              onLeave: _noop,
              onChangeRole: (_) {},
              onRemove: (_) {},
            ),
          ),
        ]),
        WidgetbookComponent(name: 'MemberTile', useCases: [
          component(
            'Playground',
            (context) => MemberTile(
              member: FamilyMember(
                userId: 'u9',
                displayName: context.knobs.string(label: 'Name', initialValue: 'Priya Kumar'),
                role: context.knobs.object.dropdown(
                    label: 'Role', options: FamilyRole.values, initialOption: FamilyRole.admin, labelBuilder: (r) => r.label),
                phone: context.knobs.stringOrNull(label: 'Phone', initialValue: '+91 98765 43210'),
              ),
              canManage: context.knobs.boolean(label: 'Can manage', initialValue: true),
              onChangeRole: _noop,
              onRemove: _noop,
            ),
          ),
          gallery('Every role', [
            for (final m in demoMembers)
              Labeled(
                '${m.role.label}${m.phone == null ? ' · no phone' : ''}',
                MemberTile(member: m, canManage: m.role != FamilyRole.owner, onChangeRole: _noop, onRemove: _noop),
              ),
          ]),
          component(
            'Long name and number do not overflow',
            (_) => MemberTile(
              member: const FamilyMember(
                  userId: 'u10',
                  displayName: 'Venkatasubramanian Ramachandran-Iyer',
                  role: FamilyRole.member,
                  phone: '+91 98123 45678 ext. 204'),
              canManage: true,
              onChangeRole: _noop,
              onRemove: _noop,
            ),
          ),
        ]),
        WidgetbookComponent(name: 'InviteSheet', useCases: [
          filling('Invite code', (_) => SheetFrame(child: InviteSheet(invite: demoInvite))),
        ]),
        WidgetbookComponent(name: 'FamilyErrorState', useCases: [
          filling(
            'Offline',
            (_) => FamilyErrorState(
                message: 'Can’t reach the server. Check your internet connection.', onRetry: _noop),
          ),
        ]),
      ],
    );
