
-- complex brick object
-- mom look! i am an lua programmer. like for real!

local imgClass = require("lua.lib.imgObj")
local labelClass = require("lua.lib.labelObj")

local brickObj = {}
brickObj.__index = brickObj

setmetatable(brickObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function brickObj.new(idGen,x,y,w,h)
local self = setmetatable({},brickObj)
self.idGen = idGen
self.x = x
self.y = y
self.w = w
self.h = h
self.moveToX = x
self.moveToY = y
self.startAnimationX = x
self.startAnimationY = y
self.movementSpeed = 4
self.value = 0
self.angle = 0
self.isHidden = false;
--should be triggered when animation in process
self.animationActive = false
self.dragX = 0
self.dragY = 0
self.delay = 0;
--idle time image
self.img = nil
--hover image
self.himg = nil
--click image
self.cimg = nil
--idle time label object
self.txt = nil
self.OnClick = nil
self.dragable = false
self.dragFlag = false
return self
end

function brickObj:destroy()
if (self.img ~= nil) then
self.img:destroy()
self.img = nil
end

if (self.himg ~= nil) then
self.himg:destroy()
self.himg = nil
end

if (self.cimg ~= nil) then
self.cimg:destroy()
self.cimg = nil
end

if (self.txt ~= nil) then
self.txt:destroy()
self.txt = nil
end
collectgarbage()
end

function brickObj:move(dX, dY)
local newX = self.x + dX
local newY = self.y + dY

--io.write("deltaX: ",dX, "deltaY: ",dY," self.x ",self.x," self.y ",self.y,"\n")
--self.angle = self.angle + 0.5
if (self.img ~= nil) then
self.img:setPos(newX,newY)
self.img:setAngle(self.angle)
end

if (self.himg ~= nil) then
self.himg:setPos(newX,newY)
self.himg:setAngle(self.angle)
end

if (self.cimg ~= nil) then
self.cimg:setPos(newX,newY)
self.cimg:setAngle(self.angle)
end

if (self.txt ~= nil) then
local textY = (self.h /2 - self.txt:getFontSize()/2) + newY
local textX = self.txt:getFontSize()/2+newX
self.txt:setPos(textX,textY)
end

self.x = newX
self.y = newY

end


function brickObj:hide()

if (self.img ~= nil) then
self.img:hide()
end

if (self.himg ~= nil) then
self.himg:hide()
end

if (self.cimg ~= nil) then
self.cimg:hide()
end

if (self.txt ~= nil) then
self.txt:hide()
end

self.isHidden = true;
end

function brickObj:loadImg(imgPath)
self.img = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
--io.write("self.img.id: ",self.img:getId(),"\n")
self.img:show();
end

function brickObj:loadHImg(imgPath)
self.himg = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
self.himg:hide();
--io.write("self.himg.id: ",self.himg:getId(),"\n")
end

function brickObj:locadCImg(imgPath)
self.cimg = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
self.cimg:hide();
end

function brickObj:setText(fontPath,Text,fontSize,r,g,b)
--labelObj.new(fontPath,lText,x,y,r,g,b,size,ID)
self.txt = labelClass(fontPath,Text,self.x+(fontSize /2),self.y + (self.h/2 - fontSize/2),r,g,b,fontSize,self.idGen());
end


function brickObj:processAnimationEvent()
 --if (self.delay < 3) then
 --self.delay = self.delay+1
 --return 0
 --else
 --self.delay = 0
 --end
 if (self.isHidden == true) then
 return 0
 end
  
 if (self.animationActive == true) then
 --io.write("self.moveToX: ",self.moveToX," self.moveToY ",self.moveToY," self.startAnimationX ",self.startAnimationX," self.x ",self.x," self.y ",self.y,"\n")
  if (self.x == self.moveToX and self.x == self.startAnimationX) and (self.y == self.moveToY and self.y == self.startAnimationY) then
  self.animationActive = false;
  end
  
  if (self.x ~= self.moveToX ) then
  local moveDirection = 0
  if (self.x < self.moveToX) then
  moveDirection = self.movementSpeed
  end  
  if (self.x > self.moveToX) then
  moveDirection = self.movementSpeed *-1
   end  
   self:move(moveDirection,0)
   end
   
   if (self.x == self.moveToX) and (self.x ~= self.startAnimationX ) then
   self.moveToX = self.startAnimationX;
   end

if (self.y ~= self.moveToY ) then
  local moveDirection = 0
  if (self.y < self.moveToY) then
  moveDirection = self.movementSpeed
  end  
  if (self.y > self.moveToY) then
  moveDirection = self.movementSpeed *-1
   end  
   self:move(0,moveDirection)
   end
   
   if (self.y == self.moveToY) and (self.y ~= self.startAnimationY ) then
   self.moveToY = self.startAnimationY;
   end   
   
   return 1
   
 end 
 
return 0

end


--set coords for falling down.
--further actions will be produced by ProcessAnimationEvent Function
function brickObj:fallDown(x,y)
 self.animationActive = true;
 self.moveToY = y;
 self.moveToX = x;
 self.startAnimationX = x;
 self.startAnimationY = y;
 return 0;
end


function brickObj:processMouseEvent(x,y,mbS,mbF)
 
 if (self.isHidden == true) then
 return false, false;
 end
 
 if ((self.x < x) and (self.y < y) and ((self.x+self.w) > x) and ((self.y+self.h) > y)) then
 --process mouse over
 
 --io.write("mbS ",mbS," mbF",mbF,"\n")
   if (mbS == 1 ) then
   self.dragFlag = true
   self.dragX = x
   self.dragY = y
   end
   
   if (mbS == 0 and self.dragFlag == true) then
   --io.write("Drag Enbled: x ",x," y ", y,"\n")
   local deltaX = 0
   local deltaY = 0
   
 if (self.animationActive ~= true) then  
 
   if (self.dragX > x) then
   deltaX = -1 *(self.dragX - x)
   end
   
   if (self.dragX < x) then
   deltaX = math.abs(self.dragX - x)
   end
   
   if (self.dragY > y) then
   deltaY = -1*(self.dragY - y)
   end
   
   if (self.dragY < y) then
   deltaY = math.abs(self.dragY - y)
   end
  
  if (math.abs(deltaX) > 2 or math.abs(deltaY) > 2) then
   
   if (math.abs(deltaX) > math.abs(deltaY)) then
   --self.animationActive = true
   if (deltaX > 0) then
   --self.moveToX = self.x + self.w*2
   return 6, 0
   else
   --self.moveToX = self.x - self.w*2
   return 4, 0
   end
   --self.startAnimationX = self.x
   --self.startAnimationY = self.y
   --self.moveToY = self.y
   end
   
   if (math.abs(deltaY) > math.abs(deltaX)) then
   --self.animationActive = true
   if (deltaY > 0) then
   --self.moveToY = self.y + self.h*2
   return 2, 0
   else
   --self.moveToY = self.y - self.h*2
   return 8, 0
   end
   --self.startAnimationX = self.x
   --self.startAnimationY = self.y
   --self.moveToX = self.x
   end
 
		end --if delta is big enough
 
 end --if animation is not in process
   
   if (self.dragable == true) then
   self:move(deltaX,deltaY)
   end
   
   self.dragX = x
   self.dragY = y
   end
   
   if (mbS < 0 and self.dragFlag == true) then
   --io.write("Drag Disabled: x ",x," y ", y,"\n")
   self.dragX = 0
   self.dragY = 0
   self.dragFlag = false
   if (self.Onclick ~= nil) then
   self.Onclick()
   end
   
   end
   
	self.himg:show();
	self.img:hide();
 else
 --process mouse out
 	self.img:show();
	self.himg:hide();
	self.dragX = 0
    self.dragY = 0
    self.dragFlag = false
 end
 
return 0, 0
end

function brickObj:getDragable()
return self.dragable
end

function brickObj:setDragable(df)
self.dragable = df
end

function brickObj:setValue(v)
self.value = v
end

function brickObj:getValue()
return self.value
end


return brickObj
