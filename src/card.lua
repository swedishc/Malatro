local card = {}

local suits = { "♠", "♥", "♦", "♣" }
local ranks = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

function card.buildDeck()
  local deck = {}
  for _, suit in ipairs(suits) do
    for value, rank in ipairs(ranks) do
      table.insert(deck, { suit = suit, rank = rank, value = value, selected = false })
    end
  end
  return deck
end

function card.copyCard(src)
  return { suit = src.suit, rank = src.rank, value = src.value, selected = false }
end

function card.label(c)
  return c.rank .. c.suit
end

return card
