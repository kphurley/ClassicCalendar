local ClassicCalendar, NS = ...

function createListingsFrame()
  ListingsFrame = CreateFrame("Frame", "ListingsFrame", UIParent, "BasicFrameTemplateWithInset")
  
  ListingsFrame:SetSize(450, 550)
  ListingsFrame:SetPoint("CENTER", UIParent, "CENTER")

  ListingsFrame.Title = ListingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  ListingsFrame.Title:SetPoint("LEFT", ListingsFrame.TitleBg, "LEFT", 5, 0)
  ListingsFrame.Title:SetText("Classic Calendar")

  ListingsFrame.HeadingGuildName = ListingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  ListingsFrame.HeadingGuildName:SetPoint("TOPLEFT", ListingsFrame.Bg, "TOPLEFT", 16, -16)
 
  local guildName, _, _ = GetGuildInfo("player")
  ListingsFrame.HeadingGuildName:SetText(guildName)

  ListingsFrame.HeadingSubtext = ListingsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  ListingsFrame.HeadingSubtext:SetPoint("TOPLEFT", ListingsFrame.HeadingGuildName, "BOTTOMLEFT", 0, -8)
  ListingsFrame.HeadingSubtext:SetText("All times are server time.")
  
  ListingsFrame.AddListingButton = CreateFrame("Button", "AddListingButton", ListingsFrame, "UIPanelButtonTemplate")
  ListingsFrame.AddListingButton:SetText("Create Event")
  ListingsFrame.AddListingButton:SetSize(100, 30)
  ListingsFrame.AddListingButton:SetPoint("BOTTOM", ListingsFrame.Bg, "BOTTOM", 0, 20)

  ListingsFrame.ListingsScrollFrameContainer = CreateFrame("Frame", "ListingsFrameListingsScrollFrameContainer", ListingsFrame)
  ListingsFrame.ListingsScrollFrameContainer:SetPoint("TOPLEFT", ListingsFrame.HeadingSubtext, "BOTTOMLEFT", 0, -8)
  ListingsFrame.ListingsScrollFrameContainer:SetPoint("BOTTOM", ListingsFrame.AddListingButton, "TOP", 0, 16)
  ListingsFrame.ListingsScrollFrameContainer:SetPoint("RIGHT", ListingsFrame, "RIGHT", -16, 0)
  ListingsFrame.ListingsScrollFrameContainer:SetBackdrop({ 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16, 
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
  })
  ListingsFrame.ListingsScrollFrameContainer:SetBackdropBorderColor(.6, .6, .6, 1)

  ListingsFrame.ListingsScrollFrame = CreateFrame("ScrollFrame", "ListingsFrameListingsScrollFrame", ListingsFrame, "FauxScrollFrameTemplate")
  ListingsFrame.ListingsScrollFrame:SetPoint("TOPLEFT", ListingsFrame.ListingsScrollFrameContainer, "TOPLEFT", 8, -8)
  ListingsFrame.ListingsScrollFrame:SetPoint("BOTTOM", ListingsFrame.ListingsScrollFrameContainer, "BOTTOM", 0, 12)
  ListingsFrame.ListingsScrollFrame:SetPoint("RIGHT", ListingsFrame.ListingsScrollFrameContainer, "RIGHT", -30, 0)
  
  local NUM_BUTTONS = 8
  local BUTTON_HEIGHT = 50
  local BUTTON_WIDTH = 350
  
  local buttons = {}
  local buttonInfoList = {}
  local keys = {}
  
  function UpdateListingScrollFrame(frame)
    local numItems = #keys
    FauxScrollFrame_Update(frame, numItems, NUM_BUTTONS, BUTTON_HEIGHT)
    local offset = FauxScrollFrame_GetOffset(frame)

    for line = 1, NUM_BUTTONS do
      local lineplusoffset = line + offset
      local button = buttons[line]
      if lineplusoffset > numItems then
          button:Hide()
      else
        if not buttonInfoList[lineplusoffset].header then
          button.Title:SetText(buttonInfoList[lineplusoffset].title)
          button.Title:SetFontObject("GameFontNormal")
          button.Description:SetText(buttonInfoList[lineplusoffset].description)
        else
          button.Title:SetText("")
          button.Description:SetText(buttonInfoList[lineplusoffset].header)
          button.Description:SetFontObject("GameFontNormalLarge")
        end

        button:Show()
      end
    end
  end
  
  
  ListingsFrame.ListingsScrollFrame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, UpdateListingScrollFrame)
  end)

  ListingsFrame.ListingsScrollFrame:SetScript("OnShow", function(self, event, ...)
    -- At this point Test_Save SHOULD be loaded...

    -- Initialize keys - flatten the structure to a list in the form
    -- { date1, event, event, date2, event, event, event, ... }
    local keyIdx = 1
    for key, value in pairs(Test_Save) do
      keys[keyIdx] = key
      buttonInfoList[keyIdx] = { header = key } -- TODO - convert key back to a date
      keyIdx = keyIdx + 1
     
      for id, listing in pairs(value) do
        keys[keyIdx] = id
        buttonInfoList[keyIdx] = listing
        keyIdx = keyIdx + 1
      end
    end

    print(table.concat(keys, ","))

    -- Create the buttons to show in the frame
    for i = 1, NUM_BUTTONS do
      local button = CreateFrame("Button", nil, ListingsFrame.ListingsScrollFrame:GetParent())
      if i == 1 then
          button:SetPoint("TOP", ListingsFrame.ListingsScrollFrame)
      else
          button:SetPoint("TOP", buttons[i - 1], "BOTTOM")
      end

      button.Title = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      button.Title:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -5)

      button.Description = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      button.Description:SetPoint("TOPLEFT", button.Title, "BOTTOMLEFT", 0, -5)

      button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)

      button:SetScript('OnClick', function()
        createViewListingFrame()
      end)
      
      buttons[i] = button
    end

    UpdateListingScrollFrame(self)
  end)
  
  ListingsFrame:Hide()

  return ListingsFrame
end

NS.createListingsFrame = createListingsFrame
