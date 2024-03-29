local ClassicCalendar, ClassicCalendarNS = ...

--- Creates a 10-character random ID to use for storing data.  TODO - Extract to utility? ---
function uuid()
  local random = math.random
  local template ='xxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
      return string.format('%x', v)
  end)
end

function saveListing (listing, guid)
  if not Test_Save_Listings then
    Test_Save_Listings = {}
  end

  Test_Save_Listings[guid] = listing
end

function createAndSaveChange (listing, type)
  if not Test_Save_Changes then
    Test_Save_Changes = {}
  end

  listing.changeAction = type
  Test_Save_Changes[listing.updatedAt] = listing

  return listing
end

-- Convention here needs to be that only changes or sync requests are broadcast
function broadcastListing (listing)
  local msg = encodeOutgoingMessage(listing)
  print("sending message", msg)
  C_ChatInfo.SendAddonMessage ("CCAL_CHANGE_RES", msg, "GUILD")
end

function createAddListingFrame()
  -- So much repetition and garbage here.  Probably needs to be totally redone once data is working.
  -- Note that AddListingFrame is a global defined in the XML, so it's technically already "created"
  -- We should clean that up at some point too.

  -- HEADING
  local headingText = AddListingFrame:CreateFontString("Heading", 'ARTWORK', "GameFontNormal")
  headingText:SetPoint("TOP", 0, -40)
  headingText:SetText("Create Event")

  -- TITLE
  local titleLabel = AddListingFrame:CreateFontString("TitleLabel", 'ARTWORK', "GameFontNormal")
  titleLabel:SetPoint("TOPLEFT", 55, -80)
  titleLabel:SetText("Title:")

  local titleInput = CreateFrame("EditBox", "TitleInput", AddListingFrame, "InputBoxTemplate")
  titleInput:SetSize(100,20)
  titleInput:SetPoint("TOPLEFT", 100, -80)
  titleInput:SetAutoFocus(false)
  titleInput:SetMaxLetters(15)

  -- DESCRIPTION
  local descriptionLabel = AddListingFrame:CreateFontString("DescriptionLabel", 'ARTWORK', "GameFontNormal")
  descriptionLabel:SetPoint("TOPLEFT", 20, -120)
  descriptionLabel:SetText("Description:")

  -- TODO - Make custom gradient to support longer descriptions
  local descriptionInput = CreateFrame("EditBox", "DescriptionInput", AddListingFrame, "InputBoxTemplate")
  descriptionInput:SetSize(300,20)
  descriptionInput:SetPoint("TOPLEFT", 100, -120)
  descriptionInput:SetAutoFocus(false)
  descriptionInput:SetMaxLetters(60)

  -- START TIME
  local startTimeLabel = AddListingFrame:CreateFontString("StartTimeLabel", 'ARTWORK', "GameFontNormal")
  startTimeLabel:SetPoint("TOPLEFT", 50, -160)
  startTimeLabel:SetText("Start:")

  local startDateMonthInput = CreateFrame("EditBox", "StartDateMonthInput", AddListingFrame, "InputBoxTemplate")
  startDateMonthInput:SetSize(25,20)
  startDateMonthInput:SetPoint("TOPLEFT", 120, -160)
  startDateMonthInput:SetAutoFocus(false)
  startDateMonthInput:SetMaxLetters(2)
  --startDateMonthInput:SetText("MM")

  local startDateSlashLabel = AddListingFrame:CreateFontString("startDateSlashLabel", 'ARTWORK', "GameFontNormal")
  startDateSlashLabel:SetPoint("TOPLEFT", 150, -160)
  startDateSlashLabel:SetText("/")

  local startDateDayInput = CreateFrame("EditBox", "StartDateDayInput", AddListingFrame, "InputBoxTemplate")
  startDateDayInput:SetSize(25,20)
  startDateDayInput:SetPoint("TOPLEFT", 165, -160)
  startDateDayInput:SetAutoFocus(false)
  startDateDayInput:SetMaxLetters(2)
  --startDateDayInput:SetText("DD")

  local startTimeHourInput = CreateFrame("EditBox", "StartTimeHourInput", AddListingFrame, "InputBoxTemplate")
  startTimeHourInput:SetSize(25,20)
  startTimeHourInput:SetPoint("TOPLEFT", 215, -160)
  startTimeHourInput:SetAutoFocus(false)
  startTimeHourInput:SetMaxLetters(2)
  --startTimeHourInput:SetText("HH")

  local startTimeColonLabel = AddListingFrame:CreateFontString("StartTimeColon", 'ARTWORK', "GameFontNormal")
  startTimeColonLabel:SetPoint("TOPLEFT", 245, -160)
  startTimeColonLabel:SetText(":")

  local startTimeMinuteInput = CreateFrame("EditBox", "StartTimeMinuteInput", AddListingFrame, "InputBoxTemplate")
  startTimeMinuteInput:SetSize(25,20)
  startTimeMinuteInput:SetPoint("TOPLEFT", 260, -160)
  startTimeMinuteInput:SetAutoFocus(false)
  startTimeMinuteInput:SetMaxLetters(2)
  --startTimeMinuteInput:SetText("MM")

  -- END TIME
  local endTimeLabel = AddListingFrame:CreateFontString("EndTimeLabel", 'ARTWORK', "GameFontNormal")
  endTimeLabel:SetPoint("TOPLEFT", 55, -200)
  endTimeLabel:SetText("End:")

  local endDateMonthInput = CreateFrame("EditBox", "EndDateMonthInput", AddListingFrame, "InputBoxTemplate")
  endDateMonthInput:SetSize(25,20)
  endDateMonthInput:SetPoint("TOPLEFT", 120, -200)
  endDateMonthInput:SetAutoFocus(false)
  endDateMonthInput:SetMaxLetters(2)
  --endDateMonthInput:SetText("MM")

  local endDateSlashLabel = AddListingFrame:CreateFontString("EndDateSlashLabel", 'ARTWORK', "GameFontNormal")
  endDateSlashLabel:SetPoint("TOPLEFT", 150, -200)
  endDateSlashLabel:SetText("/")

  local endDateDayInput = CreateFrame("EditBox", "EndDateDayInput", AddListingFrame, "InputBoxTemplate")
  endDateDayInput:SetSize(25,20)
  endDateDayInput:SetPoint("TOPLEFT", 165, -200)
  endDateDayInput:SetAutoFocus(false)
  endDateDayInput:SetMaxLetters(2)
  --endDateDayInput:SetText("DD")


  local endTimeHourInput = CreateFrame("EditBox", "EndTimeHourInput", AddListingFrame, "InputBoxTemplate")
  endTimeHourInput:SetSize(25,20)
  endTimeHourInput:SetPoint("TOPLEFT", 215, -200)
  endTimeHourInput:SetAutoFocus(false)
  endTimeHourInput:SetMaxLetters(2)
  --endTimeHourInput:SetText("HH")

  local endTimeColonLabel = AddListingFrame:CreateFontString("EndTimeColon", 'ARTWORK', "GameFontNormal")
  endTimeColonLabel:SetPoint("TOPLEFT", 245, -200)
  endTimeColonLabel:SetText(":")

  local endTimeMinuteInput = CreateFrame("EditBox", "EndTimeMinuteInput", AddListingFrame, "InputBoxTemplate")
  endTimeMinuteInput:SetSize(25,20)
  endTimeMinuteInput:SetPoint("TOPLEFT", 260, -200)
  endTimeMinuteInput:SetAutoFocus(false)
  endTimeMinuteInput:SetMaxLetters(2)
  --endTimeMinuteInput:SetText("MM")

  -- MIN LEVEL
  local minLevelLabel = AddListingFrame:CreateFontString("MinLevelLabel", 'ARTWORK', "GameFontNormal")
  minLevelLabel:SetPoint("TOPLEFT", 30, -240)
  minLevelLabel:SetText("Min Level:")

  local minLevelInput = CreateFrame("EditBox", "MinLevelInput", AddListingFrame, "InputBoxTemplate")
  minLevelInput:SetSize(25,20)
  minLevelInput:SetPoint("TOPLEFT", 120, -240)
  minLevelInput:SetAutoFocus(false)
  minLevelInput:SetMaxLetters(2)

  -- MAX LEVEL
  local maxLevelLabel = AddListingFrame:CreateFontString("MaxLevelLabel", 'ARTWORK', "GameFontNormal")
  maxLevelLabel:SetPoint("TOPLEFT", 30, -280)
  maxLevelLabel:SetText("Max Level:")

  local maxLevelInput = CreateFrame("EditBox", "MaxLevelInput", AddListingFrame, "InputBoxTemplate")
  maxLevelInput:SetSize(25,20)
  maxLevelInput:SetPoint("TOPLEFT", 120, -280)
  maxLevelInput:SetAutoFocus(false)
  maxLevelInput:SetMaxLetters(2)

  -- NUM PLAYERS
  local numPlayersLabel = AddListingFrame:CreateFontString("NumPlayersLabel", 'ARTWORK', "GameFontNormal")
  numPlayersLabel:SetPoint("TOPLEFT", 20, -320)
  numPlayersLabel:SetText("Max players:")

  local numPlayersInput = CreateFrame("EditBox", "NumPlayersInput", AddListingFrame, "InputBoxTemplate")
  numPlayersInput:SetSize(25,20)
  numPlayersInput:SetPoint("TOPLEFT", 120, -320)
  numPlayersInput:SetAutoFocus(false)
  numPlayersInput:SetMaxLetters(2)

  SubmitButton:SetScript('OnClick', function()
    -- TODO change hard coded year
    local startDateInt = time{
      year = "2019",
      month = StartDateMonthInput:GetText(),
      day = StartDateDayInput:GetText(),
      hour = StartTimeHourInput:GetText(),
      min = StartTimeMinuteInput:GetText()
    }

    local endDateInt = time{
      year = "2019",
      month = EndDateMonthInput:GetText(),
      day = EndDateDayInput:GetText(),
      hour = EndTimeHourInput:GetText(),
      min = EndTimeMinuteInput:GetText()
    }

    local guid = uuid()
    local pendingListing = {
      id = guid,
      title = TitleInput:GetText(),
      description = DescriptionInput:GetText(),
      startTime = startDateInt,
      endTime = endDateInt,
      minLevel = MinLevelInput:GetText(),
      maxLevel = MaxLevelInput:GetText(),
      numPlayers = NumPlayersInput:GetText(),
      updatedAt = time(),
    }

    -- TODO - maybe what we want to do here instead is:
      -- local change = saveChangeFromListing(pendingListing, guid)
      -- applyChange(change)
      -- broadcastChange(change)
    -- That way, only the applyChange function can write to the actual DB
    -- And it would be reusable in the event handler

    saveListing(pendingListing, guid)
    local savedChange = createAndSaveChange(pendingListing, ADD_LISTING)
    broadcastListing(savedChange)
    
    AddListingFrame:Hide()
    ListingsFrame:Show()
    ListingsFrame:RefreshView()
  end)

  BackButton:SetScript('OnClick', function()
    --local inputText = input:GetText()
    
    AddListingFrame:Hide()
    ListingsFrame:Show()
  end)
end

ClassicCalendarNS.createAddListingFrame = createAddListingFrame 
