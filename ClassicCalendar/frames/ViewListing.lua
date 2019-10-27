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


  ViewListingFrame:Show()

  return ViewListingFrame
end
