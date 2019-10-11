-- The global names after the _ seem to matter - need to match identifer assigned to SlashCmdList
SLASH_CLASSICCALENDAR1 = '/ccal'; -- 3.
function SlashCmdList.CLASSICCALENDAR(msg, editBox) -- 4.
  WorldOfWarcraftAddOnIntermediate:Show();
end

AddOnButton:SetScript('OnClick', function()
  print("clicked")
end)

function renderCalendarDay (day, week)
  local f = CreateFrame("Frame", "MyFrame", WorldOfWarcraftAddOnIntermediate)
  f:SetWidth(50)
  f:SetHeight(50)
  
  local t = f:CreateTexture(nil, nil)
  t:SetColorTexture(1, 1, 1, 1)
  t:SetAllPoints(f)
  f.texture = t
  
  -- There has to be a better way to express how to calculate the position of each frame...
  f:SetPoint("TOPLEFT", (20 * day) + (40 * (day - 1)), -60 * week - 20)
  f:Show()
end

for day=1, 7 do
  for week=1, 5 do
    renderCalendarDay(day, week)
  end
end
