local ClassicCalendar, ClassicCalendarNS = ...

-- This is here to save space, since we can only send 250 characters over the wire
local SHORTHAND_TO_KEY_MAPPING = {
  i="id",
  t="title",
  d="description",
  st="startTime",
  et="endTime",
  min="minLevel",
  max="maxLevel",
  n="numPlayers",
  a="attendees",
  u="updatedAt"
}

local KEY_TO_SHORTHAND_MAPPING = {
  id="i",
  title="t",
  description="d",
  startTime="st",
  endTime="et",
  minLevel="min",
  maxLevel="max",
  numPlayers="num",
  attendees="a",
  updatedAt="u"
}

-- function getTimeStampsFromChangeDB()
--   changeTimeStamps = {}
--   for timeStamp in pairs(Test_Save_Changes) do table.insert(changeTimeStamps, timeStamp) end

--   -- Will this sort automatically?  Might need a custom sorter function..
--   table.sort(changeTimeStamps)

--   -- debugging...
--   print(table.concat(changeTimeStamps, ","))

--   return changeTimeStamps
-- end

-- Create a CHAT_ADDON_MSG with prefix CLASSIC_CALENDAR_SYNC letting clients know that we want to sync
-- and providing the most recent change that we have
function broadcastSyncRequest(timeStamp)
  C_ChatInfo.SendAddonMessage ("CCAL_SYNC", timestamp, "GUILD")
end

-- This function handles sending a list of all changes that we have that the client requesting the sync doesn't
-- Encoded in the message should be a timestamp of the requestor's last recorded change
-- Return a list of any changes with timestamps (ids) later than the requested
-- The form should be an array-like table:  { <id1>, <id2>, ...}
-- This is so the receiver can queue up applying the changes
function handleSyncRequest(message, channel, sender, ...)
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
  print("sync response ", responseMessage)
  --C_ChatInfo.SendAddonMessage("CCAL_SYNC_RES", responseMessage, "WHISPER", sender)  -- TODO, get the target from the function args
end

-- This function handles asking the sender for any needed changes that this client is missing
function handleSyncResponse(message, channel, sender, ...)
  -- TODO
end

-- Send the change with the given ID as an message
function handleChangeRequest(changeId, channel, sender, ...)
  local changeEntry = Test_Save_Changes[changeId]
  

  C_ChatInfo.SendAddonMessage("CCAL_CHANGE_RES", message, "WHISPER", sender)
end

-- This function handles applying changes and writing the change encoded in message to the change DB
function handleChangeResponse(message, channel, sender, ...)
  tempParsedMessage = {}
  pendingChange = {}

  -- Split the message into "words" - the %w+ is a lua matcher for alphanumeric characters
  -- See: http://www.lua.org/pil/20.2.html for the docs on this
  for word in message:gmatch("%w+") do
    table.insert(tempParsedMessage, word)
  end

  print("maxn", table.maxn(tempParsedMessage))

  -- Now, tempParsedMessage is a table that is "array-like".
  -- Create actual key-value pairs to store in pendingChange
  for i=1, table.maxn(tempParsedMessage), 2 do
    local shortHandKey = tempParsedMessage[i]
    local value = tempParsedMessage[i+1]
    local key = SHORTHAND_TO_KEY_MAPPING[shortHandKey]
    pendingChange[key] = value
  end

  -- Check to see if we already have a change with a matching id
  if (Test_Save_Changes[pendingChange.updatedAt]) then
    return
  else
    -- Apply the change
      -- Lookup the id of the listing the change points to
      -- Update any properties

    -- Write the change to our change DB
    Test_Save_Changes[pendingChange.updatedAt] = pendingChange
  end
end

function createEventFrame()
  local eventFrame = CreateFrame("Frame")

  function eventFrame:OnEvent(event, prefix, message, ...)
    if event == "CHAT_MSG_ADDON" then
      if prefix == "CCAL_CHANGE" then
        handleChangeRequest(message, ...)
      elseif prefix == "CCAL_CHANGE_RES" then
        handleChangeResponse(message, ...)
      elseif prefix == "CCAL_SYNC" then
        handleSyncRequest(message, ...)
      elseif prefix == "CCAL_SYNC_RES" then
        handleSyncResponse(message, ...)
      end
    elseif event == "PLAYER_LOGIN" then
      -- These return bools - not sure its really necessary to even log these...
      C_ChatInfo.RegisterAddonMessagePrefix("CCAL_CHANGE")
      C_ChatInfo.RegisterAddonMessagePrefix("CCAL_CHANGE_RES")
      C_ChatInfo.RegisterAddonMessagePrefix("CCAL_SYNC")
      C_ChatInfo.RegisterAddonMessagePrefix("CCAL_SYNC_RES")
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
  
  eventFrame:SetScript("OnEvent", eventFrame.OnEvent)
  eventFrame:RegisterEvent("PLAYER_LOGIN")
  eventFrame:RegisterEvent("ADDON_LOADED")
  eventFrame:RegisterEvent("CHAT_MSG_ADDON")
end

ClassicCalendarNS.createEventFrame = createEventFrame
