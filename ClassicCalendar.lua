-- Register slash commends --
-- The global names after the _ seem to matter - need to match identifer assigned to SlashCmdList
SLASH_CLASSICCALENDAR1 = '/ccal';
function SlashCmdList.CLASSICCALENDAR(msg, editBox)
  WorldOfWarcraftAddOnIntermediate:Show()
end

-- Calendar frame
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

for day=1, 7 do
  for week=1, 5 do
    renderCalendarDay(day, week)
  end
end

CreateEventButton:SetScript('OnClick', function()
  WorldOfWarcraftAddOnIntermediate:Hide()
  CreateEvent:Show()
end)
-- End Calendar Frame

-- Create Event Frame

-- HEADING
local headingText = CreateEvent:CreateFontString("Heading", 'ARTWORK', "GameFontNormal");
headingText:SetPoint("TOP", 0, -40)
headingText:SetText("Create Event")

-- TITLE
local titleLabel = CreateEvent:CreateFontString("TitleLabel", 'ARTWORK', "GameFontNormal");
titleLabel:SetPoint("TOPLEFT", 60, -80)
titleLabel:SetText("Title:")

local titleInput = CreateFrame("EditBox", "TitleInput", CreateEvent, "InputBoxTemplate")
titleInput:SetSize(100,20)
titleInput:SetPoint("TOPLEFT", 100, -80)
titleInput:SetAutoFocus(false)
titleInput:SetMaxLetters(15)

-- DESCRIPTION
local descriptionLabel = CreateEvent:CreateFontString("DescriptionLabel", 'ARTWORK', "GameFontNormal");
descriptionLabel:SetPoint("TOPLEFT", 28, -120)
descriptionLabel:SetText("Description:")

-- TODO - Make custom gradient to support longer descriptions
local descriptionInput = CreateFrame("EditBox", "DescriptionInput", CreateEvent, "InputBoxTemplate")
descriptionInput:SetSize(300,20)
descriptionInput:SetPoint("TOPLEFT", 100, -120)
descriptionInput:SetAutoFocus(false)
descriptionInput:SetMaxLetters(60)

-- START TIME
local startTimeLabel = CreateEvent:CreateFontString("StartTimeLabel", 'ARTWORK', "GameFontNormal");
startTimeLabel:SetPoint("TOPLEFT", 38, -160)
startTimeLabel:SetText("Start time:")

local startTimeHourInput = CreateFrame("EditBox", "StartTimeHourInput", CreateEvent, "InputBoxTemplate")
startTimeHourInput:SetSize(25,20)
startTimeHourInput:SetPoint("TOPLEFT", 100, -160)
startTimeHourInput:SetAutoFocus(false)
startTimeHourInput:SetMaxLetters(2)

local startTimeColonLabel = CreateEvent:CreateFontString("StartTimeColon", 'ARTWORK', "GameFontNormal");
startTimeColonLabel:SetPoint("TOPLEFT", 130, -160)
startTimeColonLabel:SetText(":")

local startTimeMinuteInput = CreateFrame("EditBox", "StartTimeMinuteInput", CreateEvent, "InputBoxTemplate")
startTimeMinuteInput:SetSize(25,20)
startTimeMinuteInput:SetPoint("TOPLEFT", 145, -160)
startTimeMinuteInput:SetAutoFocus(false)
startTimeMinuteInput:SetMaxLetters(2)

-- END TIME
local endTimeLabel = CreateEvent:CreateFontString("EndTimeLabel", 'ARTWORK', "GameFontNormal");
endTimeLabel:SetPoint("TOPLEFT", 260, -160)
endTimeLabel:SetText("End time:")

local endTimeHourInput = CreateFrame("EditBox", "EndTimeHourInput", CreateEvent, "InputBoxTemplate")
endTimeHourInput:SetSize(25,20)
endTimeHourInput:SetPoint("TOPLEFT", 320, -160)
endTimeHourInput:SetAutoFocus(false)
endTimeHourInput:SetMaxLetters(2)

local endTimeColonLabel = CreateEvent:CreateFontString("EndTimeColon", 'ARTWORK', "GameFontNormal");
endTimeColonLabel:SetPoint("TOPLEFT", 350, -160)
endTimeColonLabel:SetText(":")

local endTimeMinuteInput = CreateFrame("EditBox", "EndTimeMinuteInput", CreateEvent, "InputBoxTemplate")
endTimeMinuteInput:SetSize(25,20)
endTimeMinuteInput:SetPoint("TOPLEFT", 365, -160)
endTimeMinuteInput:SetAutoFocus(false)
endTimeMinuteInput:SetMaxLetters(2)

-- MIN LEVEL
local minLevelLabel = CreateEvent:CreateFontString("MinLevelLabel", 'ARTWORK', "GameFontNormal");
minLevelLabel:SetPoint("TOPLEFT", 40, -200)
minLevelLabel:SetText("Min Level:")

local minLevelInput = CreateFrame("EditBox", "MinLevelInput", CreateEvent, "InputBoxTemplate")
minLevelInput:SetSize(25,20)
minLevelInput:SetPoint("TOPLEFT", 100, -200)
minLevelInput:SetAutoFocus(false)
minLevelInput:SetMaxLetters(2)

-- MAX LEVEL
local maxLevelLabel = CreateEvent:CreateFontString("MaxLevelLabel", 'ARTWORK', "GameFontNormal");
maxLevelLabel:SetPoint("TOPLEFT", 40, -240)
maxLevelLabel:SetText("Max Level:")

local maxLevelInput = CreateFrame("EditBox", "MaxLevelInput", CreateEvent, "InputBoxTemplate")
maxLevelInput:SetSize(25,20)
maxLevelInput:SetPoint("TOPLEFT", 100, -240)
maxLevelInput:SetAutoFocus(false)
maxLevelInput:SetMaxLetters(2)

-- NUM PLAYERS
local numPlayersLabel = CreateEvent:CreateFontString("NumPlayersLabel", 'ARTWORK', "GameFontNormal");
numPlayersLabel:SetPoint("TOPLEFT", 30, -280)
numPlayersLabel:SetText("Max players:")

local numPlayersInput = CreateFrame("EditBox", "NumPlayersInput", CreateEvent, "InputBoxTemplate")
numPlayersInput:SetSize(25,20)
numPlayersInput:SetPoint("TOPLEFT", 100, -280)
numPlayersInput:SetAutoFocus(false)
numPlayersInput:SetMaxLetters(2)

SubmitButton:SetScript('OnClick', function()
  -- ------Event------------
  -- titleInput
  -- descriptionInput
  -- startTimeHourInput  (These need dates so we can convert)
  -- startTimeMinuteInput
  -- endTimeHourInput
  -- endTimeMinuteInput

  -- ------Metadata----------
  -- minLevelInput
  -- maxLevelInput
  -- numPlayersInput
  
  CreateEvent:Hide()
  WorldOfWarcraftAddOnIntermediate:Show()
end)

BackButton:SetScript('OnClick', function()
  --local inputText = input:GetText()
  
  CreateEvent:Hide()
  WorldOfWarcraftAddOnIntermediate:Show()
end)


-- End create event frame