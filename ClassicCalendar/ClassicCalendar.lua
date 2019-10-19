local ClassicCalendar, ClassicCalendarNS = ...

-- Register slash commends --
-- The global names after the _ seem to matter - need to match identifer assigned to SlashCmdList
SLASH_CLASSICCALENDAR1 = '/ccal';
function SlashCmdList.CLASSICCALENDAR(msg, editBox)
  WorldOfWarcraftAddOnIntermediate:Show()
end

AddonPrefix = "CLASSIC_CALENDAR"

-- OnLoad
ClassicCalendarNS.createEventFrame()
ClassicCalendarNS.createCalendarFrame()
ClassicCalendarNS.createAddListingFrame()
