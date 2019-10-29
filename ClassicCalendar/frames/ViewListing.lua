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

  if not listingData.rsvps then
    local NoPlayerRsvpText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    NoPlayerRsvpText:SetPoint("TOPLEFT", ViewListingFrame.RsvpLabel, "BOTTOMLEFT", 0, -5)
    NoPlayerRsvpText:SetText("No players signed up yet.")
  else
    local RsvpTexts = {}
    for idx, rsvp in pairs(listingData.rsvps) do
      local PlayerRsvpText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")

      if idx == 1 then
        PlayerRsvpText:SetPoint("TOPLEFT", ViewListingFrame.RsvpLabel, "BOTTOMLEFT", 0, -5)
      else
        PlayerRsvpText:SetPoint("TOPLEFT", RsvpTexts[idx - 1], "BOTTOMLEFT", 0, -5)
      end

      PlayerRsvpText:SetText(rsvp.name .. " " .. rsvp.level .. " " .. rsvp.class .. " " .. rsvp.note)
    end
  end

  -- If not currently attending
  ViewListingFrame.AddRsvpButton = CreateFrame("Button", "AddRsvpButton", ViewListingFrame, "UIPanelButtonTemplate")
  ViewListingFrame.AddRsvpButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 20)
  ViewListingFrame.AddRsvpButton:SetText("Sign up")

  ViewListingFrame.AddRsvpButton:SetScript('OnClick', function()
    -- Gather this player's info
    -- Create a change
    -- Send a CCAL_CHANGE_RES message with the change
    -- Apply the change

    -- Refresh the ViewListingFrame somehow
  end)

  -- else, give option to remove self from rsvp
  ViewListingFrame.RemoveRsvpButton = CreateFrame("Button", "RemoveRsvpButton", ViewListingFrame, "UIPanelButtonTemplate")
  ViewListingFrame.RemoveRsvpButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 20)
  ViewListingFrame.RemoveRsvpButton:SetText("Remove sign up")

  ViewListingFrame.RemoveRsvpButton:SetScript('OnClick', function()
    -- Create a change (how do we do this?)
    -- Send a CCAL_CHANGE_RES message with the change
    -- Apply the change

    -- Refresh the ViewListingFrame somehow
  end)

  -- if event owner or sufficient guild rank GM
  ViewListingFrame.DeleteEventButton = CreateFrame("Button", "DeleteEventButton", ViewListingFrame, "UIPanelButtonTemplate")
  ViewListingFrame.DeleteEventButton:SetPoint("BOTTOM", ViewListingFrame.Bg, "BOTTOM", 0, 50)
  ViewListingFrame.DeleteEventButton:SetText("Delete Event")

  ViewListingFrame.DeleteEventButton:SetScript('OnClick', function()
    -- Create a change (how do we do this?)
    -- Send a CCAL_CHANGE_RES message with the change
    -- Apply the change

    -- Go to event list
  end)

  ViewListingFrame:Show()

  return ViewListingFrame
end
