from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

CARD_SIZE = (40, 56)
RANK_FONT_SIZE = 12
SUIT_FONT_SIZE = 12
BACKGROUND = (234, 236, 241, 255)
OUTLINE = (28, 36, 48, 255)
RED = (212, 83, 71, 255)
BLUE = (82, 126, 182, 255)
DARK = (26, 31, 44, 255)

SUITS = {
    "spades": "♠",
    "hearts": "♥",
    "diamonds": "♦",
    "clubs": "♣",
}
RANKS = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

OUTPUT = Path(__file__).resolve().parents[1] / "assets" / "cards"
OUTPUT.mkdir(parents=True, exist_ok=True)

try:
    FONT = ImageFont.truetype("DejaVuSans-Bold.ttf", RANK_FONT_SIZE)
    SUIT_FONT = ImageFont.truetype("DejaVuSans-Bold.ttf", SUIT_FONT_SIZE)
except OSError:
    FONT = ImageFont.load_default()
    SUIT_FONT = ImageFont.load_default()


def draw_base():
    img = Image.new("RGBA", CARD_SIZE, BACKGROUND)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, CARD_SIZE[0] - 1, CARD_SIZE[1] - 1], outline=OUTLINE)
    d.rectangle([1, 1, CARD_SIZE[0] - 2, CARD_SIZE[1] - 2], outline=OUTLINE)
    return img


def place_text(draw, text, font, xy, fill):
    w, h = draw.textsize(text, font=font)
    draw.text((xy[0] - w // 2, xy[1]), text, fill=fill, font=font)


def render_card(rank, suit_name, glyph):
    color = RED if suit_name in {"hearts", "diamonds"} else DARK
    img = draw_base()
    d = ImageDraw.Draw(img)
    d.rectangle([4, 4, CARD_SIZE[0] - 5, CARD_SIZE[1] - 5], outline=(200, 204, 212, 255))
    place_text(d, rank, FONT, (CARD_SIZE[0] // 2, 6), fill=color)
    place_text(d, glyph, SUIT_FONT, (CARD_SIZE[0] // 2, 22), fill=color)
    # center pip cluster
    d.text((CARD_SIZE[0] // 2 - SUIT_FONT_SIZE // 2, CARD_SIZE[1] // 2 - SUIT_FONT_SIZE), glyph, fill=color, font=SUIT_FONT)
    d.text((CARD_SIZE[0] // 2 - SUIT_FONT_SIZE // 2 - 6, CARD_SIZE[1] // 2), glyph, fill=color, font=SUIT_FONT)
    d.text((CARD_SIZE[0] // 2 - SUIT_FONT_SIZE // 2 + 6, CARD_SIZE[1] // 2), glyph, fill=color, font=SUIT_FONT)
    filename = OUTPUT / f"{rank}_{suit_name}.png"
    img.save(filename)


def render_joker(label, index):
    img = draw_base()
    d = ImageDraw.Draw(img)
    place_text(d, "Joker", FONT, (CARD_SIZE[0] // 2, 6), fill=BLUE)
    d.rectangle([6, 18, CARD_SIZE[0] - 7, CARD_SIZE[1] - 8], outline=BLUE, width=2)
    place_text(d, label, FONT, (CARD_SIZE[0] // 2, CARD_SIZE[1] // 2 - 8), fill=BLUE)
    place_text(d, str(index), FONT, (CARD_SIZE[0] // 2, CARD_SIZE[1] - 18), fill=BLUE)
    img.save(OUTPUT / f"joker_{index}.png")


def render_back():
    img = Image.new("RGBA", CARD_SIZE, (28, 36, 48, 255))
    d = ImageDraw.Draw(img)
    d.rectangle([3, 3, CARD_SIZE[0] - 4, CARD_SIZE[1] - 4], outline=(118, 178, 224, 255), width=2)
    d.rectangle([6, 6, CARD_SIZE[0] - 7, CARD_SIZE[1] - 7], outline=(190, 225, 255, 255))
    d.text((CARD_SIZE[0] // 2 - 10, CARD_SIZE[1] // 2 - 6), "BAL", fill=(190, 225, 255, 255), font=FONT)
    img.save(OUTPUT / "back.png")


def main():
    for suit_name, glyph in SUITS.items():
        for rank in RANKS:
            render_card(rank, suit_name, glyph)
    render_joker("J", 1)
    render_joker("J", 2)
    render_back()


if __name__ == "__main__":
    main()
