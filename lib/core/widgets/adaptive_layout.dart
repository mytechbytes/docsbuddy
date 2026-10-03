import 'package:flutter/widgets.dart';

/// Layout that copes with big text. A side-by-side layout is judged on `width / textScale` against the width it
/// was designed for, so large text on a wide screen and normal text on a narrow one are treated alike.
extension TextScaleContext on BuildContext {
  /// How much the user's font setting enlarges text; 1.0 is the default size.
  double get textScale => MediaQuery.textScalerOf(this).scale(14) / 14;
}

/// Whether a box [width] wide still has room for something designed to be
/// [designWidth] wide at the default font size.
bool fitsAtScale(BuildContext context, double width, double designWidth) =>
    width / context.textScale >= designWidth;

/// How many columns of at least [minTileWidth] (at the default font size) fit in
/// [width], from [max] down to [min]. Use it to turn a 4-up grid into 2-up as the
/// text grows, instead of letting the labels collide.
int adaptiveColumns(
  BuildContext context,
  double width, {
  required double minTileWidth,
  double spacing = 8,
  int max = 4,
  int min = 1,
}) {
  for (var columns = max; columns > min; columns--) {
    final tile = (width - spacing * (columns - 1)) / columns;
    if (tile / context.textScale >= minTileWidth) return columns;
  }
  return min;
}

/// Two widgets side by side while each keeps enough room, stacked when large text or a narrow screen leaves too
/// little. [minWidth] is the total width, at the default font size, below which they stack. Needs a bounded width.
class TwoUp extends StatelessWidget {
  const TwoUp({super.key, required this.left, required this.right, this.minWidth = 270, this.gap = 12});

  final Widget left;
  final Widget right;
  final double minWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (fitsAtScale(context, constraints.maxWidth, minWidth)) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: left), SizedBox(width: gap), Expanded(child: right)],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [left, SizedBox(height: gap), right],
        );
      },
    );
  }
}

extension LargeTextContext on BuildContext {
  /// Whether the font is enlarged enough that primary text (a name, a title) should
  /// wrap instead of being cut to one line with an ellipsis.
  bool get largeText => textScale > 1.15;

  /// `maxLines` for primary text: one line at normal size, free to wrap when the font is enlarged.
  int? get primaryLines => largeText ? null : 1;

  /// Pair of [primaryLines]: an ellipsis only while the text is held to one line.
  TextOverflow? get primaryOverflow => largeText ? null : TextOverflow.ellipsis;
}

/// A list-tile body: [leading] image or icon, text, and a trailing [badge] (a days-left pill). The badge sits
/// beside the text while there is room and drops under it otherwise. Needs a bounded width.
/// [body] builds the text and is told whether it may wrap; it should drop its `maxLines` when it may.
class BadgedTile extends StatelessWidget {
  const BadgedTile({
    super.key,
    required this.leading,
    required this.body,
    required this.badge,
    this.gap = 12,
    this.badgeGap = 8,
    this.minWidth = 250,
  });

  final Widget leading;
  final Widget Function(bool wrap) body;
  final Widget badge;

  /// Space between [leading] and the text.
  final double gap;

  /// Space between the text and the badge when they are side by side.
  final double badgeGap;

  /// Narrowest (at the default font size) that keeps the badge beside the text.
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (fitsAtScale(context, constraints.maxWidth, minWidth)) {
          return Row(
            children: [
              leading,
              SizedBox(width: gap),
              Expanded(child: body(context.largeText)),
              SizedBox(width: badgeGap),
              badge,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            SizedBox(width: gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [body(true), const SizedBox(height: 8), badge],
              ),
            ),
          ],
        );
      },
    );
  }
}
