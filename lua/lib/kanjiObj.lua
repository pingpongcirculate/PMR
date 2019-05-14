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
self.kanji:setDragable(false)
--add customization
self.kanji:loadImg("./img/ac.png");
self.kanji:loadHImg("./img/black.png");
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
    self.kanji:setText("./ttf/GenShinGothic-Monospace-Normal.ttf",self.kanjiTxt,20,200,200,200)
  else
    self.kanji:setText("./ttf/GenShinGothic-Monospace-Normal.ttf",self.translationTxt,20,200,200,200)
    --self.translation:show()
    --self.kanji:hide()
    end
  end

function kanjiObj:hide()
  self.hidden = true
  self.kanji:hide()
  --self.translation:hide()
  end

function kanjiObj:show()
  self.hidden = false
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

function kanjiObj:processMouseEvent(x,y,mbS,mbF)
  if (self.hidden == false) then
  self.kanji:processMouseEvent(x,y,mbS,mbF)
  end
  end

return kanjiObj
