#!/usr/bin/env python3
"""Derive every launcher/store asset from ONE source logo image — no redrawing.

Usage:
    pip install pillow numpy
    python3 tool/apply_brand_icon.py [path/to/source.png]   # default: assets/icon/source_logo.png
    dart run flutter_launcher_icons                          # then regenerate mipmaps/AppIcon

The source image's pixels are used verbatim; the script only:
  - trims uniform border / transparent padding,
  - removes a near-uniform background to get a transparent mark (for the
    adaptive foreground + splash) when the source has no alpha channel,
  - resizes (Lanczos) and pads onto white or transparent canvases.

Outputs:
  assets/icon/app_icon.png            1024×1024 white, mark at 72%  (legacy icon)
  assets/icon/adaptive_foreground.png 1024×1024 transparent, mark at 46% (Android adaptive safe zone)
  store/play_icon_512.png             512×512 white, mark at 72%    (Play hi-res icon)
  store/feature_graphic_1024x500.png  mark + wordmark on white      (Play feature graphic)
  store/splash_mark.png               1152×1152 transparent, mark at 50%
"""
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

SRC = sys.argv[1] if len(sys.argv) > 1 else "assets/icon/source_logo.png"


def load_mark(path):
    """Source image → RGBA mark with transparent background, tightly cropped."""
    img = Image.open(path).convert("RGBA")
    a = np.asarray(img).astype(np.int16)

    alpha = a[..., 3]
    if alpha.min() < 250:  # source already has real transparency — trust it
        rgba = a
    else:
        # Opaque source: treat the (near-uniform) corner colour as background.
        corners = np.concatenate([a[:3, :3].reshape(-1, 4), a[:3, -3:].reshape(-1, 4),
                                  a[-3:, :3].reshape(-1, 4), a[-3:, -3:].reshape(-1, 4)])
        bg = corners[:, :3].mean(axis=0)
        dist = np.sqrt(((a[..., :3] - bg) ** 2).sum(axis=-1))
        # 0 alpha at the bg colour, fully opaque once clearly different; soft edge between.
        new_alpha = np.clip((dist - 12) / 30.0, 0.0, 1.0) * 255
        rgba = a.copy()
        rgba[..., 3] = new_alpha.astype(np.int16)

    rgba = rgba.clip(0, 255).astype(np.uint8)
    mark = Image.fromarray(rgba, "RGBA")
    bbox = mark.getbbox()  # trims fully transparent border
    if bbox:
        mark = mark.crop(bbox)
    return mark


def place(mark, size, scale, background=None):
    """mark fitted into scale·size, centered on a size×size canvas."""
    canvas = Image.new("RGBA", (size, size), background or (0, 0, 0, 0))
    target = int(size * scale)
    w, h = mark.size
    f = target / max(w, h)
    resized = mark.resize((max(1, round(w * f)), max(1, round(h * f))), Image.LANCZOS)
    canvas.alpha_composite(resized, ((size - resized.width) // 2, (size - resized.height) // 2))
    return canvas


def on_white(img):
    bg = Image.new("RGBA", img.size, (255, 255, 255, 255))
    bg.alpha_composite(img)
    return bg.convert("RGB")


mark = load_mark(SRC)

place(mark, 1024, 0.72, (255, 255, 255, 255)).convert("RGB").save("assets/icon/app_icon.png")
place(mark, 1024, 0.46).save("assets/icon/adaptive_foreground.png")
place(mark, 512, 0.72, (255, 255, 255, 255)).convert("RGB").save("store/play_icon_512.png")
place(mark, 1152, 0.50).save("store/splash_mark.png")

# Feature graphic 1024×500: mark left, wordmark + tagline (text only — not the icon).
fg = Image.new("RGBA", (1024, 500), (255, 255, 255, 255))
fg.alpha_composite(place(mark, 360, 0.9), (86, 70))
font_path = "assets/fonts/PlusJakartaSans-Variable.ttf"
name_f = ImageFont.truetype(font_path, 96)
try:
    name_f.set_variation_by_axes([800])
except Exception:
    pass
tag_f = ImageFont.truetype(font_path, 34)
d = ImageDraw.Draw(fg)
d.text((470, 168), "DocsBuddy", font=name_f, fill=(0x0F, 0x1E, 0x33))
d.text((474, 288), "Never miss a renewal again", font=tag_f, fill=(0x5A, 0x6B, 0x82))
fg.convert("RGB").save("store/feature_graphic_1024x500.png")

print(f"done — derived all assets from {SRC} ({mark.size[0]}x{mark.size[1]} after trim)")
