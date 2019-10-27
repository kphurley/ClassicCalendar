function getTimeStampsFromChangeDB()
  changeTimeStamps = {}
  for timeStamp in pairs(Test_Save_Changes) do table.insert(changeTimeStamps, timeStamp) end

  -- Enforce descending order on the timestamps, so the most recent timestamp comes first
  table.sort(changeTimeStamps, function (a,b)
    return a > b;
  end)

  return changeTimeStamps
end
