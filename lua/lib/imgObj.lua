

--object for grouping up properties of one single image together in one place

local imgObj = {}
imgObj.__index = imgObj

setmetatable(imgObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function imgObj.new(imgPath,x,y,w,h,ID)
local self = setmetatable({},imgObj)
--engine function call
--LUA_LoadImg(imgPath,x,y,w,h,alpha,ID)
LUA_LoadImg(imgPath,x,y,w,h,255,ID)
self.id = ID
self.x = x
self.y = y
self.w = w
self.h = h
self.angle = 0
self.alpha = 255
self.hidden = 0
return self
end

function imgObj:setAngle(a)
LUA_SetImgRotation(self.id,a)
self.angle = a
end

function imgObj:getId()
return self.id
end

function imgObj:hide()
LUA_SetImgHiden(self.id)
end

function imgObj:show()
LUA_SetImgUnHiden(self.id)
--io.write("show called ",self.id,"\n")
end

function imgObj:setPos(x,y)
LUA_SetImgPos(self.id,x,y)
self.x = x
self.y = y
end

function imgObj:setAlpha(a)
LUA_SetImgAlpha(self.id,a)
self.alpha = a
end

function imgObj:getX()
 return self.x
end

function imgObj:getY()
 return self.y
end

function imgObj:destroy()
LUA_DelImg(self.id)
end

return imgObj
