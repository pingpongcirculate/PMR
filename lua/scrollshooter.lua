
local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local spClass = require("lua.lib.spaceshipObj");
local labelClass = require("lua.lib.labelObj");
local bulletClass = require("lua.lib.bulletObj");
local bulletprocessMutex = 0; -- 0 - bullets array unlocked - 1 - bullets array locked
local npcWaveCounter=1
common.init();

local debugL1 = labelClass("./ttf/iosevkacc-regular.ttf","Debug Line 1",32,32,200,200,200,16,common.getObjIdx());
local debugL2 = labelClass("./ttf/iosevkacc-regular.ttf","Debug Line 2",32,52,200,200,200,16,common.getObjIdx());
local dbgArr = {}
dbgArr[1] = debugL1
dbgArr[2] = debugL2


local bg1 = imgClass("./img/black.png",0,0,LUA_WindowW,LUA_WindowH,common.getObjIdx())
local bg2 = imgClass("./img/black.png",0,-LUA_WindowH,LUA_WindowW,LUA_WindowH,common.getObjIdx())
local pl = spClass(200,470,96,96,0,"img/ship.png",common.getObjIdx,dbgArr)
local npc = {}
local npcwavePlacements = {
  {{(LUA_WindowW/4)+(LUA_WindowW/4)/3,-70,180},{(LUA_WindowW/4)*2+(LUA_WindowW/4)/3,-70,180},{(LUA_WindowW/4)*3+(LUA_WindowW/4)/3,-70,180}}
  }
local npcAI = {
  {2,0.5},{7,180},{9,100},{51,64,2},{5,-3},
  {2,0},{9,20},{7,180},{2,3},{0,0},{9,20},{50,LUA_WindowH-100,3},{51,64,6},{5,-4},
  {2,0},{75,5},{54,360,-8},{5,-2},
  {2,0},{75,5},{54,540,-13},{5,-2}}
local bullets = {}
--local bullet = bulletClass(200,470,12,12,350,"img/ship.png",common.getObjIdx());

--ENGINE HOOKS
function mouseHandler(x,y,mbS,mbF)
  if (bulletprocessMutex == 0) then
		pl:processMouseEvent(x,y,mbS,mbF,bullets)
    end
end

function ProcessCollisions()
  local index = 0;
  local value = nil;
  local X = 0;
  local Y = 0;
 for index, value in ipairs(bullets) do
    X = math.floor(value:getX())
    Y = math.floor(value:getY())
    local npcIndex = 0
    local npcValue = nil;
    for npcIndex, npcValue in ipairs(npc) do
      local npcX = math.floor(npcValue:getX())
      local npcXW = math.floor(npcX + npcValue:getW())
      local npcY = math.floor(npcValue:getY())
      local npcYH = math.floor(npcY + npcValue:getH())
      --io.write("npcX: "..tostring(npcX).." X: "..tostring(X).." npcXW: "..tostring(npcXW).." npcY: "..tostring(npcY).." Y:"..tostring(Y).." npcH: "..tostring(npcYH).."\n")
      if ( npcX < X and npcXW > X and npcY < Y and npcYH > Y ) then
    bulletprocessMutex = 1
    value:destroy();
	  --value = nil;
	  --bullets[index] = nil;
	  table.remove(bullets,index);
    npcValue:destroy()
    --npcValue = nil
    table.remove(npc,npcIndex)
    bulletprocessMutex = 0
    io.write("npcX: "..tostring(npcX).." X: "..tostring(X).." npcXW: "..tostring(npcXW).." npcY: "..tostring(npcY).." Y:"..tostring(Y).." npcH: "..tostring(npcYH).."\n")
        io.write("HIT!\n")
        end
    end --npc
    
   end --bullets
  
end

function scrollBackground()
  if (bg1:getY() > LUA_WindowH) then
    bg1:setPos(bg1:getX(),-LUA_WindowH)
  else
    bg1:setPos(bg1:getX(),bg1:getY()+1)
  end
  if (bg2:getY() > LUA_WindowH) then
    bg2:setPos(bg2:getX(),-LUA_WindowH)
  else
    bg2:setPos(bg2:getX(),bg2:getY()+1)
  end
  end

function generateNpcWave()
  if (#npc == 0) then
    npc = nil
    npc = {}
    for npcCoordsIndex, npcCoordsValue in ipairs(npcwavePlacements[npcWaveCounter]) do
    io.write("X: "..tostring(npcCoordsValue[1]).." Y: "..tostring(npcCoordsValue[2]).." ANGLE: "..tostring(npcCoordsValue[3]))
    table.insert(npc,spClass(math.floor(npcCoordsValue[1]),math.floor(npcCoordsValue[2]),64,64,0,"img/ship.png",common.getObjIdx,dbgArr))
    npc[#npc]:setAngle(npcCoordsValue[3])
   end
    end
  end

function processBullets(BulletsArray)
 local Bulet_index = 0;
 local Bulet_value = nil;
 bulletprocessMutex = 1
  for Bulet_index, Bulet_value in ipairs(BulletsArray) do
	Bulet_value:move()
	if (Bulet_value:getLifeTime() <=0 or Bulet_value:getX() < 0 or Bulet_value:getY() < 0 ) then
	 Bulet_value:destroy()
   table.remove(BulletsArray,Bulet_index)
		end 
	end -- for
 bulletprocessMutex = 0
end

--main event loop goes here
function LoopHandler()
 --debugL1:setText("SHIP ANGLE: "..tostring(pl:getAngle()))
 --debugL2:setText("BULLET COORDS  X: "..tostring(bullet:getX()).." Y: " ..tostring(bullet:getY()))
 --bullet:move()
    local npcIndex = 0
    local npcValue = nil
    for npcIndex, npcValue in ipairs(npc) do
      npcValue:ProcessAI(npcAI,bullets)
      end --npc   
  pl:processLoop('Player')
    npcIndex = 0
    npcValue = nil
  for npcIndex, npcValue in ipairs(npc) do
      npcValue:processLoop()
    end --npc
    processBullets(bullets)
    ProcessCollisions()
    generateNpcWave()
    scrollBackground()
    collectgarbage()
end
--ENGINE HOOKS END

pl:setAngle(0)
pl:setSpeed(4)
--radians =  degrees * Pi / 180
