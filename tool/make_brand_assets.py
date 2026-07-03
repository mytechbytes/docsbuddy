#!/usr/bin/env python3
"""Recreate the DocsBuddy gradient-Z mark and generate all icon/store assets."""
import numpy as np
from PIL import Image, ImageDraw, ImageFont

SS = 4  # supersampling


def offset_polygon(pts, w):
    """Outline polygon of a polyline stroked with width w (miter joins, flat caps)."""
    pts = [np.array(p, float) for p in pts]
    dirs, normals = [], []
    for a, b in zip(pts, pts[1:]):
        d = (b - a) / np.linalg.norm(b - a)
        dirs.append(d)
        normals.append(np.array([-d[1], d[0]]))

    def side(sign):
        out = [pts[0] + sign * normals[0] * w / 2]
        for i in range(1, len(pts) - 1):
            n1, n2 = normals[i - 1], normals[i]
            p = pts[i]
            # Intersect the two offset lines (miter point).
            a1 = p + sign * n1 * w / 2
            a2 = p + sign * n2 * w / 2
            d1, d2 = dirs[i - 1], dirs[i]
            m = np.array([[d1[0], -d2[0]], [d1[1], -d2[1]]])
            try:
                t = np.linalg.solve(m, a2 - a1)
                out.append(a1 + d1 * t[0])
            except np.linalg.LinAlgError:
                out.append(a1)
        out.append(pts[-1] + sign * normals[-1] * w / 2)
        return out

    return side(+1) + side(-1)[::-1]


# The mark: a thick zigzag on the 45° lattice (unit square, y down).
PTS = [(0.10, 0.355), (0.50, 0.015), (0.90, 0.355), (0.145, 0.665), (0.50, 0.985), (0.90, 0.645)]
WIDTH = 0.155

# Colors at each polyline vertex — the gradient flows ALONG the stroke.
VERTEX_COLORS = [
    (0xE8, 0x9F, 0x71),  # P1 left tip — peach
    (0xB9, 0xAE, 0x8C),  # P2 apex — sandy sage
    (0x5E, 0x9A, 0xB8),  # P3 right corner — steel teal
    (0xA5, 0x82, 0xB8),  # P4 lower-left corner — plum
    (0x7E, 0x8C, 0xC4),  # P5 bottom apex — blue violet
    (0x4E, 0x8E, 0xBE),  # P6 right tip — steel blue
]


def path_param_field(size, scale):
    """Per-pixel arc-length parameter t (0..1) of the nearest point on the path."""
    span = size * scale
    off = (size - span) / 2
    pts = [np.array([off + px * span, off + py * span]) for px, py in PTS]
    lens = [np.linalg.norm(b - a) for a, b in zip(pts, pts[1:])]
    total = sum(lens)
    cum = [0.0]
    for l in lens:
        cum.append(cum[-1] + l)

    y, x = np.mgrid[0:size, 0:size].astype(float)
    best_d = np.full((size, size), np.inf)
    best_t = np.zeros((size, size))
    for i, (a, b) in enumerate(zip(pts, pts[1:])):
        d = b - a
        seg_len2 = d @ d
        proj = ((x - a[0]) * d[0] + (y - a[1]) * d[1]) / seg_len2
        proj = np.clip(proj, 0.0, 1.0)
        qx = a[0] + proj * d[0]
        qy = a[1] + proj * d[1]
        dist = (x - qx) ** 2 + (y - qy) ** 2
        m = dist < best_d
        best_d[m] = dist[m]
        best_t[m] = (cum[i] + proj[m] * lens[i]) / total
    return best_t, [c / total for c in cum]


def gradient_field(size, scale):
    t, vt = path_param_field(size, scale)
    rgb = np.zeros((size, size, 3))
    for i in range(len(VERTEX_COLORS) - 1):
        t0, t1 = vt[i], vt[i + 1]
        c0, c1 = VERTEX_COLORS[i], VERTEX_COLORS[i + 1]
        m = (t >= t0) & (t <= t1)
        f = np.zeros_like(t)
        f[m] = (t[m] - t0) / (t1 - t0)
        for ch in range(3):
            rgb[..., ch][m] = c0[ch] + (c1[ch] - c0[ch]) * f[m]
    return rgb.astype(np.uint8)


def render_mark(size, scale=1.0):
    """RGBA image of the mark centered in a size×size canvas, mark spanning scale·size."""
    big = size * SS
    mask = Image.new("L", (big, big), 0)
    d = ImageDraw.Draw(mask)
    span = big * scale
    off = (big - span) / 2
    poly = [(off + px * span, off + py * span) for px, py in offset_polygon(PTS, WIDTH)]
    d.polygon(poly, fill=255)
    mask = mask.resize((size, size), Image.LANCZOS)
    rgba = np.dstack([gradient_field(size, scale), np.array(mask)])
    return Image.fromarray(rgba, "RGBA")


def on_white(img):
    bg = Image.new("RGBA", img.size, (255, 255, 255, 255))
    bg.alpha_composite(img)
    return bg.convert("RGB")


font_path = "assets/fonts/PlusJakartaSans-Variable.ttf"


def text_font(px):
    f = ImageFont.truetype(font_path, px)
    try:
        f.set_variation_by_axes([800])  # bold-ish weight on the variable font
    except Exception:
        pass
    return f


# 1) Legacy launcher icon: white square, mark at 72%.
on_white(render_mark(1024, 0.72)).save("assets/icon/app_icon.png")

# 2) Adaptive foreground: transparent, mark at 46% (safe zone is the middle 66/108).
render_mark(1024, 0.46).save("assets/icon/adaptive_foreground.png")

# 3) Play hi-res icon 512×512 (32-bit PNG).
on_white(render_mark(512, 0.72)).save("store/play_icon_512.png")

# 4) Feature graphic 1024×500: white, mark left, wordmark + tagline.
fg = Image.new("RGBA", (1024, 500), (255, 255, 255, 255))
mark = render_mark(360, 0.9)
fg.alpha_composite(mark, (86, 70))
d = ImageDraw.Draw(fg)
name_f = text_font(96)
tag_f = ImageFont.truetype(font_path, 34)
d.text((470, 168), "DocsBuddy", font=name_f, fill=(0x0F, 0x1E, 0x33))
d.text((474, 288), "Never miss a renewal again", font=tag_f, fill=(0x5A, 0x6B, 0x82))
fg.convert("RGB").save("store/feature_graphic_1024x500.png")

# 5) Splash-friendly mark on transparent, generous padding.
render_mark(1152, 0.5).save("store/splash_mark.png")

print("done")
