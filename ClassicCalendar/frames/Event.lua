local ClassicCalendar, ClassicCalendarNS = ...

-- See Messages.lua for constants and mappings around encoding and decoding messages

-- Create a CHAT_ADDON_MSG with prefix CCAL_SYNC letting clients know that we want to sync
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
  -- This is sorted with the most recent timestamps at the front
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
  C_ChatInfo.SendAddonMessage("CCAL_SYNC_RES", responseMessage, "WHISPER", sender)
end

-- This function handles asking the sender for any needed changes that this client is missing
-- The contents of the message should be a list of timestamps this player is missing
function handleSyncResponse(msg, channel, sender, ...)
  local tempParsedMessage = {}
  
  for word in msg:gmatch("%w+") do
    table.insert(tempParsedMessage, word)
  end

  -- For each timestamp in message - request the change using CCAL_CHANGE
  for i, word in tempParsedMessage do
    C_ChatInfo.SendAddonMessage("CCAL_CHANGE", word, "WHISPER", sender)
  end
end

-- Send the change with the given ID as an message
function handleChangeRequest(timeStamp, channel, sender, ...)
  local changeEntry = Test_Save_Changes[timeStamp]
  local encodedChange = encodeOutgoingMessage(changeEntry)

  C_ChatInfo.SendAddonMessage("CCAL_CHANGE_RES", encodedChange, "WHISPER", sender)
end

-- This function handles applying changes and writing the change encoded in message to the change DB
function handleChangeResponse(message, channel, sender, ...)
  local pendingChange = decodeIncomingMessage(message)

  -- Check to see if we already have a change with a matching id
  if (Test_Save_Changes[pendingChange.updatedAt]) then
    return
  else
    -- Write the change to our change DB
    Test_Save_Changes[pendingChange.updatedAt] = pendingChange

    -- Apply the change
    -- TODO - DRY up
    if (pendingChange.changeAction == ADD_LISTING) then
      if not Test_Save_Listings[pendingChange.id] then
        Test_Save_Listings[pendingChange.id] = {}
      end

      -- Overwrite each property found in the DB with what's in pendingChange
      for key, value in pairs(pendingChange) do
        Test_Save_Listings[pendingChange.id][key] = value 
      end
    elseif (pendingChange.changeAction == ADD_RSVP) then
      if not Test_Save_Rsvps[pendingChange.id] then
        Test_Save_Rsvps[pendingChange.id] = {}
      end

      -- Overwrite each property found in the DB with what's in pendingChange
      for key, value in pairs(pendingChange) do
        Test_Save_Rsvps[pendingChange.id][key] = value 
      end
    end

    -- TODO:  Handle DELETE_LISTING and REMOVE_RSVP
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
      if (Test_Save_Listings == nil) then
        Test_Save_Listings = {}
      end
  
      if (Test_Save_Changes == nil) then
        Test_Save_Changes = {}
      end

      if (Test_Save_Rsvps == nil) then
        Test_Save_Rsvps = {}
      end
  
      changeTimeStamps = getTimeStampsFromChangeDB()
  
      if (table.maxn(changeTimeStamps) > 0) then
        broadcastSyncRequest(changeTimeStamps[table.maxn(changeTimeStamps)])
      end
    end
  end
  
  eventFrame:SetScript("OnEvent", eventFrame.OnEvent)
  eventFrame:RegisterEvent("PLAYER_LOGIN")
  eventFrame:RegisterEvent("ADDON_LOADED")
  eventFrame:RegisterEvent("CHAT_MSG_ADDON")
end

ClassicCalendarNS.createEventFrame = createEventFrame
