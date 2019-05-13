-- bullet object
local imgClass = require("lua.lib.imgObj")

local bulletObj = {}
bulletObj.__index = bulletObj

setmetatable(bulletObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function bulletObj.new(x,y,w,h,angle,lifetime,spritePath,id)
local self = setmetatable({},bulletObj)
self.x = x
self.y = y
self.w = w
self.h = h
self.id = id
self.speed = 1;
self.angle = angle;
self.sprite = imgClass(spritePath,self.x,self.y,self.w,self.h,self.id);
self.sprite:setAngle(self.angle);
self.lifetime = lifetime;
return self
end

function bulletObj:destroy()
 self.sprite:destroy();
end

function bulletObj:move()
--radians =  degrees * Pi / 180
local radians = math.rad(self.angle);
local sine = math.sin(radians); -- some precalculations
local cosine = math.cos(radians);

 self.x = self.x + sine;
 self.y = self.y - cosine;
 self.sprite:setPos(math.floor(self.x),math.floor(self.y));
 self.lifetime = self.lifetime -1;
end

function bulletObj:getX()
return self.x;
end

function bulletObj:getY()
return self.y;
end

function bulletObj:getLifeTime()
return self.lifetime;
end

return bulletObj
