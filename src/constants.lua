local constants = {}

constants.BASE_WIDTH = 640
constants.BASE_HEIGHT = 360
constants.PADDING = 8
constants.CARD_WIDTH = 40
constants.CARD_HEIGHT = 56
constants.CARD_SPACING = 6
constants.HAND_SIZE = 8
constants.PLAY_LIMIT = 5
constants.DISCARD_LIMIT = 3

constants.BLINDS = {
  { name = "Small Blind", target = 300 },
  { name = "Big Blind", target = 600 },
  { name = "Boss Blind", target = 900 },
}

constants.MAX_ANTES = 4

constants.POKER_HANDS = {
  { id = "high_card", label = "High Card", chips = 10, mult = 1 },
  { id = "pair", label = "Pair", chips = 20, mult = 2 },
  { id = "two_pair", label = "Two Pair", chips = 30, mult = 2 },
  { id = "three_kind", label = "Three of a Kind", chips = 40, mult = 3 },
  { id = "straight", label = "Straight", chips = 50, mult = 4 },
  { id = "flush", label = "Flush", chips = 60, mult = 4 },
  { id = "full_house", label = "Full House", chips = 70, mult = 4 },
  { id = "four_kind", label = "Four of a Kind", chips = 100, mult = 5 },
  { id = "straight_flush", label = "Straight Flush", chips = 120, mult = 6 },
}

return constants
