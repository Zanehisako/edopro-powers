#!/usr/bin/env python3
"""Generates visual card art (421x614 JPEG) for all 20 Power Cards."""
import os
import math
import shutil
from PIL import Image, ImageDraw, ImageFont

CARDS = [
    {
        "id": 42000001,
        "name": "Arcane Order",
        "cost": 1,
        "theme": "arcane",
        "bg1": (15, 30, 80),
        "bg2": (50, 120, 230),
        "accent": (100, 190, 255),
        "desc": "Power Card. Power Cost 1.\nDraw 1 card."
    },
    {
        "id": 42000002,
        "name": "Void Surge",
        "cost": 2,
        "theme": "void",
        "bg1": (45, 10, 70),
        "bg2": (140, 35, 165),
        "accent": (230, 110, 255),
        "desc": "Power Card. Power Cost 2.\nDraw 2 cards."
    },
    {
        "id": 42000003,
        "name": "Temporal Shifter",
        "cost": 3,
        "theme": "time",
        "bg1": (10, 60, 75),
        "bg2": (35, 160, 175),
        "accent": (100, 245, 235),
        "desc": "Power Card. Power Cost 3.\nGain 4000 LP."
    },
    {
        "id": 42000004,
        "name": "Solar Flare",
        "cost": 4,
        "theme": "solar",
        "bg1": (110, 30, 5),
        "bg2": (230, 120, 10),
        "accent": (255, 220, 60),
        "desc": "Power Card. Power Cost 4.\nDestroy all monsters your opponent controls."
    },
    {
        "id": 42000005,
        "name": "Mystic Tempest",
        "cost": 2,
        "theme": "tempest",
        "bg1": (10, 65, 45),
        "bg2": (40, 170, 115),
        "accent": (110, 255, 190),
        "desc": "Power Card. Power Cost 2.\nDestroy all Spell and Trap Cards your opponent controls."
    },
    {
        "id": 42000006,
        "name": "Astral Rebirth",
        "cost": 3,
        "theme": "rebirth",
        "bg1": (15, 60, 100),
        "bg2": (80, 180, 220),
        "accent": (180, 240, 255),
        "desc": "Power Card. Power Cost 3.\nTarget 1 monster in either player's GY; Special Summon it to your field."
    },
    {
        "id": 42000007,
        "name": "Aegis Barrier",
        "cost": 1,
        "theme": "aegis",
        "bg1": (90, 70, 15),
        "bg2": (210, 170, 45),
        "accent": (255, 235, 120),
        "desc": "Power Card. Power Cost 1.\nUntil the end of this turn, you take no damage, also monsters you control cannot be destroyed by battle."
    },
    {
        "id": 42000008,
        "name": "Titan's Might",
        "cost": 1,
        "theme": "might",
        "bg1": (90, 20, 15),
        "bg2": (200, 55, 40),
        "accent": (255, 140, 100),
        "desc": "Power Card. Power Cost 1.\nTarget 1 face-up monster on the field; it gains 1500 ATK until the end of this turn."
    },
    {
        "id": 42000009,
        "name": "Chrono Freeze",
        "cost": 2,
        "theme": "freeze",
        "bg1": (15, 55, 110),
        "bg2": (70, 160, 235),
        "accent": (190, 235, 255),
        "desc": "Power Card. Power Cost 2.\nTarget 1 face-up monster your opponent controls; until the end of this turn, negate its effects, also its ATK becomes 0."
    },
    {
        "id": 42000010,
        "name": "Omega Cataclysm",
        "cost": 5,
        "theme": "cataclysm",
        "bg1": (35, 0, 45),
        "bg2": (180, 20, 60),
        "accent": (255, 80, 120),
        "desc": "Power Card. Power Cost 5.\nDestroy all cards on the field, and if you do, inflict 1000 damage to your opponent."
    },
    {
        "id": 42000011,
        "name": "Dimensional Banish",
        "cost": 3,
        "theme": "banish",
        "bg1": (35, 10, 75),
        "bg2": (120, 60, 210),
        "accent": (200, 140, 255),
        "desc": "Power Card. Power Cost 3.\nTarget 1 card on the field; banish it."
    },
    {
        "id": 42000012,
        "name": "Mind Shatter",
        "cost": 4,
        "theme": "shatter",
        "bg1": (70, 10, 80),
        "bg2": (190, 35, 145),
        "accent": (255, 120, 210),
        "desc": "Power Card. Power Cost 4.\nDiscard 2 random cards from your opponent's hand."
    },
    {
        "id": 42000013,
        "name": "Summoner's Surge",
        "cost": 1,
        "theme": "surge",
        "bg1": (100, 50, 10),
        "bg2": (220, 140, 30),
        "accent": (255, 220, 90),
        "desc": "Power Card. Power Cost 1.\nYou can conduct 2 Normal Summons/Sets this turn, not just 1."
    },
    {
        "id": 42000014,
        "name": "Domain of Silence",
        "cost": 2,
        "theme": "silence",
        "bg1": (20, 15, 60),
        "bg2": (70, 50, 160),
        "accent": (160, 140, 255),
        "desc": "Power Card. Power Cost 2.\nNegate the effects of all face-up monsters your opponent currently controls until the end of this turn."
    },
    {
        "id": 42000015,
        "name": "Vanguard Assault",
        "cost": 1,
        "theme": "assault",
        "bg1": (90, 25, 20),
        "bg2": (200, 70, 40),
        "accent": (255, 170, 80),
        "desc": "Power Card. Power Cost 1.\nIf your opponent controls a monster and you control no monsters: Special Summon 1 Level 4 or lower monster from your hand or GY."
    },
    {
        "id": 42000016,
        "name": "Equilibrium Burst",
        "cost": 3,
        "theme": "equilibrium",
        "bg1": (25, 45, 85),
        "bg2": (80, 140, 210),
        "accent": (240, 220, 120),
        "desc": "Power Card. Power Cost 3.\nIf your opponent controls more cards than you do: Target 2 cards your opponent controls; destroy them, then draw 1 card."
    },
    {
        "id": 42000017,
        "name": "Tactical Mulligan",
        "cost": 1,
        "theme": "mulligan",
        "bg1": (10, 60, 55),
        "bg2": (30, 150, 140),
        "accent": (110, 245, 210),
        "desc": "Power Card. Power Cost 1.\nShuffle up to 3 cards from your hand into the Deck, then draw that same number of cards + 1."
    },
    {
        "id": 42000018,
        "name": "Gravity Singularity",
        "cost": 2,
        "theme": "singularity",
        "bg1": (25, 5, 50),
        "bg2": (90, 20, 130),
        "accent": (210, 80, 255),
        "desc": "Power Card. Power Cost 2.\nSend 1 monster your opponent controls to the GY, and if you do, inflict damage to your opponent equal to half its original ATK."
    },
    {
        "id": 42000019,
        "name": "Absolute Lockdown",
        "cost": 3,
        "theme": "lockdown",
        "bg1": (15, 45, 80),
        "bg2": (50, 120, 190),
        "accent": (140, 215, 255),
        "desc": "Power Card. Power Cost 3.\nChange all face-up monsters your opponent controls to face-down Defense Position, also their battle positions cannot be changed this turn."
    },
    {
        "id": 42000020,
        "name": "Second Wind",
        "cost": 1,
        "theme": "wind",
        "bg1": (20, 70, 35),
        "bg2": (60, 175, 90),
        "accent": (170, 255, 160),
        "desc": "Power Card. Power Cost 1.\nTarget up to 2 cards in your GY; add them to your hand."
    },
]

def draw_gradient(draw, bbox, color1, color2):
    x0, y0, x1, y1 = bbox
    height = y1 - y0
    for y in range(y0, y1):
        ratio = (y - y0) / max(1, height)
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
        draw.line([(x0, y), (x1, y)], fill=(r, g, b))

def draw_card_art(draw, bbox, card):
    x0, y0, x1, y1 = bbox
    cx = (x0 + x1) / 2
    cy = (y0 + y1) / 2
    w = x1 - x0
    h = y1 - y0

    # Base gradient background
    draw_gradient(draw, bbox, card["bg1"], card["bg2"])

    accent = card["accent"]
    theme = card["theme"]

    # Geometric power art pattern
    if theme in ("arcane", "void", "shatter", "silence", "singularity"):
        # Concentric arcane rings and starburst rays
        for r in range(20, int(min(w, h) / 2) - 10, 22):
            draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=accent, width=2)
        for i in range(12):
            angle = i * (math.pi / 6)
            rx = cx + math.cos(angle) * (w / 2 - 15)
            ry = cy + math.sin(angle) * (h / 2 - 15)
            draw.line([(cx, cy), (rx, ry)], fill=accent, width=2)
    elif theme in ("time", "freeze", "banish", "lockdown", "equilibrium"):
        # Diamond / hourglass / crystal lattice
        for r in range(15, int(min(w, h) / 2) - 10, 20):
            pts = [(cx, cy - r), (cx + r, cy), (cx, cy + r), (cx - r, cy)]
            draw.polygon(pts, outline=accent, width=2)
        draw.line([(x0 + 20, y0 + 20), (x1 - 20, y1 - 20)], fill=accent, width=2)
        draw.line([(x1 - 20, y0 + 20), (x0 + 20, y1 - 20)], fill=accent, width=2)
    elif theme in ("solar", "might", "cataclysm", "surge", "assault"):
        # Exploding rays / supernova
        for i in range(24):
            angle = i * (math.pi / 12)
            r_len = (w / 2 - 10) if i % 2 == 0 else (w / 3)
            rx = cx + math.cos(angle) * r_len
            ry = cy + math.sin(angle) * r_len
            draw.line([(cx, cy), (rx, ry)], fill=accent, width=3 if i % 2 == 0 else 1)
        draw.ellipse([cx - 35, cy - 35, cx + 35, cy + 35], fill=accent, outline=(255, 255, 255), width=2)
    else:  # tempest, rebirth, aegis, mulligan, wind
        # Hexagonal shield / spiral wave
        for r in range(20, int(min(w, h) / 2) - 10, 22):
            pts = []
            for i in range(6):
                angle = i * (math.pi / 3)
                pts.append((cx + math.cos(angle) * r, cy + math.sin(angle) * r))
            draw.polygon(pts, outline=accent, width=2)
        draw.ellipse([cx - 25, cy - 25, cx + 25, cy + 25], outline=accent, width=3)

def wrap_text(text, font, max_width):
    lines = []
    for paragraph in text.split("\n"):
        words = paragraph.split(" ")
        current_line = []
        for word in words:
            test_line = " ".join(current_line + [word])
            bbox = font.getbbox(test_line)
            if bbox[2] - bbox[0] <= max_width:
                current_line.append(word)
            else:
                if current_line:
                    lines.append(" ".join(current_line))
                current_line = [word]
        if current_line:
            lines.append(" ".join(current_line))
    return lines

def generate_card_image(card):
    WIDTH, HEIGHT = 421, 614
    img = Image.new("RGB", (WIDTH, HEIGHT), color=(28, 38, 55))
    draw = ImageDraw.Draw(img)

    # Outer metallic border
    BORDER = 18
    draw.rectangle([BORDER, BORDER, WIDTH - BORDER, HEIGHT - BORDER], outline=(190, 165, 90), width=3)
    draw.rectangle([BORDER + 4, BORDER + 4, WIDTH - BORDER - 4, HEIGHT - BORDER - 4], outline=(100, 85, 45), width=1)

    # Title Bar
    TITLE_Y0, TITLE_Y1 = BORDER + 10, BORDER + 46
    draw_gradient(draw, (BORDER + 8, TITLE_Y0, WIDTH - BORDER - 8, TITLE_Y1), (40, 50, 70), (15, 20, 30))
    draw.rectangle([BORDER + 8, TITLE_Y0, WIDTH - BORDER - 8, TITLE_Y1], outline=(210, 180, 100), width=2)

    font_path = "fonts/NotoSansJP-Regular.otf"
    title_font = ImageFont.truetype(font_path, 17) if os.path.exists(font_path) else ImageFont.load_default()
    badge_font = ImageFont.truetype(font_path, 14) if os.path.exists(font_path) else ImageFont.load_default()
    body_font = ImageFont.truetype(font_path, 13) if os.path.exists(font_path) else ImageFont.load_default()
    footer_font = ImageFont.truetype(font_path, 11) if os.path.exists(font_path) else ImageFont.load_default()

    # Draw Title text
    draw.text((BORDER + 16, TITLE_Y0 + 6), card["name"], fill=(255, 255, 255), font=title_font)

    # Draw Power Pip Cost Badge in Title
    pip_text = f"Pips: {card['cost']}"
    pip_bbox = badge_font.getbbox(pip_text)
    pip_w = pip_bbox[2] - pip_bbox[0]
    pip_x = WIDTH - BORDER - 16 - pip_w
    draw.rounded_rectangle([pip_x - 6, TITLE_Y0 + 4, pip_x + pip_w + 6, TITLE_Y1 - 4], radius=4, fill=(180, 140, 30), outline=(255, 225, 120))
    draw.text((pip_x, TITLE_Y0 + 6), pip_text, fill=(0, 0, 0), font=badge_font)

    # Art Window
    ART_Y0 = TITLE_Y1 + 10
    ART_Y1 = ART_Y0 + 260
    art_bbox = (BORDER + 12, ART_Y0, WIDTH - BORDER - 12, ART_Y1)
    draw_card_art(draw, art_bbox, card)
    draw.rectangle(art_bbox, outline=(210, 180, 100), width=2)

    # Type / Subtype Bar
    TYPE_Y0 = ART_Y1 + 8
    TYPE_Y1 = TYPE_Y0 + 24
    draw.rectangle([BORDER + 12, TYPE_Y0, WIDTH - BORDER - 12, TYPE_Y1], fill=(15, 20, 30), outline=(120, 100, 60))
    draw.text((BORDER + 18, TYPE_Y0 + 3), "[ POWER CARD / INSTANT ]", fill=(255, 215, 80), font=badge_font)

    # Description Box
    DESC_Y0 = TYPE_Y1 + 6
    DESC_Y1 = HEIGHT - BORDER - 26
    draw_gradient(draw, (BORDER + 12, DESC_Y0, WIDTH - BORDER - 12, DESC_Y1), (250, 245, 230), (225, 215, 195))
    draw.rectangle([BORDER + 12, DESC_Y0, WIDTH - BORDER - 12, DESC_Y1], outline=(150, 125, 75), width=2)

    lines = wrap_text(card["desc"], body_font, WIDTH - 2 * BORDER - 40)
    line_y = DESC_Y0 + 10
    for line in lines:
        draw.text((BORDER + 20, line_y), line, fill=(15, 15, 15), font=body_font)
        line_y += 18

    # Bottom Footer
    footer_text = f"{card['id']:08d}  © EDOPro Power Cards"
    draw.text((BORDER + 14, HEIGHT - BORDER - 18), footer_text, fill=(180, 180, 180), font=footer_font)

    return img

def main():
    os.makedirs("pics", exist_ok=True)
    os.makedirs("expansions/pics", exist_ok=True)
    for card in CARDS:
        img = generate_card_image(card)
        p1 = os.path.join("pics", f"{card['id']}.jpg")
        p2 = os.path.join("expansions/pics", f"{card['id']}.jpg")
        img.save(p1, "JPEG", quality=92)
        img.save(p2, "JPEG", quality=92)
        print(f"Generated card image: {card['id']} -> {p1}")

if __name__ == "__main__":
    main()
