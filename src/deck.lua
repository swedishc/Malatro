local card = require("src.card")

local deck = {}

local function shuffle(cards)
  for i = #cards, 2, -1 do
    local j = love.math.random(i)
    cards[i], cards[j] = cards[j], cards[i]
  end
end

deck.shuffle = shuffle

function deck.new()
  local instance = card.buildDeck()
  shuffle(instance)
  return instance
end

function deck.draw(cards)
  return table.remove(cards)
end

return deck
