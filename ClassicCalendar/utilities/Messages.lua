local ClassicCalendar, NS = ...

-- Key conversion tables for encoding
SHORTHAND_TO_KEY_MAPPING = {
  i="id",
  t="title",
  d="description",
  st="startTime",
  et="endTime",
  min="minLevel",
  max="maxLevel",
  num="numPlayers",
  a="attendees",
  u="updatedAt",
  l="level",
  n="name",
  c="class",
  chg="changeAction",
}

KEY_TO_SHORTHAND_MAPPING = {
  id="i",
  title="t",
  description="d",
  startTime="st",
  endTime="et",
  minLevel="min",
  maxLevel="max",
  numPlayers="num",
  attendees="a",
  updatedAt="u",
  name="n",
  level="l",
  class="c",
  changeAction="chg",
}

-- Change actions
ADD_RSVP = "AR"
REMOVE_RSVP = "RR"
ADD_LISTING = "AL"
DELETE_LISTING = "DL"

-- Given a table, encode to a string
function encodeOutgoingMessage(toEncode)
  local msg = ""

  for key, value in pairs(toEncode) do
    msg = msg .. KEY_TO_SHORTHAND_MAPPING[key] .. ":" .. value .. ","
  end

  return msg
end

-- Given a string message, output the corresponding table
function decodeIncomingMessage(msg)
  tempParsedMessage = {}
  decodedTable = {}

  -- Split the message into "words" - the %w+ is a lua matcher for alphanumeric characters
  -- See: http://www.lua.org/pil/20.2.html for the docs on this

  -- Note that this assumes the structure is entirely k-v pairs
  -- This will not work for nested tables (rsvps for example)
  for word in msg:gmatch("%w+") do
    table.insert(tempParsedMessage, word)
  end

  -- Now, tempParsedMessage is a table that is "array-like".
  -- Create actual key-value pairs to store in decodedTable
  for i=1, table.maxn(tempParsedMessage), 2 do
    local shortHandKey = tempParsedMessage[i]
    local value = tempParsedMessage[i+1]
    local key = SHORTHAND_TO_KEY_MAPPING[shortHandKey]

    decodedTable[key] = value
  end

  return decodedTable
end