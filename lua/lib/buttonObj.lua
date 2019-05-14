
-- complex button object
-- mom look! i am an lua programmer. like for real!
local imgClass = require("lua.lib.imgObj")
local labelClass = require("lua.lib.labelObj")

local buttonObj = {}
buttonObj.__index = buttonObj

setmetatable(buttonObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

function buttonObj.new(idGen,x,y,w,h)
local self = setmetatable({},buttonObj)
self.idGen = idGen
self.x = x
self.y = y
self.w = w
self.h = h
self.dragX = 0
self.dragY = 0
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

function buttonObj:Destroy()
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

function buttonObj:setOnClick(ocHandler)
	self.OnClick = ocHandler
end

function buttonObj:move(dX, dY)
local newX = self.x + dX
local newY = self.y + dY

--io.write("deltaX: ",dX, "deltaY: ",dY," self.x ",self.x," self.y ",self.y,"\n")

if (self.img ~= nil) then
self.img:setPos(newX,newY)
end

if (self.himg ~= nil) then
self.himg:setPos(newX,newY)
end

if (self.cimg ~= nil) then
self.cimg:setPos(newX,newY)
end

if (self.txt ~= nil) then
local textY = (self.h /2 - self.txt:getFontSize()/2) + newY
local textX = self.txt:getFontSize()/2+newX
self.txt:setPos(textX,textY)
end

self.x = newX
self.y = newY

end

function buttonObj:loadImg(imgPath)
self.img = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
--io.write("self.img.id: ",self.img:getId(),"\n")
self.img:show();
end

function buttonObj:loadHImg(imgPath)
self.himg = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
self.himg:hide();
--io.write("self.himg.id: ",self.himg:getId(),"\n")
end

function buttonObj:locadCImg(imgPath)
self.cimg = imgClass(imgPath,self.x,self.y,self.w,self.h,self.idGen());
self.cimg:hide();
end

function buttonObj:setText(fontPath,Text,fontSize,r,g,b)
--labelObj.new(fontPath,lText,x,y,r,g,b,size,ID)
self.txt = labelClass(fontPath,Text,self.x+(fontSize /2),self.y + (self.h/2 - fontSize/2),r,g,b,fontSize,self.idGen());
end


function buttonObj:processMouseEvent(x,y,mbS,mbF)

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
      io.write("clickbaited!\n")
   if (self.OnClick ~= nil) then
   self.OnClick()
   end
   
   end
   if (self.himg ~= nil) then
	self.himg:show();
  end
  if (self.img ~= nil) then
	self.img:hide();
  end
 else
 --process mouse out
 if (self.img ~= nil) then
 	self.img:show();
end
if (self.himg ~= nil) then
	self.himg:hide();
  end
	self.dragX = 0
    self.dragY = 0
    self.dragFlag = false
 end
 
return 0
end

function buttonObj:getDragable()
return self.dragable
end

function buttonObj:setDragable(df)
self.dragable = df
end

function buttonObj:hide()
end

function buttonObj:show()
  end

return buttonObj
