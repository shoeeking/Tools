local cjson = require("cjson")
local jsfiles = require("resource1")


function json2table( jfile )
	local input = io.open(jfile,"r")
	local jsonData = input:read("*all")
	input:close()
	local decodeData = cjson.decode(jsonData)
	return decodeData
end
function spriteItem(data)
	local tb = {}
	tb.name=data.name
	tb.spriteOffset = "{0,0}"
	tb.spriteSize = string.format("{%d,%d}",data.rect[3],data.rect[4])
	tb.spriteSourceSize = string.format("{%d,%d}",data.originalSize[1],data.originalSize[2])
	tb.textureRect = string.format("{{%d,%d},{%d,%d}}",data.rect[1],data.rect[2],data.rect[3],data.rect[4])
	tb.textureRotated = data.rotated==1 and "<true/>" or "<false/>"
	return tb
end
function getTexture(list,texture)
	local tb = {}
	for _,item in pairs(list) do
		if item.content.texture==texture then 
			local data = spriteItem(item.content)
			table.insert(tb,data)
		end
	end
	return tb
end
function toPlist(list,filename,config)
	local filepath = "./plist/"..filename..".plist"
	output = io.open(filepath,"w+")
	-- begin
	output:write('<?xml version="1.0" encoding="UTF-8"?>\n')
	output:write('<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n')
	output:write('<plist version="1.0">\n')
	output:write('\t<dict>\n')
	-- frames
	output:write('\t\t<key>frames</key>\n')
	output:write('\t\t<dict>\n')
	for _,data in pairs(list) do
		output:write('\t\t\t<key>'..data.name..'</key>\n')
		output:write('\t\t\t<dict>\n')
		output:write('\t\t\t\t<key>aliases</key>\n')
		output:write('\t\t\t\t<array/>\n')
		output:write('\t\t\t\t<key>spriteOffset</key>\n')
		output:write('\t\t\t\t<string>'..data.spriteOffset..'</string>\n')
		output:write('\t\t\t\t<key>spriteSize</key>\n')
		output:write('\t\t\t\t<string>'..data.spriteSize..'</string>\n')
		output:write('\t\t\t\t<key>spriteSourceSize</key>\n')
		output:write('\t\t\t\t<string>'..data.spriteSourceSize..'</string>\n')
		output:write('\t\t\t\t<key>textureRect</key>\n')
		output:write('\t\t\t\t<string>'..data.textureRect..'</string>\n')
		output:write('\t\t\t\t<key>textureRotated</key>\n')
		output:write('\t\t\t\t'..data.textureRotated..'\n')
		output:write('\t\t\t</dict>\n')
	end
	output:write('\t\t</dict>\n')
	-- metadata
	output:write('\t\t<key>metadata</key>\n')
	output:write('\t\t<dict>\n')
	output:write('\t\t\t<key>format</key>\n')
	output:write('\t\t\t<integer>3</integer>\n')
	output:write('\t\t\t<key>realTextureFileName</key>\n')
	output:write('\t\t\t<string>'..filename..'.png</string>\n')
	output:write('\t\t\t<key>size</key>\n')
	output:write('\t\t\t<string>{507,1504}</string>\n')
	output:write('\t\t\t<key>smartupdate</key>\n')
	output:write('\t\t\t<string>$TexturePacker:SmartUpdate:f8405780d97c640e8ea87077bcdcd91f:94f4da1f81f94500509fefe236ae699d:9f125aa71c5c2418d32e9eacc87866c8$</string>\n')
	output:write('\t\t\t<key>textureFileName</key>\n')
	output:write('\t\t\t<string>'..filename..'.png</string>\n')
	output:write('\t\t</dict>\n')
	-- end
	output:write('\t</dict>\n')
	output:write('</plist>')
	output:close()
end

local typeList = {}
for i,path in pairs(jsfiles) do
	-- local path = "json/"..name..".json"
	local tb = json2table(path)
	print("转存文件",path)

	for i=1,#tb do
		local data = tb[i]
		if #data==0 then 
			typeList[data.__type__] = typeList[data.__type__] or {}
			table.insert(typeList[data.__type__],data)
		end
	end
end
print("============================转存文件完毕============================")

local plists = {
	Bee = {type="cc.SpriteFrame",texture="12cfae9f4",file="Bee"},
	card = {type="cc.SpriteFrame",texture="c6VM365EdGPZTD5i5wNbsZ",file="card"},
}
for _,config in pairs(plists) do
	print("生成文件",config.file)
	local textrueList = getTexture(typeList[config.type],config.texture)
	toPlist(textrueList,config.file,config)
end
print("============================PLIST完毕============================")