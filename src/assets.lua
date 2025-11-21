local constants = require("src.constants")

local assets = {}

local suits = {
  ["♠"] = { key = "spades", color = { 0.12, 0.15, 0.2 } },
  ["♣"] = { key = "clubs", color = { 0.12, 0.15, 0.2 } },
  ["♥"] = { key = "hearts", color = { 0.82, 0.24, 0.2 } },
  ["♦"] = { key = "diamonds", color = { 0.82, 0.24, 0.2 } },
}

local ranks = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

local function pushCanvas(canvas)
  local previous = love.graphics.getCanvas()
  love.graphics.setCanvas(canvas)
  return previous
end

local function popCanvas(previous)
  love.graphics.setCanvas(previous)
end

local function drawCardFace(rank, suitSymbol, font, pipFont)
  love.graphics.clear(0.92, 0.94, 0.95, 0)
  love.graphics.setColor(0.92, 0.94, 0.95, 1)
  love.graphics.rectangle("fill", 0, 0, constants.CARD_WIDTH, constants.CARD_HEIGHT, 3)
  love.graphics.setColor(0.12, 0.15, 0.2, 1)
  love.graphics.rectangle("line", 0.5, 0.5, constants.CARD_WIDTH - 1, constants.CARD_HEIGHT - 1, 3)
  love.graphics.setColor(0.76, 0.8, 0.84, 1)
  love.graphics.rectangle("line", 2, 2, constants.CARD_WIDTH - 4, constants.CARD_HEIGHT - 4, 3)

  local suit = suits[suitSymbol]
  love.graphics.setFont(font)
  love.graphics.setColor(suit.color)
  love.graphics.printf(rank, 4, 4, constants.CARD_WIDTH - 8, "left")
  love.graphics.setFont(pipFont)
  love.graphics.printf(suitSymbol, 4, 18, constants.CARD_WIDTH - 8, "left")

  local centerY = constants.CARD_HEIGHT / 2
  local centerX = constants.CARD_WIDTH / 2
  love.graphics.printf(suitSymbol, centerX - 8, centerY - 12, 16, "center")
  love.graphics.printf(suitSymbol, centerX - 18, centerY, 16, "center")
  love.graphics.printf(suitSymbol, centerX + 2, centerY, 16, "center")
end

local function drawJoker(label, font)
  love.graphics.clear(0.92, 0.94, 0.95, 0)
  love.graphics.setColor(0.92, 0.94, 0.95, 1)
  love.graphics.rectangle("fill", 0, 0, constants.CARD_WIDTH, constants.CARD_HEIGHT, 3)
  love.graphics.setColor(0.26, 0.32, 0.44, 1)
  love.graphics.rectangle("line", 1, 1, constants.CARD_WIDTH - 2, constants.CARD_HEIGHT - 2, 3)
  love.graphics.setColor(0.39, 0.62, 0.84, 1)
  love.graphics.rectangle("line", 3, 3, constants.CARD_WIDTH - 6, constants.CARD_HEIGHT - 6, 3)
  love.graphics.setFont(font)
  love.graphics.printf("JOKER", 0, 6, constants.CARD_WIDTH, "center")
  love.graphics.printf(label, 0, constants.CARD_HEIGHT / 2 - 6, constants.CARD_WIDTH, "center")
end

local function drawBack()
  love.graphics.clear(0.16, 0.22, 0.28, 0)
  love.graphics.setColor(0.16, 0.22, 0.28, 1)
  love.graphics.rectangle("fill", 0, 0, constants.CARD_WIDTH, constants.CARD_HEIGHT, 3)
  love.graphics.setColor(0.46, 0.7, 0.88, 1)
  love.graphics.rectangle("line", 2, 2, constants.CARD_WIDTH - 4, constants.CARD_HEIGHT - 4, 3)
  love.graphics.setColor(0.74, 0.88, 1, 1)
  love.graphics.rectangle("line", 5, 5, constants.CARD_WIDTH - 10, constants.CARD_HEIGHT - 10, 3)
  love.graphics.setFont(love.graphics.newFont(12))
  love.graphics.printf("BAL", 0, constants.CARD_HEIGHT / 2 - 8, constants.CARD_WIDTH, "center")
end

function assets.new()
  local cardImages = {}
  local font = love.graphics.newFont(12)
  local pipFont = love.graphics.newFont(12)
  for _, rank in ipairs(ranks) do
    for symbol in pairs(suits) do
      local canvas = love.graphics.newCanvas(constants.CARD_WIDTH, constants.CARD_HEIGHT)
      local previous = pushCanvas(canvas)
      drawCardFace(rank, symbol, font, pipFont)
      popCanvas(previous)
      cardImages[rank .. symbol] = love.graphics.newImage(canvas:newImageData())
    end
  end

  local jokerCanvas = love.graphics.newCanvas(constants.CARD_WIDTH, constants.CARD_HEIGHT)
  local prev = pushCanvas(jokerCanvas)
  drawJoker("Classic", font)
  popCanvas(prev)

  local backCanvas = love.graphics.newCanvas(constants.CARD_WIDTH, constants.CARD_HEIGHT)
  prev = pushCanvas(backCanvas)
  drawBack()
  popCanvas(prev)

  return {
    cards = cardImages,
    joker = love.graphics.newImage(jokerCanvas:newImageData()),
    back = love.graphics.newImage(backCanvas:newImageData()),
  }
end

function assets.getKey(card)
  if not card then
    return nil
  end
  return card.rank .. card.suit
end

return assets
