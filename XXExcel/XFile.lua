
local XFile = class("XFile")
local XValue = require("XValue")

function XFile:ctor(filename)
	print("解析文件",filename)
    -- 数据文件
    self.list = require("_ceche."..filename)
    -- 关键字行
    self.keys = table.remove(self.list,1)
    -- 类型
    self.types = table.remove(self.list,1)

    local filepath = publish_path.."/"..filename..".lua"
    self.output = io.open(filepath,"w+")
    self.output:write("local mapArray = MEMapArray:new()\n")
end

function XFile:parse()
    for _,line in pairs(self.list) do
        local str=""
        for i=1,#line do
            local value = XValue:new(self.keys[i],self.types[i],line[i])
            local s = value:toString()
            if s~="" then 
                str=string.format("%s %s,",str,s)
            end
        end
        str=string.format("mapArray:push({%s})\n",string.sub(str,1,#str-1))
        self.output:write(str)
    end
end

function XFile:close()
    self.output:write("return mapArray")
    self.output:close()
end


return XFile