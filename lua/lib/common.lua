--some miscelanious commonly used hacks
local commonTools = {}
commonTools.objIndex = 1
commonTools.animations = {}

function commonTools.getObjIdx()
commonTools.objIndex = commonTools.objIndex + 1
return commonTools.objIndex
end

function commonTools.animationManager()
for key,value in pairs(commonTools.animations) do

  if (value ~= nil) then
	value()
	    end
    end --animations list iterator
    return 0
end

function commonTools.addAnimation(index,fn)
commonTools.animations[index] = fn
return 0
end

function commonTools.delAnimation(index)
commonTools.animations[index] = nil
return 0
end

function commonTools.init()
commonTools.objIndex = 1
commonTools.animation = nil
commonTools.animations = {}
animationTimer = commonTools.animationManager
end

return commonTools