# Play Store listing assets

All app icons come from the DocsBuddy brand kit in
`docsbuddy-web/brand` (source: `brand/generate.mjs`, run `npm run icons`
there). To refresh the mobile app after the kit changes:

```sh
# from docsbuddy-mobile
B=../docsbuddy-web/brand
cp $B/flutter/assets/icon/app_icon.png $B/flutter/assets/icon/adaptive_foreground.png assets/icon/
cp $B/web/logo.png assets/icon/source_logo.png            # DbLogo header mark
cp $B/stores/play-store-icon-512.png store/play_icon_512.png
cp $B/stores/app-store-icon-1024.png store/app_store_icon_1024.png
cp $B/macos/AppIcon.appiconset/*.png macos/Runner/Assets.xcassets/AppIcon.appiconset/
cp $B/windows/app_icon.ico windows/runner/resources/
cp $B/web/icon-192.png web/icons/Icon-192.png
cp $B/web/icon-512.png web/icons/Icon-512.png
cp $B/web/icon-maskable-512.png web/icons/Icon-maskable-512.png
cp $B/web/favicon-96x96.png web/favicon.png
dart run flutter_launcher_icons      # regenerates Android mipmaps + iOS AppIcon
```

Note: `assets/icon/adaptive_monochrome.png` is NOT the kit's
`flutter/assets/icon/adaptive_monochrome.png` — that one is framed for a
108dp layer with no inset, but `flutter_launcher_icons` adds a 16% inset,
so it would render ~30% smaller than the colour foreground. The file here
is the kit's monochrome art framed like `adaptive_foreground.png`
(scale .86 in the 120-unit frame).

`tool/apply_brand_icon.py` is from the previous logo — don't run it; it
would overwrite `assets/icon/app_icon.png` with a white-background icon.

| File | Play Console slot |
|------|-------------------|
| `play_icon_512.png` | App icon (512×512, 32-bit PNG) |
| `app_store_icon_1024.png` | App Store icon (1024×1024, no alpha) |
| `feature_graphic_1024x500.png` | Feature graphic (1024×500) |
| `splash_mark.png` | spare padded mark (branded splash / misc) |

Still needed for the listing: phone screenshots (min 2, 16:9 or 9:16) —
capture from the app once the backend is live.
