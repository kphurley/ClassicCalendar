local ClassicCalendar, ClassicCalendarNS = ...

function eventFrame_onEvent(event, prefix, ...)
  if event == "CHAT_MSG_ADDON" then
    if (prefix == AddonPrefix) then
      -- TODO - Write to appropriate place
      print(...)
    end
	elseif event == "PLAYER_LOGIN" then
		local successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix(AddonPrefix)
    print(successfulRequest);
  elseif event == "ADDON_LOADED" then
    -- Saved variables loaded
    -- Initialize if nil
    if (Test_Save == nil) then
      Test_Save = {}
    end
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
