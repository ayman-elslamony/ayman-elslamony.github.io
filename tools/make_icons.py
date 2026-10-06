#!/usr/bin/env python3
"""Writes every site icon from one drawing of the mark: the laptop-and-code glyph.

Run from the repo root:  python3 tools/make_icons.py

Outputs (all under web/):
  icons/icon.svg            the browser-tab icon; teal, a lighter teal in dark mode
  favicon.ico               16 and 32 px, for browsers that do not take the SVG
  icons/icon-192.png, icons/icon-512.png                    home-screen icons
  icons/icon-192-maskable.png, icons/icon-512-maskable.png  Android's shaped icons
  icons/apple-touch-icon.png                                iPhone home screen, 180 px

The images are the mark in white on a teal tile: a PNG cannot follow dark mode, and a solid
tile reads on a light and a dark home screen alike (his choice, 2026-10-06). The geometry is
the pre-boot loader's in web/index.html (a 64-unit box); change one, change the other.
Needs only Pillow.
"""
from pathlib import Path

from PIL import Image, ImageDraw

WEB = Path(__file__).resolve().parent.parent / "web"

# The site's accent: --loader-accent-light / -dark in web/styles.css.
TEAL = "#007a75"
TEAL_DARK = "#00c7be"
WHITE = "#ffffff"

# The mark, in the loader's 64-unit viewBox.
SCREEN = (14, 18, 50, 42)  # x0, y0, x1, y1
SCREEN_RADIUS = 4
STROKE = 3.5
CHEVRONS = [[(28, 27), (23, 32), (28, 37)], [(36, 27), (41, 32), (36, 37)]]
BASE = [(8, 48), (56, 48)]
BASE_STROKE = 5

SVG = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none">
  <style>
    .m {{ stroke: {TEAL}; }}
    @media (prefers-color-scheme: dark) {{ .m {{ stroke: {TEAL_DARK}; }} }}
  </style>
  <rect class="m" x="14" y="18" width="36" height="24" rx="4" stroke-width="3.5"/>
  <path class="m" d="M28 27l-5 5 5 5M36 27l5 5-5 5" stroke-width="3.5"
        stroke-linecap="round" stroke-linejoin="round"/>
  <path class="m" d="M8 48h48" stroke-width="5" stroke-linecap="round"/>
</svg>
"""

SUPERSAMPLE = 8


def _round_line(draw, points, width, color):
    """A polyline with round caps and joins, as SVG's stroke-linecap/linejoin: round."""
    draw.line(points, fill=color, width=round(width), joint="curve")
    r = width / 2
    for x, y in points:
        draw.ellipse((x - r, y - r, x + r, y + r), fill=color)


def draw_mark(draw, origin, scale, color):
    """The mark, its 64-unit box placed at [origin] and scaled by [scale]."""
    ox, oy = origin

    def p(x, y):
        return (ox + x * scale, oy + y * scale)

    x0, y0, x1, y1 = SCREEN
    draw.rounded_rectangle(
        (*p(x0, y0), *p(x1, y1)),
        radius=SCREEN_RADIUS * scale,
        outline=color,
        width=round(STROKE * scale),
    )
    for chevron in CHEVRONS:
        _round_line(draw, [p(*pt) for pt in chevron], STROKE * scale, color)
    _round_line(draw, [p(*pt) for pt in BASE], BASE_STROKE * scale, color)


def tile(size, *, mark_share, corner_share):
    """A [size] px teal tile with the white mark filling [mark_share] of its width.

    [corner_share] rounds the tile's corners (0 = square, for icons the platform masks
    itself)."""
    big = size * SUPERSAMPLE
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((0, 0, big - 1, big - 1), radius=big * corner_share, fill=TEAL)
    # The mark spans x 8..56 of its 64-unit box (48 units); centre that span.
    scale = big * mark_share / 48
    mark_w, mark_h = 48 * scale, 30 * scale  # y 18..48
    origin = ((big - mark_w) / 2 - 8 * scale, (big - mark_h) / 2 - 18 * scale)
    draw_mark(draw, origin, scale, WHITE)
    return img.resize((size, size), Image.LANCZOS)


def main():
    icons = WEB / "icons"
    (icons / "icon.svg").write_text(SVG)
    for size in (192, 512):
        # "any": a rounded tile, the mark at 62 % of the width.
        tile(size, mark_share=0.62, corner_share=0.22).save(icons / f"icon-{size}.png")
        # "maskable": full bleed, the mark inside the central 80 % safe circle.
        tile(size, mark_share=0.5, corner_share=0).save(icons / f"icon-{size}-maskable.png")
    # iOS rounds the corners itself and shows transparency as black: full bleed, opaque.
    tile(180, mark_share=0.58, corner_share=0).convert("RGB").save(
        icons / "apple-touch-icon.png"
    )
    # Tab-sized: a bigger mark, or it is a smudge at 16 px.
    ico = tile(32, mark_share=0.72, corner_share=0.18)
    ico.save(WEB / "favicon.ico", sizes=[(16, 16), (32, 32)])
    print("wrote icon.svg, favicon.ico, icon-192/512(-maskable).png, apple-touch-icon.png")


if __name__ == "__main__":
    main()
