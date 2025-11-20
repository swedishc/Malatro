local constants = require("src.constants")
local deck = require("src.deck")
local card = require("src.card")
local evaluator = require("src.hand_evaluator")

local game = {}

local function initState()
  local state = {
    ante = 1,
    blindIndex = 1,
    deck = deck.new(),
    hand = {},
    discardPile = {},
    score = 0,
    wallet = 0,
    playsLeft = constants.PLAY_LIMIT,
    discardsLeft = constants.DISCARD_LIMIT,
    message = "",
    lastHand = nil,
  }
  for i = 1, constants.HAND_SIZE do
    table.insert(state.hand, deck.draw(state.deck))
  end
  return state
end

local function refillHand(state)
  while #state.hand < constants.HAND_SIZE do
    if #state.deck == 0 then
      -- reshuffle discards
      for i = #state.discardPile, 1, -1 do
        table.insert(state.deck, card.copyCard(state.discardPile[i]))
        table.remove(state.discardPile, i)
      end
      deck.shuffle(state.deck)
    end
    table.insert(state.hand, deck.draw(state.deck))
  end
end

local function resetRound(state)
  state.playsLeft = constants.PLAY_LIMIT
  state.discardsLeft = constants.DISCARD_LIMIT
  state.message = ""
  state.lastHand = nil
  state.deck = deck.new()
  state.hand = {}
  state.discardPile = {}
  refillHand(state)
end

local function advanceBlind(state)
  state.blindIndex = state.blindIndex + 1
  if state.blindIndex > #constants.BLINDS then
    state.blindIndex = 1
    state.ante = state.ante + 1
  end
  resetRound(state)
end

local function calcScore(handData)
  return handData.chips * handData.mult
end

local function settleWin(state)
  local target = constants.BLINDS[state.blindIndex].target + (state.ante - 1) * 200
  if state.score >= target then
    state.wallet = state.wallet + 5
    advanceBlind(state)
    state.message = "Blind cleared! +$5"
    state.score = 0
  end
end

local function evaluatePlay(state, selected)
  if #selected ~= 5 then
    state.message = "Select exactly 5 cards"
    return
  end
  if state.playsLeft <= 0 then
    state.message = "No plays left"
    return
  end

  local handData = evaluator.evaluate(selected)
  local gained = calcScore(handData)
  state.score = state.score + gained
  state.lastHand = handData
  state.message = string.format("%s  +%d chips  x%d mult", handData.label, handData.chips, handData.mult)

  -- Remove played cards
  for _, cardObj in ipairs(selected) do
    for i = #state.hand, 1, -1 do
      if state.hand[i] == cardObj then
        table.remove(state.hand, i)
        break
      end
    end
  end

  state.playsLeft = state.playsLeft - 1
  refillHand(state)
  settleWin(state)
end

local function discardSelected(state, selected)
  if #selected == 0 then
    state.message = "Select cards to discard"
    return
  end
  if state.discardsLeft <= 0 then
    state.message = "No discards left"
    return
  end
  for _, cardObj in ipairs(selected) do
    for i = #state.hand, 1, -1 do
      if state.hand[i] == cardObj then
        table.insert(state.discardPile, table.remove(state.hand, i))
        break
      end
    end
  end
  state.discardsLeft = state.discardsLeft - 1
  state.message = string.format("Discarded %d cards", #selected)
  refillHand(state)
end

function game.new()
  local state = initState()

  return {
    state = state,
    toggleSelect = function(self, index)
      local c = self.state.hand[index]
      if c then
        c.selected = not c.selected
      end
    end,
    playHand = function(self)
      local selected = {}
      for _, c in ipairs(self.state.hand) do
        if c.selected then
          table.insert(selected, c)
        end
      end
      if #selected > constants.PLAY_LIMIT then
        self.state.message = "Too many cards"
        return
      end
      evaluatePlay(self.state, selected)
      for _, c in ipairs(self.state.hand) do
        c.selected = false
      end
    end,
    discard = function(self)
      local selected = {}
      for _, c in ipairs(self.state.hand) do
        if c.selected then
          table.insert(selected, c)
        end
      end
      discardSelected(self.state, selected)
      for _, c in ipairs(self.state.hand) do
        c.selected = false
      end
    end,
    nextBlind = function(self)
      advanceBlind(self.state)
    end,
    reset = function(self)
      self.state = initState()
    end
  }
end

return game
