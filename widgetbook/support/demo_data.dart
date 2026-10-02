// Fixtures for single-widget use cases. (Screens read the seeded fake backend
// instead; see `scenario.dart`.) All of it is fictional.
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/documents/domain/document_models.dart';
import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';

DateTime inDays(int days) => DateTime.now().add(Duration(days: days));

Reminder demoReminder({
  ReminderKind kind = ReminderKind.insurance,
  int days = 12,
  String assetName = 'Honda City ZX',
  String? label,
  String? provider = 'ICICI Lombard',
  String? policyNo = 'ICL-MOT-5521907',
  Recurrence recurrence = Recurrence.yearly,
  List<int> offsets = const [30, 7, 1],
  double? cost = 21800,
  String? notes,
}) =>
    Reminder(
      id: 'r-${kind.name}-$days',
      assetId: 'a-demo',
      assetName: assetName,
      kind: kind,
      label: label ?? kind.label,
      dueDate: inDays(days),
      recurrence: recurrence,
      notifyOffsets: offsets,
      provider: provider,
      policyNo: policyNo,
      cost: cost,
      notes: notes,
    );

/// One reminder of every kind, spread from overdue to far off.
final demoReminderPerKind = [
  for (final (i, kind) in ReminderKind.values.indexed)
    demoReminder(kind: kind, days: const [-3, 0, 5, 12, 25, 40, 90, 180, 300][i % 9], provider: null, policyNo: null),
];

/// Reminders for the days-left pill and the urgency ladder.
final demoUrgencyLadder = [
  demoReminder(kind: ReminderKind.insurance, days: -12),
  demoReminder(kind: ReminderKind.pollution, days: 0),
  demoReminder(kind: ReminderKind.service, days: 6),
  demoReminder(kind: ReminderKind.warranty, days: 140),
];

const demoAsset = Asset(
  id: 'a-demo',
  name: 'Daikin Inverter AC',
  category: AssetCategoryKind.appliance,
  categoryName: 'Air Conditioner',
  locationName: 'Living Room',
  brand: 'Daikin',
  model: 'FTKM50',
  serialNo: 'DK-7731-2290',
  store: 'Reliance Digital',
  purchasePrice: 46500,
  properties: {'Tonnage': '1.5 ton', 'Star rating': '5 star'},
);

/// The least the app will show: a name and a group.
const demoAssetMinimal = Asset(id: 'a-min', name: 'Study desk lamp', category: AssetCategoryKind.other);

/// A name long enough to test truncation and wrapping.
const demoAssetLongName = Asset(
  id: 'a-long',
  name: 'Samsung Family Hub 4-Door French Door Refrigerator with Wi-Fi',
  category: AssetCategoryKind.appliance,
  categoryName: 'Refrigerator',
  locationName: 'Kitchen',
  brand: 'Samsung',
  model: 'RF65A967 (Black Caviar)',
  serialNo: '0AKN4BCR100417T',
);

final demoRooms = [
  const Location(id: 'l1', name: 'Living Room', assetCount: 4, kind: 'room'),
  const Location(id: 'l2', name: 'Kitchen', assetCount: 3, kind: 'room'),
  const Location(id: 'l3', name: 'Garage', assetCount: 1, kind: 'room'),
];

const demoMembers = [
  FamilyMember(userId: 'me', displayName: 'Anand Kumar', role: FamilyRole.owner, phone: '+91 98123 45678'),
  FamilyMember(userId: 'u2', displayName: 'Priya Kumar', role: FamilyRole.admin, phone: '+91 98765 43210'),
  FamilyMember(userId: 'u3', displayName: 'Rohan Kumar', role: FamilyRole.member),
  FamilyMember(userId: 'u4', displayName: 'Meera Kumar', role: FamilyRole.viewer),
];

const demoFamily = Family(id: 'fam1', name: 'Kumar Family', ownerId: 'me');

/// [FamilyView] as seen by [myUserId]; the role decides who can be managed.
FamilyView demoFamilyView({String myUserId = 'me'}) =>
    FamilyView(family: demoFamily, members: demoMembers, myUserId: myUserId);

final demoInvite = FamilyInvite(code: 'K7P3M9XQ', role: FamilyRole.member, expiresAt: inDays(7));

DocumentMeta demoDocument(String title, DocKind kind, String mime, int kb) => DocumentMeta(
      id: 'doc-$title',
      assetId: 'a-demo',
      title: title,
      kind: kind,
      mimeType: mime,
      sizeBytes: kb * 1024,
      storagePath: 'demo/$title',
      createdAt: inDays(-200),
    );

final demoDocuments = [
  demoDocument('Invoice.pdf', DocKind.invoice, 'application/pdf', 412),
  demoDocument('Warranty card.pdf', DocKind.warranty, 'application/pdf', 188),
  demoDocument('User manual.pdf', DocKind.manual, 'application/pdf', 2480),
  demoDocument('Installation.jpg', DocKind.photo, 'image/jpeg', 910),
  demoDocument('Service report.docx', DocKind.other, 'application/msword', 64),
];

const demoEnrollment = TotpEnrollment(
  factorId: 'factor-demo',
  secret: 'JBSWY3DPEHPK3PXP',
  uri: 'otpauth://totp/DocsBuddy:you@docsbuddy.app?secret=JBSWY3DPEHPK3PXP&issuer=DocsBuddy',
);
