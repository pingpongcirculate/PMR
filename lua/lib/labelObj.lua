
--basic text string object
local labelObj = {}
labelObj.__index = labelObj

setmetatable(labelObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function labelObj.new(fontPath,lText,x,y,r,g,b,size,ID)
local self = setmetatable({},labelObj)
self.x = x
self.y = y
self.r = r
self.g = g
self.b = b
self.size = size
self.ID = ID
if string.sub(lText,-1) ~= "\n"  then 
	lText = lText .. "\n"
 end
self.lText = lText
self.fPath = fontPath
LUA_CreateLabel(fontPath,size,r,g,b,x,y,lText,ID);
return self
end

function labelObj:setText(newText)
if string.sub(newText,-1) ~= "\n"  then 
	newText = newText .. "\n"
 end
 self.lText = newText
LUA_SetLabelText(self.ID,self.lText)
end

function labelObj:hide()
LUA_HideLabel(self.ID);
end

function labelObj:show()
LUA_ShowLabel(self.ID);
  end

function labelObj:setPos(x,y)
self.x = x;
self.y = y;
--io.write("set label pos\n")
LUA_SetLabelPos(self.ID,x,y);
end

function labelObj:getX()
return self.x;
end

function labelObj:getY()
return self.y;
end

function labelObj:getFontSize()
return self.size;
end

function labelObj:destroy()
LUA_DelLabel(self.ID)
end

return labelObj;
