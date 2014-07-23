-- Setting a good random seed
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)) * (os.clock()) * $idlerecvtime / $timems + ($connected and 1 or 0))

-- Make sure table.unpack and unpack are both mapped to the same function
table.unpack = table.unpack or unpack
unpack = unpack or table.unpack

-- Handle overwrriten functions
_TIMETOLEVEL = _TIMETOLEVEL or timetolevel
_TOSTRING    = _TOSTRING    or tostring
_TYPE        = _TYPE        or type
math._CEIL   = math._CEIL   or math.ceil
math._FLOOR  = math._FLOOR  or math.floor

-- Global object to keep track of stuff by our functions
_Tracker = _Tracker or {}