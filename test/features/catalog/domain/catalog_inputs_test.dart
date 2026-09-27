import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_inputs.dart';
import 'package:docsbuddy/features/catalog/domain/catalog_models.dart';
import 'package:docsbuddy/features/catalog/domain/common_categories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final builtInAc = commonAssetCategories.firstWhere((c) => c.slug == 'appliance-ac');
  const dbAc = AssetCategory(id: '11111111-2222-3333-4444-555555555555', slug: 'appliance-ac', name: 'Air Conditioner');

  group('AssetDraft.toInput', () {
    test('requires a name', () {
      const draft = AssetDraft(name: '   ', category: AssetCategoryKind.appliance);
      expect(draft.toInput, throwsA(isA<ValidationFailure>()));
    });

    test('trims text, blanks become null, parses the price', () {
      final input = const AssetDraft(
        name: '  Bedroom AC ',
        category: AssetCategoryKind.appliance,
        brand: ' LG ',
        model: '',
        price: ' 42,000 ',
        roomName: '  ',
      ).toInput();
      expect(input.name, 'Bedroom AC');
      expect(input.brand, 'LG');
      expect(input.model, isNull);
      expect(input.purchasePrice, 42000);
      expect(input.locationName, isNull);
    });

    test('built-in types carry their name; DB types rely on the FK', () {
      final builtIn = AssetDraft(name: 'AC', category: AssetCategoryKind.appliance, type: builtInAc).toInput();
      expect(builtIn.categoryId, builtInAc.id);
      expect(builtIn.typeName, 'Air Conditioner');

      final db = const AssetDraft(name: 'AC', category: AssetCategoryKind.appliance, type: dbAc).toInput();
      expect(db.categoryId, dbAc.id);
      expect(db.typeName, isNull);

      final custom =
          const AssetDraft(name: 'X', category: AssetCategoryKind.appliance, customType: 'Dishwasher').toInput();
      expect(custom.categoryId, isNull);
      expect(custom.typeName, 'Dishwasher');
    });

    test('collects spec values in spec order, then non-empty extras', () {
      final input = AssetDraft(
        name: 'AC',
        category: AssetCategoryKind.appliance,
        type: builtInAc,
        specValues: const {'Type': 'Split', 'Tonnage': ' 1.5 ton ', 'Energy rating': ''},
        extraProperties: const [
          PropertyEntry(label: 'Colour', value: 'White'),
          PropertyEntry(label: 'Blank', value: '  '),
        ],
      ).toInput();
      expect(input.properties.keys, ['Tonnage', 'Type', 'Colour']);
      expect(input.properties['Tonnage'], '1.5 ton');
    });

    test('specSlug decides which spec fields count when the type is unresolved', () {
      final input = const AssetDraft(
        name: 'AC',
        category: AssetCategoryKind.appliance,
        specSlug: 'appliance-ac',
        specValues: {'Tonnage': '2 ton'},
      ).toInput();
      expect(input.properties, {'Tonnage': '2 ton'});
    });
  });

  test('ReminderDraft.toInput defaults the label, sorts offsets, parses cost', () {
    final input = ReminderDraft(
      kind: ReminderKind.insurance,
      dueDate: DateTime(2027, 1, 1),
      recurrence: Recurrence.yearly,
      notifyOffsets: const {1, 30, 7},
      cost: '4,200',
      provider: ' Acko ',
    ).toInput();
    expect(input.label, 'Insurance');
    expect(input.notifyOffsets, [30, 7, 1]);
    expect(input.cost, 4200);
    expect(input.provider, 'Acko');
    expect(input.notes, isNull);
  });

  test('splitProperties separates spec fields from free-form rows', () {
    final split = splitProperties({'Tonnage': '1.5', 'Colour': 'White'}, 'appliance-ac');
    expect(split.specValues, {'Tonnage': '1.5'});
    expect(split.extras, [const PropertyEntry(label: 'Colour', value: 'White')]);
  });

  test('specSlugForAsset matches built-ins by id or name', () {
    expect(specSlugForAsset(const Asset(id: 'a', name: 'x', category: AssetCategoryKind.appliance, categoryId: 'cat_ac')),
        'appliance-ac');
    expect(
        specSlugForAsset(
            const Asset(id: 'a', name: 'x', category: AssetCategoryKind.appliance, categoryName: 'Refrigerator')),
        'appliance-fridge');
    expect(specSlugForAsset(const Asset(id: 'a', name: 'x', category: AssetCategoryKind.other)), isNull);
  });

  test('parseAmount tolerates commas and whitespace', () {
    expect(parseAmount(' 1,23,456.50 '), 123456.5);
    expect(parseAmount(''), isNull);
    expect(parseAmount('abc'), isNull);
  });
}
