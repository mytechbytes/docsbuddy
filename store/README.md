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

## Screenshots

`store/screenshots/` holds the finished Play images (all 9:16, opaque JPEG):

| Folder | Play Console slot | Size |
|--------|-------------------|------|
| `phone/` | Phone screenshots | 1080×1920 |
| `tablet/` | 7-inch **and** 10-inch tablet screenshots (same files) | 1440×2560 |
| `feature_graphic_1024x500.jpg` | Feature graphic (opaque copy of the PNG above) | 1024×500 |

They show the real app on in-memory demo data (a fictional family and home
inventory), not anyone's account. To regenerate after UI changes:

```sh
# 1. Run the demo-data harness on a phone and a tablet simulator
flutter run -t lib/main_store_screenshots.dart -d <simulator>

# 2. Capture each screen at full resolution
xcrun simctl io <simulator-udid> screenshot /tmp/shots/01_dashboard.png

# 3. Compose them into 9:16 store images (brand gradient, caption, rounded card;
#    the OS status bar and home indicator are cropped off)
swiftc -O tool/compose_store_screenshots.swift -o /tmp/compose
/tmp/compose phone  specs.json store/screenshots/phone    # 1080x1920
/tmp/compose tablet specs.json store/screenshots/tablet   # 1440x2560
```

`specs.json` is a list of `{src, out, title, sub}` objects (`topFill` /
`bottomFill` override the crop in pixels). Play requires at least 2 phone
screenshots and recommends 4+ at 1080 px or more; 7-inch and 10-inch tablet
screenshots are also required.
