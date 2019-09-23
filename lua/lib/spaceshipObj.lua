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

function spaceshipObj.new(x,y,w,h,angle,spritePath,idGen,dbg)
local self = setmetatable({},spaceshipObj)
self.x = x
self.y = y
self.w = w
self.h = h
self.dbg = dbg
self.targetX = x;
self.targetY = y;
self.speed = 2
self.idGen = idGen
self.angle = angle
self.sprite = imgClass(spritePath,self.x,self.y,self.w,self.h,self.idGen());
self.sprite:setAngle(self.angle);
self.bullet = nil;
self.AIStep = 1;
self.IdleTimer = -1;
return self
end

function spaceshipObj:getX()
  return self.x
  end

function spaceshipObj:getY()
  return self.y
end

function spaceshipObj:getW()
  return self.w
  end

function spaceshipObj:getH()
  return self.h
  end

function spaceshipObj:destroy()
  self.sprite:destroy()
  self.sprite = nil
  end

function spaceshipObj:getAngle()
return self.angle
end

function spaceshipObj:setAngle(a)
self.angle = a
self.sprite:setAngle(self.angle)
end

function spaceshipObj:setSpeed(spd)
  self.speed = spd
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

function spaceshipObj:move()
--radians =  degrees * Pi / 180
local radians = math.rad(self.angle);
local sine = self.speed * math.sin(radians); -- some precalculations
local cosine = self.speed * math.cos(radians);

 self.x = self.x + sine;
 self.y = self.y - cosine;
 self.sprite:setPos(math.floor(self.x),math.floor(self.y));
end


function spaceshipObj:ProcessAI(AIArray,bulletArray)  
  if (self.IdleTimer > 0 ) then
    self.IdleTimer = self.IdleTimer -1
    return 0
  end
  
  local AICommand = AIArray[self.AIStep][1]
  local Argument = AIArray[self.AIStep][2]
  self.dbg[1]:setText("AI COMMAND: "..tostring(AIArray[self.AIStep][1]).."  AI ARGUMENT: "..tostring(AIArray[self.AIStep][2]).." AI STEP: "..tostring(self.AIStep))
  --io.write("AI COMMAND: "..tostring(AIArray[self.AIStep][1]).."  AI ARGUMENT: "..tostring(AIArray[self.AIStep][2]).." AI STEP: "..tostring(self.AIStep).."\n")
 
  --fire
  if (AICommand == 0) then
    self:fire(self.angle,bulletArray)
  end
  
  --iddle, conditional
  if (AICommand == 9) then
     if (self.IdleTimer <= 0) then
       self.IdleTimer = Argument
     end
  end
  
  --goto, conditional Y
  if (AICommand == 50) then 
    if (self.y >= Argument) then
      self.AIStep =  AIArray[self.AIStep][3] + self.AIStep
          return 0
    end
    end
    
  if (AICommand == 51) then
    if (self.y <= Argument) then
      self.AIStep =  self.AIStep + AIArray[self.AIStep][3]
      return 0
    end    
  end 
  
  --goto, conditional Angle  
  if (AICommand == 54) then 
    if ( self.angle >= Argument ) then
      self.AIStep =  self.AIStep + AIArray[self.AIStep][3]
      return 0
    end   
    end
    
  if (AICommand == 56) then
    if (self.angle <= Argument) then
      self.AIStep =  self.AIStep + AIArray[self.AIStep][3]
      return 0
    end
  end 
  
  --goto
   if (AICommand == 5) then
     self.AIStep =  self.AIStep + Argument
     return 0
    end
   
  --turn
   if (AICommand == 7) then
    self:setAngle( Argument )
  end
  
  --change andgle
  if (AICommand == 75) then  
  --self.dbg[2]:setText("ANGLE: "..tostring(self.angle))
   --self.dbg[2]:setText("idleTimer: "..tostring(self.IdleTimer))  
   local angle = self:getAngle()
   angle = angle + Argument
   self:setAngle( angle )
    end  
  --set speed 
  if (AICommand == 2) then
     self:setSpeed(Argument)
  end 
  
  if (AICommand == 25) then
    local spd = self:getSpeed()
    spd = Argument + spd
     self:setSpeed(spd)
  end 

    self.AIStep = self.AIStep +1
    return 0 
  end

function spaceshipObj:fire(angle,bulletArray)
  local radians = math.rad(self.angle);
  local cosine = math.cos(radians);
  if (cosine < 0) then
  bulletArray[#bulletArray+1] =  bulletClass(math.floor(self.x+self.w/2),math.floor(self.y+self.h+1),12,12,angle,600,self.speed+3,"img/ship.png",self.idGen());
else
  bulletArray[#bulletArray+1] =  bulletClass(math.floor(self.x+self.w/2),math.floor(self.y),12,12,angle,600,self.speed+3,"img/ship.png",self.idGen());
  end
  end

function spaceshipObj:processMouseEvent(x,y,mbS,mbF,bulletArray)
 
 if (mbS == 1 ) then
 --  self.angle = self.angle + 0.1
 --  self.sprite:setAngle(self.angle)   
 end
 
 if (mbS < 0 ) then
 self:fire(self:getAngle(),bulletArray)
   end 
 
 if (x ~= self.x) then
   self.targetX = x
 end  
  
 end

function spaceshipObj:processLoop(PlayerFlag)

 if (PlayerFlag ~= nil) then
   
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

else
self:move()
end
  end

return spaceshipObj;
