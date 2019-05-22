--kanji tester object
local imgClass = require("lua.lib.imgObj")
local labelClass = require("lua.lib.labelObj")
local buttonClass = require("lua.lib.buttonObj")

local kanjiObj = {}
kanjiObj.__index = kanjiObj

setmetatable(kanjiObj,{
	__call = function(cls,...)
	return cls.new(...)
	end,
})

--aIndex - index in global kanjiArray for answer checking procedure
function kanjiObj.new(idGen,x,y,w,h,aIndex)
local self = setmetatable({},kanjiObj)
self.idGen = idGen
self.x = x
self.y = y
self.w = w
self.h = h
self.id = self.idGen()
self.mode = 0 -- 0 - kanji, !0 - translation
self.AnswerIndex = aIndex
self.kanji = nil
self.kanji = buttonClass(self.idGen,self.x,self.y,self.w,self.h)
self.kanji:setDragable(false)
--add customization
self.kanji:loadImg("./img/ac.png");
self.kanji:loadHImg("./img/black.png");
self.lmDown = false -- left mouse button are pressed flag
--self.translation = nil
self.kanjiTxt = nil
self.translationTxt = nil
self.answer = {}
self.hidden= false
return self
end

function kanjiObj:setKanji(txt)
 --   if (self.kanji ~= nil) then
 --   self.kanji = nil    
 -- end
  self.kanjiTxt = txt
  --self.kanji = labelClass("./ttf/GenShinGothic-Monospace-Normal.ttf",self.kanjiTxt,self.x,self.y,255,255,255,16,self.idGen())
  --self.kanji:hide()
end

function kanjiObj:setTranslation(txt)
 -- if (self.translation ~= nil) then
 --   self.translation = nil
 -- end
  self.translationTxt = txt
  --self.translation = labelClass("./ttf/GenShinGothic-Monospace-Normal.ttf",self.translationTxt,self.x,self.y,255,255,255,16,self.idGen())
  --self.translation:hide()
  end

--rework needed. customization of fontsize and color required
function kanjiObj:setMode(m)
  self.mode = m
  if (self.mode == 0 ) then
    --self.translation:hide()
    --self.kanji:show()
    self.kanji:setText("./ttf/GenShinGothic-Monospace-Normal.ttf",self.kanjiTxt,24,200,200,200)
  else
    self.kanji:setText("./ttf/GenShinGothic-Monospace-Normal.ttf",self.translationTxt,24,200,200,200)
    --self.translation:show()
    --self.kanji:hide()
    end
  end

function kanjiObj:setPos(X,Y)
  self.kanji:setPos(X,Y)
  self.x = X
  self.y = Y
  end

function kanjiObj:hide()
  self.hidden = true
  self.kanji:hide()
  --self.translation:hide()
  end

function kanjiObj:show()
  self.hidden = false
  self.kanji:show()
   end

function kanjiObj:getKanji()
  return self.kanjiTxt
end

function kanjiObj:getTranslation()
  return self.translationTxt
end

function kanjiObj:getId()
  return self.id
  end

function kanjiObj:setOnClick(ocHandler)   
  self.OcHandler = ocHandler
    end

function kanjiObj:OnClick() 
  if (self.OcHandler ~= nil) then
    self.OcHandler(self.AnswerIndex)
    end
  end
  
function kanjiObj:processMouseEvent(x,y,mbS,mbF)
  if (self.hidden == false) then
  self.kanji:processMouseEvent(x,y,mbS,mbF)
  --becuse we cant pass "self" into mouse handler function
   if ((self.x < x) and (self.y < y) and ((self.x+self.w) > x) and ((self.y+self.h) > y)) then
 if (mbS == 1 ) then
  self.lmDown = true
end
   if (mbS < 0 and self.lmDown == true) then
     --io.write("clicked!\n")
     self:OnClick()
     end --lef mouse button up check
   end -- coords check
  end --if hidden check
  
  end --function

function kanjiObj:destroy()
  self.kanji:Destroy()
  end

return kanjiObj
