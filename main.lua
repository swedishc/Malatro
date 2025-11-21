love.graphics.setDefaultFilter("nearest", "nearest")

local constants = require("src.constants")
local ui = require("src.ui")

local gameModule = require("src.game")

local app = {
  ui = nil,
  game = nil,
  font = nil,
  smallFont = nil,

local function drawHand()
  local padding = constants.PADDING
  local startX = padding
  local y = constants.BASE_HEIGHT - constants.CARD_HEIGHT - padding
  for i, c in ipairs(app.game.state.hand) do
    local x = startX + (i - 1) * (constants.CARD_WIDTH + constants.CARD_SPACING)

  end
end

local function drawHUD()
  local state = app.game.state
  ui.drawPanel(constants.PADDING, constants.PADDING, constants.BASE_WIDTH - constants.PADDING * 2, 64)
  love.graphics.setFont(app.font)
  love.graphics.print("Ante " .. state.ante, constants.PADDING * 2, constants.PADDING * 2)
  love.graphics.print(constants.BLINDS[state.blindIndex].name, constants.PADDING * 2, constants.PADDING * 2 + 18)
  love.graphics.print("Target: " .. (constants.BLINDS[state.blindIndex].target + (state.ante - 1) * 200), constants.PADDING * 2 + 120, constants.PADDING * 2)
  love.graphics.print("Score: " .. state.score, constants.PADDING * 2 + 120, constants.PADDING * 2 + 18)
  love.graphics.print(string.format("Plays %d  Discards %d", state.playsLeft, state.discardsLeft), constants.PADDING * 2 + 300, constants.PADDING * 2)
  love.graphics.print("Wallet $" .. state.wallet, constants.PADDING * 2 + 300, constants.PADDING * 2 + 18)

  if state.lastHand then
    love.graphics.print("Last: " .. state.lastHand.label, constants.PADDING * 2 + 480, constants.PADDING * 2)
  end
end

local function drawMessage()
  love.graphics.setFont(app.smallFont)
  love.graphics.print(app.game.state.message, constants.PADDING * 2, constants.BASE_HEIGHT - constants.PADDING * 3)
end

local function drawControls()
  local y = constants.BASE_HEIGHT - constants.CARD_HEIGHT - constants.PADDING - 32
  love.graphics.setFont(app.smallFont)
  love.graphics.print("Click cards to select. Space = Play, D = Discard, N = Next Blind, R = Reset", constants.PADDING * 2, y)
end

local function draw()
  drawHUD()
  drawControls()
  drawHand()
  drawMessage()
end

function love.load()
  app.ui = ui.new()
  app.font = love.graphics.newFont(12)
  app.smallFont = love.graphics.newFont(10)
  love.graphics.setFont(app.font)

function love.resize()
  app.ui:resize()
end

function love.mousepressed(x, y, button)
  if button ~= 1 then
    return
  end
  local scale = app.ui.scale
  local ox = (love.graphics.getWidth() - constants.BASE_WIDTH * scale) / 2
  local oy = (love.graphics.getHeight() - constants.BASE_HEIGHT * scale) / 2
  x = (x - ox) / scale
  y = (y - oy) / scale

  local startX = constants.PADDING
  local cardY = constants.BASE_HEIGHT - constants.CARD_HEIGHT - constants.PADDING
  for i, c in ipairs(app.game.state.hand) do
    local cx = startX + (i - 1) * (constants.CARD_WIDTH + constants.CARD_SPACING)
    if x >= cx and x <= cx + constants.CARD_WIDTH and y >= cardY and y <= cardY + constants.CARD_HEIGHT then
      app.game:toggleSelect(i)
      break
    end
  end
end

function love.keypressed(key)
  if key == "space" then
    app.game:playHand()
  elseif key == "d" then
    app.game:discard()
  elseif key == "n" then
    app.game:nextBlind()
  elseif key == "r" then
    app.game:reset()
  end
end

function love.draw()
  app.ui:drawToScreen(draw)
end
