local ClassicCalendar, NS = ...

function createViewListingFrame()
  local ViewListingFrame = CreateFrame("Frame", "AddListingFrame", ListingsFrame, "BasicFrameTemplateWithInset")

  ViewListingFrame:SetSize(350, 550)
  ViewListingFrame:SetPoint("TOPLEFT", ListingsFrame, "TOPRIGHT")

  ViewListingFrame:Show()

  return ViewListingFrame
end
