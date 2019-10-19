-- Convert lua numeric date-time to our dateString format for indexing
-- Returns a string in the form MM-DD-YYYY
function dateIntToDateString(dateInt)
  local dateTimeTable = os.date("*t", dateInt)
  return table.concat({dateTimeTable.month, dateTimeTable.day, dateTimeTable.year}, ",")
end
