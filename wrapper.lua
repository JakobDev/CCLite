--The Löve2d had replaced some esay to use Function with a harder to use function, so here is a wrpper to use the old functions
wrapper = {}
function wrapper.isDirectory(path)
  local tTemp = love.filesystem.getInfo(path)
  if not tTemp then
    return false
  elseif tTemp.type == "directory" then
    return true
  else
    return false
  end
end

function wrapper.exists(path)
  local tTemp = love.filesystem.getInfo(path)
  if tTemp then
    return true
  else
    return false
  end
end

function wrapper.getSize(path)
  local tTemp = love.filesystem.getInfo(path)
  if not tTemp then
    return nil
  else
    return tTemp.size
  end
end
