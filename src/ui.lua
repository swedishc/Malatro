local constants = require("src.constants")

local ui = {}

local function computeScale()
  local windowWidth, windowHeight = love.graphics.getDimensions()
  local sx = math.floor(windowWidth / constants.BASE_WIDTH)
  local sy = math.floor(windowHeight / constants.BASE_HEIGHT)
  return math.max(1, math.min(sx, sy))
end

function ui.new()
  local canvas = love.graphics.newCanvas(constants.BASE_WIDTH, constants.BASE_HEIGHT)
  return {
    canvas = canvas,
    scale = computeScale(),
    resize = function(self)
      self.scale = computeScale()
    end,
    drawToScreen = function(self, drawFn)
      love.graphics.setCanvas(self.canvas)
      love.graphics.clear(0.07, 0.09, 0.1, 1)
      drawFn()
      love.graphics.setCanvas()
      local scale = self.scale
      local w, h = constants.BASE_WIDTH * scale, constants.BASE_HEIGHT * scale
      local ox = math.floor((love.graphics.getWidth() - w) / 2)
      local oy = math.floor((love.graphics.getHeight() - h) / 2)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.canvas, ox, oy, 0, scale, scale)
    end
  }
end

function ui.drawPanel(x, y, w, h)
  love.graphics.setColor(0.09, 0.11, 0.14)
  love.graphics.rectangle("fill", x, y, w, h, 2)
  love.graphics.setColor(0.3, 0.35, 0.4)
  love.graphics.rectangle("line", x + 1, y + 1, w - 2, h - 2, 2)
  love.graphics.setColor(1, 1, 1)
end

function ui.drawCard(card, x, y, selected)
  local offset = selected and 2 or 0
  love.graphics.setColor(0.95, 0.95, 0.92)
  love.graphics.rectangle("fill", x, y - offset, constants.CARD_WIDTH, constants.CARD_HEIGHT, 2)
  love.graphics.setColor(0.1, 0.1, 0.1)
  love.graphics.rectangle("line", x, y - offset, constants.CARD_WIDTH, constants.CARD_HEIGHT, 2)
  love.graphics.print(card.rank, x + 4, y - offset + 4)
  love.graphics.print(card.suit, x + 4, y - offset + 18)
end

return ui
