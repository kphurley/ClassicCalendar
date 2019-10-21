local ClassicCalendar, ClassicCalendarNS = ...

-- TODO - For now, kill this view, and keep simple with just a list of texts
-- Start with current date and move forward
function renderCalendarDay (day, week)
  local f = CreateFrame("Frame", "MyFrame", WorldOfWarcraftAddOnIntermediate)
  f:SetWidth(50)
  f:SetHeight(50)
  
  local t = f:CreateTexture(nil, nil)
  t:SetColorTexture(1, 1, 1, 0.1)
  t:SetAllPoints(f)
  f.texture = t
  
  -- There has to be a better way to express how to calculate the position of each frame...
  f:SetPoint("TOPLEFT", (20 * day) + (40 * (day - 1)), -60 * week - 20)
  f:Show()
end

function createCalendarFrame()
  for day=1, 7 do
    for week=1, 5 do
      renderCalendarDay(day, week)
    end
  end

  AddListingButton:SetScript('OnClick', function()
    WorldOfWarcraftAddOnIntermediate:Hide()
    AddListingFrame:Show()
  end)

  -- For debugging - remove
  TestSyncButton:SetScript('OnClick', function()
    getTimeStampsFromChangeDB()
  end)
end

ClassicCalendarNS.createCalendarFrame = createCalendarFrame
