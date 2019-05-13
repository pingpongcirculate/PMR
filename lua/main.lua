
local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local labelClass = require("lua.lib.labelObj");
local buttonClass = require("lua.lib.buttonObj");

io.write (" HELLO FROM LUA\n");
common.init();
local bg1 = imgClass("./img/black.png",0,0,800,600,common.getObjIdx());
--LUA_LoadImg("./img/3.png",0,0,400,100,255,3);
--LUA_LoadImg("./img/3.png",0,0,480,600,255,1);
--LUA_LoadImg("./img/4.png",120,120,680,400,255,2);

--LUA_SetImgAlpha(2,10);
--LUA_SetImgHiden(1);
--LUA_DelImg(1)
--LUA_LoadImg("./img/4.jpg",0,0,480,600,255,1);

--LUA_BringImgToFront(3)
	
function bOnclick()
LUA_APPRUNFILE("./lua/intro.lua");
io.write('button clicked\n')
end

function bOnclick2()
LUA_APPRUNFILE("./lua/scrollshooter.lua");
io.write('button clicked\n')
end

function bOnclick3()
LUA_APPRUNFILE("./lua/kanjitrainer.lua");
io.write('button clicked\n')
end

	b = buttonClass(common.getObjIdx,20+40,20+40,200,90); 
	b:loadImg("./img/ac.png");
	b:loadHImg("./img/black.png");
	b:setDragable(false);
	b:setText("./ttf/iosevkacc-regular.ttf","three in a row",18,200,200,200);
	b:setOnClick(bOnclick)
	
	b2 = buttonClass(common.getObjIdx,20+40,115+40,200,90); 
	b2:loadImg("./img/ac.png");
	b2:loadHImg("./img/black.png");
	b2:setDragable(false);
	b2:setText("./ttf/iosevkacc-regular.ttf","vertical scroll\nshooter",18,200,200,200);
	b2:setOnClick(bOnclick2)
	
	b3 = buttonClass(common.getObjIdx,20+40,210+40,200,90); 
	b3:loadImg("./img/ac.png");
	b3:loadHImg("./img/black.png");
	b3:setDragable(false);
	b3:setText("./ttf/iosevkacc-regular.ttf","kanji trainer",18,200,200,200);
	b3:setOnClick(bOnclick3)
	

function mouseHandler(x,y,mbS,mbF)
--io.write("X: ",x," Y: ",y," mbS: ",mbS," mbF: ",mbF,"\n");
	b:processMouseEvent(x,y,mbS,mbF)
	b2:processMouseEvent(x,y,mbS,mbF)
	b3:processMouseEvent(x,y,mbS,mbF)
end

function LoopHandler()
end
