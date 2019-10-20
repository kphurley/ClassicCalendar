local ClassicCalendar, ClassicCalendarNS = ...

-- Chat message prefixes
ClassicCalendarNS.CLASSIC_CALENDAR_SYNC = "CLASSIC_CALENDAR_SYNC"
ClassicCalendarNS.CLASSIC_CALENDAR_CHANGE = "CLASSIC_CALENDAR_CHANGE"

-- This is here to save space, since we can only send 250 characters over the wire
local MESSAGE_KEY_MAPPING = {
  -- t="type", (TODO)
  i="id",
  d="description",
  st="startTime",
  et="endTime",
  min="minLevel",
  max="maxLevel",
  n="numPlayers",
  a="attendees"
}

function getTimeStampsFromChangeDB()
  changeTimeStamps = {}
  for timeStamp in pairs(Test_Save_Changes) do table.insert(changeTimeStamps, timeStamp) end

  -- Will this sort automatically?  Might need a custom sorter function..
  table.sort(changeTimeStamps)

  return changeTimeStamps
end

-- Create a CHAT_ADDON_MSG with prefix CLASSIC_CALENDAR_SYNC letting clients know that we want to sync
-- and providing the most recent change that we have
function broadcastSyncRequest(timeStamp)
  C_ChatInfo.SendAddonMessage (ClassicCalendarNS.CLASSIC_CALENDAR_SYNC, timestamp, "GUILD");
end

-- This function handles sending a list of all changes that we have that the client requesting the sync doesn't
-- Encoded in the message should be a timestamp of the requestor's last recorded change
-- Return a list of any changes with timestamps (ids) later than the requested
-- The form should be an array-like table:  { <id1>, <id2>, ...}
-- This is so the receiver can queue up applying the changes
function handleSyncRequest(timeStamp, ...)
  -- This SHOULD be sorted by most recent
  local currentTimeStamps = getTimeStampsFromChangeDB()
  local timeStampsNeeded = {}
  local synced = false
  local idx = 1

  while (not synced) do
    if (not currentTimeStamps[idx] or currentTimeStamps[idx] == timeStamp) then
      synced = true
    else
      table.insert(timeStampsNeeded, currentTimeStamps[idx])
      idx = idx + 1
    end
  end

  local responseMessage = table.concat(timeStampsNeeded, ",")
  C_ChatInfo.SendAddonMessage (ClassicCalendarNS.CLASSIC_CALENDAR_SYNC, timestamp, "WHISPER", "Niosporin-Atiesh");  -- TODO, get the target from the function args
end

-- This function handles writing the change encoded in message to the change DB
function handleChangeRequest(message, ...)
  print("CHANGE REQUEST")
  print("message: " .. message .. "rest: " .. ...)
  tempParsedMessage = {}
  pendingChange = {}

  -- Split the message into "words" - the %a+ is a lua matcher
  -- See: http://www.lua.org/pil/20.2.html for the docs on this
  message:gmatch("%a+", function(value)
    table.insert(tempParsedMessage, value)
  end)

  -- Now, tempParsedMessage is a table that is "array-like".
  -- Create actual key-value pairs to store in pendingChange
  for i=1, table.maxn(tempParsedMessage), 2 do
    local shortHandKey = tempParsedMessage[i]
    local value = tempParsedMessage[i+1]

    pendingChange[MESSAGE_KEY_MAPPING[shortHandKey]] = value
  end

  -- Check to see if we already have a change with a matching id
  if (Test_Save_Changes[pendingChange.id]) then
    return
  else
    -- Write the change to our change DB
    Test_Save_Changes[pendingChange.id] = pendingChange
  end
end

local ADDON_PREFIX_MAPPING = {}
ADDON_PREFIX_MAPPING[ClassicCalendarNS.CLASSIC_CALENDAR_SYNC] = handleSyncRequest
ADDON_PREFIX_MAPPING[ClassicCalendarNS.CLASSIC_CALENDAR_CHANGE] = handleChangeRequest

function eventFrame_onEvent(event, prefix, message, ...)
  if event == "CHAT_MSG_ADDON" then
    print("message recieved at prefix " .. prefix)
    print("message: " .. message .. "rest: " .. ...)
    local messageHandler = ADDON_PREFIX_MAPPING[prefix]

    if not messageHandler then
      print("no message handler, leaving...")
      return
    end

    messageHandler(message, ...)
  elseif event == "PLAYER_LOGIN" then
    -- These return bools - not sure its really necessary to even log these...
		local isChangeRequestSuccessful = C_ChatInfo.RegisterAddonMessagePrefix(ClassicCalendarNS.CLASSIC_CALENDAR_CHANGE)
    local isSyncRequestSuccessful = C_ChatInfo.RegisterAddonMessagePrefix(ClassicCalendarNS.CLASSIC_CALENDAR_SYNC)
  elseif event == "ADDON_LOADED" then
    -- Saved variables loaded
    -- Initialize if nil
    if (Test_Save == nil) then
      Test_Save = {}
    end

    if (Test_Save_Changes == nil) then
      Test_Save_Changes = {}
    end

    -- TODO - Add this in when ready - this is to broadcast a sync request when the addon is loaded
    -- changeTimeStamps = getTimeStampsFromChangeDB()

    -- if (table.maxn(changeTimeStamps) > 0) then
    --   broadcastSyncRequest(changeTimeStamps[table.maxn(changeTimeStamps)])
    -- end
  end
end

function createEventFrame()
  local eventFrame = CreateFrame("Frame")
  
  eventFrame:SetScript("OnEvent", eventFrame_onEvent);
  eventFrame:RegisterEvent("PLAYER_LOGIN");
  eventFrame:RegisterEvent("ADDON_LOADED");
  eventFrame:RegisterEvent("CHAT_MSG_ADDON");

  return eventFrame
end

ClassicCalendarNS.createEventFrame = createEventFrame
