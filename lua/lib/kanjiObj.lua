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

function kanjiObj.new(idGen,x,y,w,h)
local self = setmetatable({},kanjiObj)
self.idGen = idGen
self.x = x
self.y = y
self.w = w
self.h = h
self.id = self.idGen()
self.mode = 0 -- 0 - kanji, !0 - translation
self.kanji = nil
self.kanji = buttonClass(self.idGen,self.x,self.y,self.w,self.h)
--self.translation = nil
self.kanjiTxt = nil
self.translationTxt = nil
self.answer = {}
return self
end

function kanjiObj:setKanji(txt)
    if (self.kanji ~= nil) then
    self.kanji = nil    
  end
  self.kanjiTxt = txt
  --self.kanji = labelClass("./ttf/GenShinGothic-Monospace-Normal.ttf",self.kanjiTxt,self.x,self.y,255,255,255,16,self.idGen())
  --self.kanji:hide()
end

function kanjiObj:setTranslation(txt)
  if (self.translation ~= nil) then
    self.translation = nil
  end
  self.translationTxt = txt
  --self.translation = labelClass("./ttf/GenShinGothic-Monospace-Normal.ttf",self.translationTxt,self.x,self.y,255,255,255,16,self.idGen())
  --self.translation:hide()
  end

function kanjiObj:setMode(m)
  self.mode = m
  if (self.mode == 0 ) then
    --self.translation:hide()
    --self.kanji:show()
    self.kanji:setText(self.kanjiTxt)
  else
    self.kanji:setText(self.translationTxt)
    --self.translation:show()
    --self.kanji:hide()
    end
  end

function kanjiObj:hide()
  self.kanji:hide()
  --self.translation:hide()
  end

function kanjiObj:show()
  if (self.mode == 0 ) then
    --self.translation:hide()
    self.kanji:show()
  else
   -- self.translation:show()
    self.kanji:hide()
    end
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

return kanjiObj
