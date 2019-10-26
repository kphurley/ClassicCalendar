local ClassicCalendar, NS = ...

function createViewListingFrame(button, listingData)
  ViewListingFrame = CreateFrame("Frame", "ViewListingFrame", ListingsFrame, "BasicFrameTemplateWithInset")
    
  ViewListingFrame:SetSize(350, 350)
  ViewListingFrame:SetPoint("TOPLEFT", button, "RIGHT")

  ViewListingFrame.Title = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  ViewListingFrame.Title:SetPoint("TOPLEFT", ViewListingFrame.Bg, "TOPLEFT", 16, -16)
  ViewListingFrame.Title:SetText(listingData.title)

  ViewListingFrame.Description = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.Description:SetPoint("TOPLEFT", ViewListingFrame.Title, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.Description:SetText(listingData.description)

  ViewListingFrame.LevelLabel = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  ViewListingFrame.LevelLabel:SetPoint("TOPLEFT", ViewListingFrame.Description, "BOTTOMLEFT", 0, -20)
  ViewListingFrame.LevelLabel:SetText("Level Range")

  ViewListingFrame.LevelRangeText = ViewListingFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ViewListingFrame.LevelRangeText:SetPoint("TOPLEFT", ViewListingFrame.LevelLabel, "BOTTOMLEFT", 0, -5)
  ViewListingFrame.LevelRangeText:SetText(listingData.minLevel .. "-" .. listingData.maxLevel)

  ViewListingFrame:Show()

  return ViewListingFrame
end
