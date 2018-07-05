function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        cls.__cname = classname
        cls.__ctype = 1

        function cls:new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            if cls ~= TFLabel then
                for k,v in pairs(cls) do instance[k] = v end
            end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls:new(...)
            local instance = {}
            instance.class = cls
            setmetatable(instance, cls)
            instance:ctor(...)
            return instance
        end
    end

    function cls:create(...)
        return cls:new(...)
    end
    
    return cls
end