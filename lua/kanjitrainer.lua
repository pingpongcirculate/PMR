local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local labelClass = require("lua.lib.labelObj");
local buttonClass = require("lua.lib.buttonObj");
local kanjiClass = require("lua.lib.kanjiObj");
common.init();
math.randomseed(3)

local bg1 = imgClass("./img/black.png",0,0,800,600,common.getObjIdx())
local kanjiPair = {"何","what","誰","who","犬","dog","猫","cat","鳥","bird","馬","horse"}
local kanjiArr = {}
local QKanji = nil
local QKanjiIdx = 0; -- index from answer array
local i = 0
local answeredIndex = 0;

function checkAnswer(Idx)
 io.write("ANSWERED INDEX ARE: "..Idx.."\n")
 if( QKanjiIdx == Idx) then
   io.write("A WINNER IS YOU!\n")
    GenerateQuestion()
 end
  end

for i=1, #kanjiPair, 2 do
  local newLen = #kanjiArr+1
  kanjiArr[newLen] = kanjiClass(common.getObjIdx,100,100+50*i,200,40,newLen)
  kanjiArr[#kanjiArr]:setKanji(kanjiPair[i])
  kanjiArr[#kanjiArr]:setTranslation(kanjiPair[i+1])
  kanjiArr[#kanjiArr]:setMode(1)
  kanjiArr[#kanjiArr]:setOnClick(checkAnswer)   
  end

--b = buttonClass(common.getObjIdx,20+40,20+40,200,90); 
--	b:loadImg("./img/ac.png");
--	b:loadHImg("./img/black.png");
--	b:setDragable(false);
--	b:setText("./ttf/GenShinGothic-Monospace-Normal.ttf","何じゃこれは?!",24,200,200,200);
  
function GenerateQuestion()
 --index of question in common array  
QKanjiIdx = math.random(#kanjiArr)
if (QKanji ~= nil) then
QKanji:destroy()
end
QKanji = nil
QKanji=kanjiClass(common.getObjIdx,60,60,200,40,QKanjiIdx)
QKanji:setKanji(kanjiArr[QKanjiIdx]:getKanji())
QKanji:setTranslation(kanjiArr[QKanjiIdx]:getTranslation())
QKanji:setMode(0)

local QkanjiAnswerIdx = math.random(3)
local  tempAnswersArr = {}
for i=1, #kanjiArr do
  kanjiArr[i]:hide()
end

for i=1, 3 do
  local RandomKanjiIdx = math.random(#kanjiArr)
  while RandomKanjiIdx == QKanjiIdx do
    RandomKanjiIdx = math.random(#kanjiArr)
  end
  if (i == QkanjiAnswerIdx ) then
  tempAnswersArr[i] = kanjiArr[QKanjiIdx]  
    else
  tempAnswersArr[i] = kanjiArr[RandomKanjiIdx]
end
  tempAnswersArr[i]:setPos(100,150+50*i)
  tempAnswersArr[i]:show()
end
  tempAnswersArr = nil
end

--ENGINE HOOKS
function mouseHandler(x,y,mbS,mbF)
  for i=1, #kanjiArr do
    kanjiArr[i]:processMouseEvent(x,y,mbS,mbF)
    end
end
--ENGINE HOOKS END

GenerateQuestion()