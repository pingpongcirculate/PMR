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
self.targetX = x;
self.targetY = y;
self.speed = 1
self.idGen = idGen
self.angle = angle
self.sprite = imgClass(spritePath,self.x,self.y,self.w,self.h,self.idGen());
self.sprite:setAngle(self.angle);
self.bullet = nil;
self.AIStep = 1;
self.IdleTimer = -1;
return self
end

function spaceshipObj:getAngle()
return self.angle
end

function  spaceshipObj:setAngle(a)
self.angle = a;
self.sprite:setAngle(self.angle);
end

function spaceshipObj:setSpeed(spd)
  self.speed = speed
  end

function spaceshipObj:getSpeed()
  return self.speed
end

function spaceshipObj:setTargetX(x)
  if (x ~= self.x) then
   self.targetX = x
 end  
end

function spaceshipObj:setTargetY(y)
  if (y ~= self.y) then
   self.targetY = y
 end  
  end

function spaceshipObj:getAIStep()
  return self.AIStep
  end

function spaceshipObj:setAIStep(Step)
  self.AIStep = Step
  end

function spaceshipObj:ProcessAI(AIArray)
  if (self.IdleTimer > 0 ) then
    self.IdleTimer = self.IdleTimer -1
    return 0
  end
  
  local AICommand = AIArray[self.AIStep][1]
  local Argument = AIArray[self.AIStep][2]
  -- go down
   if (AICommand == 2) then
     self:setTargetY(Argument)
  end 
  --fire
  if (AICommand == 0) then
    self:fire(self.angle)
  end
  --iddle, conditional
  if (AICommand == 9) then
     if (self.IdleTimer <= 0) then
       self.IdleTimer = Argument
     end
  end
  --goto
   if (AICommand == 5) then
     self.AIStep =  self.AIStep + Argument
    end
     self.AIStep = self.AIStep +1
  end

function spaceshipObj:fire(angle)
  bulletArray[#bulletArray+1] =  bulletClass(self.x+self.w/2,self.y,12,12,angle,200,self.speed+1,"img/ship.png",self.idGen());
  end

function spaceshipObj:processMouseEvent(x,y,mbS,mbF,bulletArray)
 
 if (mbS == 1 ) then
 --  self.angle = self.angle + 0.1
 --  self.sprite:setAngle(self.angle)   
 end
 
 if (mbS < 0 ) then
 self:fire(self.angle)
   end 
 
 if (x ~= self.x) then
   self.targetX = x
 end  
  
 end

function spaceshipObj:processLoop()

 local newX = self.x
 local newY = self.y

 if (self.targetX > self.x +self.w/2) then
   newX = newX + self.speed 
 end  
 
  if (self.targetX < self.x +self.w/2) then
   newX = newX - self.speed 
 end  

 if (self.targetY > self.y) then
   newY = newY + self.speed 
 end  
 
  if (self.targetY < self.y ) then
   newY = newY - self.speed 
 end  

if (newX ~= self.x or newY ~=self.y) then
  self.x = newX
  self.y = newY
  self.sprite:setPos(self.x,self.y)
  end

  end

return spaceshipObj;
