publish_path = "./"
root_path="_ceche"
require("functions")
require("class")
require "lfs" 
require("macro")
local XFile = require("XFile")


--get filename
function getFileName(str)
    local idx = str:match(".+()%.%w+$")
    if(idx) then
        return str:sub(1, idx-1)
    else
        return str
    end
end
function getExtension(str)
    return str:match(".+%.(%w+)$")
end


publish_path=arg[1]
for entry in lfs.dir(root_path) do
	if entry ~= '.' and entry ~= '..' then
		local path = root_path .. '\\' .. entry
		local attr = lfs.attributes(path)
		--print(path)
		local filename = getFileName(entry)
		if attr.mode ~= 'directory' then
			-- 文件后缀
			local postfix = getExtension(entry)
			local file = XFile:new(filename)
			file:parse()
			file:close()
		end
	end
end

