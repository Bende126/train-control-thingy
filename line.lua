Station = {name = 0}

function Station:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

Line = {train = 0, start_point = 0, end_point = 0}

function Line:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end