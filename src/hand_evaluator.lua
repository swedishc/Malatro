local constants = require("src.constants")

local evaluator = {}

local function countRanks(cards)
  local count = {}
  for _, c in ipairs(cards) do
    count[c.rank] = (count[c.rank] or 0) + 1
  end
  return count
end

local function countSuits(cards)
  local count = {}
  for _, c in ipairs(cards) do
    count[c.suit] = (count[c.suit] or 0) + 1
  end
  return count
end

local function isStraight(cards)
  local values = {}
  for _, c in ipairs(cards) do
    table.insert(values, c.value)
  end
  table.sort(values)
  -- Handle wheel straight
  local wheel = {1, 2, 3, 4, 5}
  local isWheel = true
  for i, v in ipairs(values) do
    if wheel[i] ~= v then
      isWheel = false
      break
    end
  end
  if isWheel then
    return true
  end
  for i = 2, #values do
    if values[i] ~= values[i - 1] + 1 then
      return false
    end
  end
  return true
end

local function isFlush(cards)
  local suit = cards[1].suit
  for i = 2, #cards do
    if cards[i].suit ~= suit then
      return false
    end
  end
  return true
end

local function bestHand(cards)
  if #cards ~= 5 then
    return constants.POKER_HANDS[1]
  end
  local rankCounts = countRanks(cards)
  local suitCounts = countSuits(cards)
  local flush = isFlush(cards)
  local straight = isStraight(cards)

  if straight and flush then
    return constants.POKER_HANDS[9]
  end


  for _, v in pairs(rankCounts) do
    if v == 4 then
      return constants.POKER_HANDS[8]
    elseif v == 3 then
      three = true
    elseif v == 2 then

    return constants.POKER_HANDS[7]
  elseif flush then
    return constants.POKER_HANDS[6]
  elseif straight then
    return constants.POKER_HANDS[5]
  elseif three then
    return constants.POKER_HANDS[4]

    return constants.POKER_HANDS[2]
  else
    return constants.POKER_HANDS[1]
  end
end

evaluator.evaluate = bestHand

return evaluator
