-- bullet object
local imgClass = require("lua.lib.imgObj")

local bulletObj = {}
bulletObj.__index = bulletObj

setmetatable(bulletObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function bulletObj.new(x,y,w,h,angle,lifetime,speed,spritePath,id)
local self = setmetatable({},bulletObj)
self.x = x
self.y = y
self.w = w
self.h = h
self.id = id
self.speed = speed;
self.angle = angle;
self.sprite = imgClass(spritePath,self.x,self.y,self.w,self.h,self.id);
self.sprite:setAngle(self.angle);
self.lifetime = lifetime;
return self
end

function bulletObj:destroy()
 self.sprite:destroy();
 self.sprite = nil
end

function bulletObj:move()
--radians =  degrees * Pi / 180
local radians = math.rad(self.angle);
local sine = self.speed*math.sin(radians); -- some precalculations
local cosine = self.speed*math.cos(radians);

 self.x = math.floor(self.x + sine);
 self.y = math.floor(self.y - cosine);
 self.sprite:setPos(self.x,self.y);
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
