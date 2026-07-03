# Play Store listing assets

Every asset here (and the launcher icons) is derived from the **original
logo file** `assets/icon/source_logo.png` — the exact provided pixels, no
redrawing. To regenerate (e.g. after replacing the source file):

```sh
pip install pillow numpy
python3 tool/apply_brand_icon.py     # derives ALL assets from the exact pixels
dart run flutter_launcher_icons      # regenerates Android mipmaps + iOS AppIcon
```

`apply_brand_icon.py` only trims padding, removes a uniform background when
the file has no alpha channel, then resizes and pads. The same source file
is bundled as a Flutter asset and rendered by `DbLogo` on every page header.

| File | Play Console slot |
|------|-------------------|
| `play_icon_512.png` | App icon (512×512, 32-bit PNG) |
| `feature_graphic_1024x500.png` | Feature graphic (1024×500) |
| `splash_mark.png` | spare padded mark (branded splash / misc) |

Still needed for the listing: phone screenshots (min 2, 16:9 or 9:16) —
capture from the app once the backend is live.
