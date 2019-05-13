--scrollshooter npc object
local imgClass = require("lua.lib.imgObj")
local bulletClass = require("lua.lib.bulletObj");

local spaceshipObj = {}
spaceshipObj.__index = spaceshipObj

setmetatable(spaceshipObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function spaceshipObj.new(x,y,w,h,angle,spritePath,idGen)
local self = setmetatable({},spaceshipObj)
self.x = x
self.y = y
self.w = w
self.h = h
self.idGen = idGen
self.angle = angle
self.sprite = imgClass(spritePath,self.x,self.y,self.w,self.h,self.idGen());
self.sprite:setAngle(self.angle);
self.bullet = nil;
return self
end

function spaceshipObj:getAngle()
return self.angle
end

function  spaceshipObj:setAngle(a)
self.angle = a;
self.sprite:setAngle(self.angle);
end


function spaceshipObj:processMouseEvent(x,y,mbS,mbF,bulletArray)
  if (mbS == 1 ) then
   self.angle = self.angle + 0.1
   self.sprite:setAngle(self.angle)   
   end
  if (mbS < 0 ) then
	bulletArray[#bulletArray+1] =  bulletClass(200,470,12,12,350,200,"img/ship.png",self.idGen());
   end 
   
end

return spaceshipObj;
