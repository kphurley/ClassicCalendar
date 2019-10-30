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

  ListingsFrame.AddListingButton:SetScript('OnClick', function()
    ListingsFrame:Hide()
    AddListingFrame:Show()
  end)

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
  
  ListingsFrame.NUM_BUTTONS = 8
  ListingsFrame.BUTTON_HEIGHT = 50
  ListingsFrame.BUTTON_WIDTH = 400
  
  ListingsFrame.buttons = {}
  ListingsFrame.buttonInfoList = {}
  ListingsFrame.keys = {}
  
  function UpdateListingScrollFrame(frame)
    print("updated")
    local numItems = #ListingsFrame.keys
    FauxScrollFrame_Update(frame, numItems, ListingsFrame.NUM_BUTTONS, ListingsFrame.BUTTON_HEIGHT)
    local offset = FauxScrollFrame_GetOffset(frame)

    for line = 1, ListingsFrame.NUM_BUTTONS do
      local lineplusoffset = line + offset
      local button = ListingsFrame.buttons[line]
      if lineplusoffset > numItems then
        button:Hide()
      else
        print("title?", ListingsFrame.buttonInfoList[lineplusoffset].title)
        button.Title:SetText(ListingsFrame.buttonInfoList[lineplusoffset].title)
        button.Title:SetFontObject("GameFontNormal")
        button.Description:SetText(ListingsFrame.buttonInfoList[lineplusoffset].description)
        button:Show()
      end
    end
  end

  function RefreshDataFromDB(frame)
    local keyIdx = 1
    for key, listing in pairs(Test_Save_Listings) do
      frame.keys[keyIdx] = key
      frame.buttonInfoList[keyIdx] = listing
      keyIdx = keyIdx + 1
    end
  end
  
  ListingsFrame.RefreshView = function(self)
    UpdateListingScrollFrame(self.ListingsScrollFrame)
    RefreshDataFromDB(self)
  end
  
  ListingsFrame.ListingsScrollFrame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, UpdateListingScrollFrame)
  end)

  ListingsFrame.ListingsScrollFrame:SetScript("OnShow", function(self, event, ...)
    -- At this point Test_Save_Listings SHOULD be loaded...

    -- Initialize keys and listind data, and flatten the structure to a list in the form
    -- { date1, event, event, date2, event, event, event, ... }
    RefreshDataFromDB(ListingsFrame)

    -- Create the buttons to show in the frame
    for i = 1, ListingsFrame.NUM_BUTTONS do
      local button = CreateFrame("Button", nil, ListingsFrame.ListingsScrollFrame:GetParent())
      if i == 1 then
          button:SetPoint("TOPLEFT", ListingsFrame.ListingsScrollFrame, "TOPLEFT", 16, -16)
      else
          button:SetPoint("TOP", ListingsFrame.buttons[i - 1], "BOTTOM")
      end

      button.Title = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      button.Title:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -5)

      button.Description = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      button.Description:SetPoint("TOPLEFT", button.Title, "BOTTOMLEFT", 0, -5)

      button:SetSize(ListingsFrame.BUTTON_WIDTH, ListingsFrame.BUTTON_HEIGHT)

      button:SetScript('OnClick', function()
        -- There is only one ViewListingFrame allowed at a time, so it's global.
        -- If there's one active, hide it
        if (ViewListingFrame) then
          ViewListingFrame:Hide()
        end

        createViewListingFrame(button, ListingsFrame.buttonInfoList[i])
      end)
      
      ListingsFrame.buttons[i] = button
    end

    UpdateListingScrollFrame(self)
  end)
  
  ListingsFrame:Hide()

  return ListingsFrame
end

NS.createListingsFrame = createListingsFrame
