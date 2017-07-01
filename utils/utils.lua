--utils.lua
--v1.6.4
--Author: Connor Wojtak
--Purpose: This utility provides a variety of different functions not relating to a certain class.

--Gets the length of a table. Returns: Integer
function getTableLength(aTable)
  local count = 0
  for _ in pairs(aTable) do count = count + 1 end
  return count
end
