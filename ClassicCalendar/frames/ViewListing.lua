local ClassicCalendar, NS = ...

function createViewListingFrame(button, listingData)
  ViewListingFrame = CreateFrame("Frame", "ViewListingFrame", ListingsFrame, "BasicFrameTemplateWithInset")
    
  ViewListingFrame:SetSize(350, 550)
  ViewListingFrame:SetPoint("TOPLEFT", ListingsFrame, "TOPRIGHT")

  ViewListingFrame.Title = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  ViewListingFrame.Title:SetPoint("TOPLEFT", ViewListingFrame.Bg, "TOPLEFT", 16, -16)
  ViewListingFrame.Title:SetText(listingData.title)

  ViewListingFrame.Description = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.Description:SetPoint("TOPLEFT", ViewListingFrame.Title, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.Description:SetSize(325, 40)
  ViewListingFrame.Description:SetJustifyH("LEFT");
  ViewListingFrame.Description:SetText(listingData.description)

  ViewListingFrame.StartLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.StartLabel:SetPoint("TOPLEFT", ViewListingFrame.Description, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.StartLabel:SetText("Start Time")

  ViewListingFrame.StartText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.StartText:SetPoint("TOPLEFT", ViewListingFrame.StartLabel, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.StartText:SetText(date("%c", listingData.startTime))

  ViewListingFrame.EndLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.EndLabel:SetPoint("TOPLEFT", ViewListingFrame.StartText, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.EndLabel:SetText("End Time")

  ViewListingFrame.EndText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.EndText:SetPoint("TOPLEFT", ViewListingFrame.EndLabel, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.EndText:SetText(date("%c", listingData.endTime))

  ViewListingFrame.LevelLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.LevelLabel:SetPoint("TOPLEFT", ViewListingFrame.EndText, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.LevelLabel:SetText("Level Range")

  ViewListingFrame.LevelRangeText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.LevelRangeText:SetPoint("TOPLEFT", ViewListingFrame.LevelLabel, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.LevelRangeText:SetText(listingData.minLevel .. "-" .. listingData.maxLevel)

  ViewListingFrame.MaxPlayersLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.MaxPlayersLabel:SetPoint("TOPLEFT", ViewListingFrame.LevelRangeText, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.MaxPlayersLabel:SetText("Players")

  ViewListingFrame.MaxPlayersText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.MaxPlayersText:SetPoint("TOPLEFT", ViewListingFrame.MaxPlayersLabel, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.MaxPlayersText:SetText(listingData.numPlayers)

  ViewListingFrame.RsvpLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.RsvpLabel:SetPoint("TOPLEFT", ViewListingFrame.MaxPlayersText, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.RsvpLabel:SetText("Attending")

  local isPlayerRsvpd = false
  local rsvpsForListing = Test_Save_Rsvps[listingData.id]

  if not rsvpsForListing then
    local NoPlayerRsvpText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    NoPlayerRsvpText:SetPoint("TOPLEFT", ViewListingFrame.RsvpLabel, "BOTTOMLEFT", 0, -5)
    NoPlayerRsvpText:SetText("No players signed up yet.")
  else
    local RsvpTexts = {}
    for idx, rsvp in ipairs(rsvpsForListing) do
      local PlayerRsvpText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")

      if idx == 1 then
        PlayerRsvpText:SetPoint("TOPLEFT", ViewListingFrame.RsvpLabel, "BOTTOMLEFT", 0, -5)
      else
        PlayerRsvpText:SetPoint("TOPLEFT", RsvpTexts[idx - 1], "BOTTOMLEFT", 0, -5)
      end

      if rsvp.name == UnitName("player") then
        isPlayerRsvpd = true
      end

      PlayerRsvpText:SetText(rsvp.name .. " " .. rsvp.level .. " " .. rsvp.class)
    end
  end

  if isPlayerRsvpd then
    ViewListingFrame.RemoveRsvpButton = CreateFrame("Button", "RemoveRsvpButton", ViewListingFrame, "UIPanelButtonTemplate")
    ViewListingFrame.RemoveRsvpButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 20)
    ViewListingFrame.RemoveRsvpButton:SetSize(100, 30)
    ViewListingFrame.RemoveRsvpButton:SetText("Remove sign up")

    ViewListingFrame.RemoveRsvpButton:SetScript('OnClick', function()
      -- Create a change
      local toRemove = nil
      for idx, rsvp in pairs(rsvpsForListing) do
        if rsvp.name == UnitName("Player") then
          toRemove = idx
        end
      end

      if toRemove then
        table.remove(rsvpsForListing, toRemove)
      end

      -- create change
      -- timestamp, id, change

      -- save change

      -- encode change
      -- Send a CCAL_CHANGE_RES message with the change

      -- Apply the change

      -- Refresh the ViewListingFrame somehow
    end)
  else
    ViewListingFrame.AddRsvpButton = CreateFrame("Button", "AddRsvpButton", ViewListingFrame, "UIPanelButtonTemplate")
    ViewListingFrame.AddRsvpButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 20)
    ViewListingFrame.AddRsvpButton:SetSize(100, 30)
    ViewListingFrame.AddRsvpButton:SetText("Sign up")

    ViewListingFrame.AddRsvpButton:SetScript('OnClick', function()
      -- Gather this player's info
      _, engClass = UnitClass("player")
      
      local timestamp = time()
      local pendingRsvpChange = {
        id = listingData.id,
        name = UnitName("player"),
        level = UnitLevel("player"),
        class = engClass,
        updatedAt = timestamp,
        changeAction = ADD_RSVP
      }

      -- Create a change
      Test_Save_Changes[timestamp] = pendingRsvpChange

      -- encode change
      local msg = encodeOutgoingMessage(pendingRsvpChange)

      -- Send a CCAL_CHANGE_RES message with the change
      C_ChatInfo.SendAddonMessage("CCAL_CHANGE_RES", msg, "GUILD")

      -- Apply the change
      if not Test_Save_Rsvps[listingData.id] then
        Test_Save_Rsvps[listingData.id] = {}
      end

      table.insert(Test_Save_Rsvps[listingData.id], {
        name = pendingRsvpChange.name,
        level = pendingRsvpChange.level,
        class = pendingRsvpChange.class,
      })

      -- Refresh the ViewListingFrame somehow
    end)
  end

  local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
  local playerCanDeleteEvent = (guildRankIndex == 0) -- 0 is GM Rank

  if playerCanDeleteEvent then
    ViewListingFrame.DeleteEventButton = CreateFrame("Button", "DeleteEventButton", ViewListingFrame, "UIPanelButtonTemplate")
    ViewListingFrame.DeleteEventButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 50)
    ViewListingFrame.DeleteEventButton:SetSize(100, 30)
    ViewListingFrame.DeleteEventButton:SetText("Delete Event")

    ViewListingFrame.DeleteEventButton:SetScript('OnClick', function()
      -- Create a change (how do we do this?)
      -- Send a CCAL_CHANGE_RES message with the change
      -- Apply the change

      -- Go to event list
    end)
  end

  ViewListingFrame:Show()

  return ViewListingFrame
end
