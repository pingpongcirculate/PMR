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


function commonTools.inheritsFrom( baseClass )

    -- The following lines are equivalent to the SimpleClass example:

    -- Create the table and metatable representing the class.
    local new_class = {}
    local class_mt = { __index = new_class }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    -- The following is the key to implementing inheritance:

    -- The __index member of the new class's metatable references the
    -- base class.  This implies that all methods of the base class will
    -- be exposed to the sub-class, and that the sub-class can override
    -- any of these methods.
    --
    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    return new_class
end

return commonTools