local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local labelClass = require("lua.lib.labelObj");
local buttonClass = require("lua.lib.buttonObj");
local kanjiClass = require("lua.lib.kanjiObj");
common.init();
math.randomseed(2)

local bg1 = imgClass("./img/black.png",0,0,800,600,common.getObjIdx())
local kanjiPair = {"何","what","誰","who","犬","dog","猫","cat","鳥","bird","馬","horse"}
local kanjiArr = {}
local QKanji = nil
local i = 0

for i=1, #kanjiPair, 2 do
  kanjiArr[#kanjiArr+1] = kanjiClass(common.getObjIdx,100,100+50*i,200,40)
  kanjiArr[#kanjiArr]:setKanji(kanjiPair[i])
  kanjiArr[#kanjiArr]:setTranslation(kanjiPair[i+1])
  kanjiArr[#kanjiArr]:setMode(1)
  end

b = buttonClass(common.getObjIdx,20+40,20+40,200,90); 
	b:loadImg("./img/ac.png");
	b:loadHImg("./img/black.png");
	b:setDragable(false);
	b:setText("./ttf/GenShinGothic-Monospace-Normal.ttf","何じゃこれは?!",24,200,200,200);
  
--index of question in common array  
local QKanjiIdx = math.random(#kanjiArr)
	
--ENGINE HOOKS
function mouseHandler(x,y,mbS,mbF)
  for i=1, #kanjiArr do
    kanjiArr[i]:processMouseEvent(x,y,mbS,mbF)
    end
end
--ENGINE HOOKS END