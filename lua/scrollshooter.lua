
local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local spClass = require("lua.lib.spaceshipObj");
local labelClass = require("lua.lib.labelObj");
local bulletClass = require("lua.lib.bulletObj");

common.init();

local bg1 = imgClass("./img/black.png",0,0,800,600,common.getObjIdx())
local pl = spClass(200,470,128,128,0,"img/ship.png",common.getObjIdx)
local npc = {}
local npcAI = {{2,600},{0,0},{9,90},{5,-2}}
npc[1] = spClass(200,0,64,64,0,"img/ship.png",common.getObjIdx)
npc[1]:setAngle(180)
local bullets = {}
--local bullet = bulletClass(200,470,12,12,350,"img/ship.png",common.getObjIdx());
local debugL1 = labelClass("./ttf/iosevkacc-regular.ttf","Debug Line 1",32,32,200,200,200,16,common.getObjIdx());
local debugL2 = labelClass("./ttf/iosevkacc-regular.ttf","Debug Line 2",32,52,200,200,200,16,common.getObjIdx());
--ENGINE HOOKS
function mouseHandler(x,y,mbS,mbF)
		pl:processMouseEvent(x,y,mbS,mbF,bullets)
end

function processBullets()
 local index = 0;
 for index, value in ipairs(bullets) do
	value:move()
	if (value:getLifeTime() <=0) then
	  value:destroy();
	  value = nil;
	  bullets[index] = nil;
	  table.remove(bullets,index);
		end 
	end -- for
collectgarbage();	
end

--main event loop goes here
function LoopHandler()
 --debugL1:setText("SHIP ANGLE: "..tostring(pl:getAngle()))
 --debugL2:setText("BULLET COORDS  X: "..tostring(bullet:getX()).." Y: " ..tostring(bullet:getY()))
 --bullet:move()
  npc[1]:ProcessAI(npcAI)
  processBullets()
  pl:processLoop()
  npc[1]:processLoop()
  
end
--ENGINE HOOKS END

pl:setAngle(0.3)

--radians =  degrees * Pi / 180
