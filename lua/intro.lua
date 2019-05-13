
local common = require("lua.lib.common");
local imgClass = require("lua.lib.imgObj");
local labelClass = require("lua.lib.labelObj");
local buttonClass = require("lua.lib.buttonObj");
local brickClass = require("lua.lib.brickObj");


local GFM = 8; --game field matrix size
local MAXVALUE = 4; -- maximum block variety
local animationActive = false;

common.init();
local bg1 = imgClass("./img/black.png",0,0,800,600,common.getObjIdx());

local brick = {};
local bMatrix = {}; --actual matrix with values
local mMatrix = {}; --matrix with markout values
local sMatrix = {}; --matrix with swap blocks indication

function init(b,bM,mM)
local x = 0;
local y = 0;
local V = 0;
for y = 1, GFM do
   b[y] = {};
   bM[y] = {};
   mM[y] = {};
   sMatrix[y] = {};
	for x = 1, GFM do
	V = math.random(MAXVALUE);
	bM[y][x] = V;
	mM[y][x] = 0;
	sMatrix[y][x] = 0;
	b[y][x] = brickClass(common.getObjIdx,20+x*40,20+y*40,30,30); 
	b[y][x]:loadImg("./img/ac.png");
	b[y][x]:loadHImg("./img/black.png");
	b[y][x]:setDragable(false);
	b[y][x]:setText("./ttf/iosevkacc-regular.ttf",tostring(V),18,200,200,200);
		end
	end
end	
	
function MarkOutBricksHorizon(sX,sY,len,mM)
 local x=0;
 --io.write("Marking horizontal: X:",sX," Y: ",sY," L: ",len,"\n");
   for x = sX-len,sX,1 do
   --if (brick[sY][x] ~= nil) then
	--brick[sY][x]:destroy();
	--brick[sY][x] = nil;
	--end
	mM[sY][x] = -1;
 end
 cleanSwapMatrix()
end

function MarkOutBricksVert(sX,sY,len,mM)
local y=0;
--io.write("Marking vertical: X:",sX," Y: ",sY," ",len,"\n");
  for y = sY-len,sY,1 do
	mM[y][sX] = -1;
 end
 cleanSwapMatrix()
 --collectgarbage();
end

--function which checks field for triples or more
function checkField(bM,mM)
   local CurrentLen = 0;
   local y;
   local x;
   local wasFound = 0;
   --check all X axises	
   for y = 1, GFM do
     x = 1;
     CurrentLen = 0;
  while x < GFM do 	
  if (bM[y][x] > 0 ) then
		if (bM[y][x] == bM[y][x+1]) then
		CurrentLen = CurrentLen + 1;
		if (CurrentLen >= 2) and ((x+1) == GFM) then
			MarkOutBricksHorizon(x+1,y,CurrentLen,mM)
			break
		end --length >=3 and we are at last cell  - mark it out
		else
		if (CurrentLen >= 2) then
			MarkOutBricksHorizon(x,y,CurrentLen,mM)
		end --length >=3  - mark it out
		CurrentLen = 0;
		end
	end -- if value matrix > 0	
		x = x+1; 
	end --x		
	end --y

--check all Y axises	
   for x = 1, GFM do
     y = 1;
     CurrentLen = 0;
  while y < GFM do 
    if (bM[y][x] > 0 ) then	
		if (bM[y][x] == bM[y+1][x]) then
		CurrentLen = CurrentLen + 1;
		if (CurrentLen >= 2) and ((y+1) == GFM) then
			MarkOutBricksVert(x,y+1,CurrentLen,mM)
			break
		end --length >=3 and we are at last cell  - mark it out
		else
		if (CurrentLen >= 2) then
			MarkOutBricksVert(x,y,CurrentLen,mM)
		end --length >=3  - mark it out
		CurrentLen = 0;
		end
	end -- if bM > 0	
		y = y+1; 
	end --x		
	end --y
return 0	
end

--fall blocks down 
function cleanUpBoard(b,bM,mM)
	local x = 0;
	local y = 0;
  for y = 1, GFM do
		for x = 1, GFM do
		if (mM[y][x] == -1) then
			if (b[y][x] ~= nil) then
			b[y][x]:destroy();
			b[y][x] = nil;
			end
			bM[y][x] = 0;
			mM[y][x] = 0;
		end
		end --x
  end --y
  collectgarbage();
  return 0;
end -- cleanUpBoard()

function fallDownBlocks(b,bM,mM)
	local x = 0;
	local y = 0;
 for x = 1,GFM do
  for y = 1, GFM-1 do
	if ((mM[y+1][x] == 0) and (bM[y+1][x]==0) and (bM[y][x] > 0 ))  then
	bM[y+1][x] = bM[y][x]
	bM[y][x] = 0
	b[y+1][x] = b[y][x]
	b[y][x]:fallDown(20+x*40,20+(y+1)*40)
	b[y][x] = nil
	fallDownBlocks(b,bM,mM)
		end --if
  end --y
		end --x
	end --fallDownBlocks

function cleanSwapMatrix()
	local x = 0;
	local y = 0;
  for y = 1, GFM do
		for x = 1, GFM do
			sMatrix[y][x] = 0; --cancel swaps if marked
end
end
end

function processSwaps()
	local x = 0;
	local y = 0;
  for y = 1, GFM do
		for x = 1, GFM do
			local tmp = nil;
			tmp = brick[y][x];
			local tmpV = bMatrix[y][x];
			
			if (sMatrix[y][x] == 8 ) then
			sMatrix[y][x] = 0;
			brick[y][x]:fallDown(20+x*40,20+(y+1)*40);
			brick[y+1][x]:fallDown(20+x*40,20+y*40);
			brick[y][x] = brick[y+1][x];
			brick[y+1][x] = tmp;
			bMatrix[y][x] = bMatrix[y+1][x];
			bMatrix[y+1][x] = tmpV;
			animationActive = true;
			end
			
			if (sMatrix[y][x] == 2 ) then
			sMatrix[y][x] = 0;
			brick[y][x]:fallDown(20+x*40,20+(y-1)*40);
			brick[y-1][x]:fallDown(20+x*40,20+y*40);
			brick[y][x] = brick[y-1][x];
			brick[y-1][x] = tmp;
			bMatrix[y][x] = bMatrix[y-1][x];
			bMatrix[y-1][x] = tmpV;
			animationActive = true;
			end
			
			if (sMatrix[y][x] == 4 ) then
			sMatrix[y][x] = 0;
			brick[y][x]:fallDown(20+(x+1)*40,20+y*40);
			brick[y][x+1]:fallDown(20+x*40,20+y*40);
			brick[y][x] = brick[y][x+1];
			brick[y][x+1] = tmp;
			bMatrix[y][x] = bMatrix[y][x+1];
			bMatrix[y][x+1] = tmpV;
			animationActive = true;
			end
			
			if (sMatrix[y][x] == 6 ) then
			sMatrix[y][x] = 0;
			brick[y][x]:fallDown(20+(x-1)*40,20+y*40);
			brick[y][x-1]:fallDown(20+x*40,20+y*40);
			brick[y][x] = brick[y][x-1];
			brick[y][x-1] = tmp;
			bMatrix[y][x] = bMatrix[y][x-1];
			bMatrix[y][x-1] = tmpV;
			animationActive = true;
			end
		end --x
	end --y
end --processSwaps
	
function regenerateBlocks(b,bM,mM)
	local x = 0;
	local y = 0;
	local V = 0;
for y = 1, GFM do
	for x = 1, GFM do
	if (b[y][x] == nil) then
	V = math.random(MAXVALUE);
	bM[y][x] = V;
	mM[y][x] = 0;
	b[y][x] = brickClass(common.getObjIdx,20+x*40,-1*(20+(GFM-y)*40),30,30); 
	b[y][x]:loadImg("./img/ac.png");
	b[y][x]:loadHImg("./img/black.png");
	b[y][x]:setDragable(false);
	b[y][x]:setText("./ttf/iosevkacc-regular.ttf",tostring(V),18,200,200,200);
	b[y][x]:fallDown(20+x*40,20+y*40)
						end -- if
		end --x
	end --y
		
end -- regenerateBlocks

--ENGINE HOOKS
function mouseHandler(x,y,mbS,mbF)
	local xI = 0;
	local yI = 0;
	local action = {}; --currently performed bricks action
	if (animationActive == true) then
	return 0
	end
  for yI = 1, GFM do
		for xI = 1, GFM do
		if (brick[yI][xI] ~= nil) then
			action = {brick[yI][xI]:processMouseEvent(x,y,mbS,mbF)};
		if (action[1] ~= false and action[1] ~= 0  and animationActive  ~= true) then
			local tmp = brick[yI][xI]; -- actual brick object
			local tmpV = bMatrix[yI][xI]; -- matrix value on game field
			io.write("action performed: ",action[1]," coords: x: ",xI," yI: ",yI,"\n")
			if (action[1] == 8 and yI > 1) then
			sMatrix[yI-1][xI] = 8;
			brick[yI][xI]:fallDown(20+xI*40,20+(yI-1)*40)
			brick[yI-1][xI]:fallDown(20+xI*40,20+(yI)*40)
			brick[yI][xI] = brick[yI-1][xI];
			brick[yI-1][xI] = tmp;
			bMatrix[yI][xI] = bMatrix[yI-1][xI];
			bMatrix[yI-1][xI] = tmpV;
			animationActive  = true;
			end
			
			if (action[1] == 2 and yI < GFM) then
			sMatrix[yI+1][xI] = 2;
			brick[yI][xI]:fallDown(20+xI*40,20+(yI+1)*40)
			brick[yI+1][xI]:fallDown(20+xI*40,20+(yI)*40)
			brick[yI][xI] = brick[yI+1][xI]
			brick[yI+1][xI] = tmp
			bMatrix[yI][xI] = bMatrix[yI+1][xI];
			bMatrix[yI+1][xI] = tmpV;
			animationActive  = true;
			end
			
			if (action[1] == 4 and xI > 1) then
			sMatrix[yI][xI-1] = 4;
			brick[yI][xI]:fallDown(20+(xI-1)*40,20+yI*40)
			brick[yI][xI-1]:fallDown(20+xI*40,20+yI*40)
			brick[yI][xI] = brick[yI][xI-1]
			brick[yI][xI-1] = tmp
			bMatrix[yI][xI] = bMatrix[yI][xI-1];
			bMatrix[yI][xI-1] = tmpV;
			animationActive  = true;
			end
			
			if (action[1] == 6 and xI < GFM) then
			sMatrix[yI][xI+1] = 6;
			brick[yI][xI]:fallDown(20+(xI+1)*40,20+yI*40)
			brick[yI][xI+1]:fallDown(20+xI*40,20+yI*40)
			brick[yI][xI] = brick[yI][xI+1]
			brick[yI][xI+1] = tmp
			bMatrix[yI][xI] = bMatrix[yI][xI+1];
			bMatrix[yI][xI+1] = tmpV;
			animationActive  = true;
			end
			
			end -- if action performed
						end -- if brick != nil
		end --x
	end -- y
return 0	
end --function

--main event loop goes here
function LoopHandler()

	local x = 0;
	local y = 0;
	animationActive = false;
  for y = 1, GFM do
		for x = 1, GFM do
		if (brick[y][x] ~= nil) then
			if (brick[y][x]:processAnimationEvent() > 0 ) then
			animationActive  = true;
			end
			end
		end
	end	
	if (animationActive == false ) then
	checkField(bMatrix,mMatrix);
	cleanUpBoard(brick,bMatrix,mMatrix);
	processSwaps();
	fallDownBlocks(brick,bMatrix,mMatrix);
	regenerateBlocks(brick,bMatrix,mMatrix);
	end
return 0
end
--ENGINE HOOKS END


init(brick,bMatrix,mMatrix)
