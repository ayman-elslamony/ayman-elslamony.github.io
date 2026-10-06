#!/usr/bin/env python3
"""Regenerate the images that are NOT screenshots.

Two project cards have no real screenshot, and the site's link-preview card does not exist
as a design anywhere - so all three are generated here. Run from the repository root:

    python3 tools/make_banners.py

This script is committed on purpose. These images were generated twice from throwaway
heredocs, which meant that re-theming the site meant re-deriving every value from scratch.

Every colour below is copied from lib/src/constants/themes.dart, which in turn takes Apple's
published UIColor values from Flutter's own cupertino/colors.dart. If the theme changes,
change it here too - a PNG cannot follow a Dart theme, and that is exactly why these three
files went stale the last time.
"""

import glob
import subprocess
import tempfile

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = "."
BOLD = f"{ROOT}/assets/fonts/Nunito-Bold.ttf"
REGULAR = f"{ROOT}/assets/fonts/Nunito-Regular.ttf"

# --- theme values, copied from lib/src/constants/themes.dart -------------------------
LIGHT_SURFACE = (0xFF, 0xFF, 0xFF)       # systemBackground
LIGHT_SCAFFOLD = (0xF2, 0xF2, 0xF7)      # systemGroupedBackground
LIGHT_ON_SURFACE = (0x00, 0x00, 0x00)    # label
LIGHT_PRIMARY = (0x00, 0x7A, 0x75)       # systemMint, darkened for 4.5:1 on paper
LIGHT_SECONDARY = (0x3C, 0x3C, 0x43)     # secondaryLabel, opaque

# Project banners are 1024x500 because all 16 real screenshots are, and ProjectImage draws
# with BoxFit.fill - which stretches rather than fits, so any other ratio visibly distorts.
CARD = (1024, 500)
# The link-preview card is 1200x630, the Open Graph standard. Unrelated to the size above.
OG = (1200, 630)


def vertical_gradient(size, top, bottom):
    img = Image.new("RGB", size, top)
    draw = ImageDraw.Draw(img)
    h = size[1]
    for y in range(h):
        t = y / max(h - 1, 1)
        draw.line(
            [(0, y), (size[0], y)],
            fill=tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3)),
        )
    return img


def centered(draw, y, text, font, fill, width):
    w = draw.textbbox((0, 0), text, font=font)[2]
    draw.text(((width - w) / 2, y), text, font=font, fill=fill)


def light_card(path, size, title, subtitle, detail, sizes):
    """Every generated image is light.

    The two project banners are light because the complaint about the first pair was that
    they were dark slabs sitting between 16 light screenshots. The link-preview card was
    dark for one round - it never appears beside the screenshots - and the owner asked for
    it light as well, so there is now one recipe and no second palette to keep in step.
    """
    title_pt, sub_pt, detail_pt = sizes
    img = vertical_gradient(size, LIGHT_SURFACE, LIGHT_SCAFFOLD)
    d = ImageDraw.Draw(img)
    w, h = size
    top = h // 2 - title_pt - 20
    centered(d, top, title, ImageFont.truetype(BOLD, title_pt), LIGHT_ON_SURFACE, w)
    centered(d, top + title_pt + 24, subtitle,
             ImageFont.truetype(REGULAR, sub_pt), LIGHT_SECONDARY, w)
    centered(d, top + title_pt + sub_pt + 62, detail,
             ImageFont.truetype(REGULAR, detail_pt), LIGHT_PRIMARY, w)
    # A light card on a light page needs an edge, or it dissolves into whatever is behind.
    d.rectangle([0, h - 4, w, h], fill=LIGHT_PRIMARY)
    img.save(path)
    print(f"  {path}  {img.size}")


def cv_card(path, size):
    """The link-preview card of /cv: the CV's real first page beside the title.

    Beside the portfolio's card on LinkedIn the two must differ at a glance, so this one
    shows a page - the thing it links to. The page is rendered from the PDF the site
    serves (web/cv/*.pdf) with poppler's pdftoppm; rerun after the CV changes.
    """
    pdf = sorted(glob.glob(f"{ROOT}/web/cv/*.pdf"))[-1]
    with tempfile.TemporaryDirectory() as tmp:
        subprocess.run(["pdftoppm", "-f", "1", "-l", "1", "-r", "110", "-png", pdf,
                        f"{tmp}/p"], check=True)
        page = Image.open(sorted(glob.glob(f"{tmp}/p*.png"))[0]).convert("RGB")
    img = vertical_gradient(size, LIGHT_SURFACE, LIGHT_SCAFFOLD)
    w, h = size
    page_h = h - 120
    page = page.resize((round(page.width * page_h / page.height), page_h), Image.LANCZOS)
    x, y = 90, 52
    # A soft shadow, so the white sheet stands off the near-white card.
    shadow = Image.new("RGBA", size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rectangle([x + 6, y + 10, x + page.width + 6, y + page_h + 10],
                                     fill=(0, 0, 0, 60))
    img = Image.alpha_composite(img.convert("RGBA"), shadow.filter(ImageFilter.GaussianBlur(14)))
    img.paste(page, (x, y))
    d = ImageDraw.Draw(img)
    d.rectangle([x, y, x + page.width, y + page_h], outline=(0xD1, 0xD1, 0xD6), width=2)
    left = x + page.width + 70
    d.text((left, 196), "Ayman Elslamony", font=ImageFont.truetype(BOLD, 60), fill=LIGHT_ON_SURFACE)
    d.text((left, 282), "Senior Flutter Developer", font=ImageFont.truetype(REGULAR, 32),
           fill=LIGHT_SECONDARY)
    pill_font = ImageFont.truetype(BOLD, 28)
    label = "Download CV  ·  PDF"
    tw = d.textbbox((0, 0), label, font=pill_font)[2]
    d.rounded_rectangle([left, 360, left + tw + 48, 416], radius=28, fill=LIGHT_PRIMARY)
    d.text((left + 24, 368), label, font=pill_font, fill=LIGHT_SURFACE)
    d.rectangle([0, h - 4, w, h], fill=LIGHT_PRIMARY)
    img.convert("RGB").save(path)
    print(f"  {path}  {img.size}")


if __name__ == "__main__":
    print("regenerating:")
    light_card(
        f"{ROOT}/assets/images/shared_architecture.png",
        CARD,
        "Shared Flutter Architecture",
        "Core package  ·  copy-in scaffold  ·  internal toolchain",
        "One fix reaches every app  ·  reviewed upgrades",
        (52, 26, 21),
    )
    light_card(
        f"{ROOT}/assets/images/network_inspector.png",
        CARD,
        "Network Inspector & Runtime Config",
        "Backend-vs-frontend triage  ·  cURL export  ·  runtime switching",
        "Dio + HTTP adapters  ·  separate entrypoints  ·  tree-shakeable",
        (52, 26, 21),
    )
    light_card(
        f"{ROOT}/web/og-image.png",
        OG,
        "Ayman Elslamony",
        "Senior Flutter Developer",
        "18+ Apps Shipped  ·  Clean Architecture  ·  CI/CD",
        (66, 32, 26),
    )
    cv_card(f"{ROOT}/web/og-cv.png", OG)
