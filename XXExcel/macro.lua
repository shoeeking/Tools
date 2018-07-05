V_INT 		= "int"		-- 整形
V_STRING	= "string"	-- 字符串
V_BOOL		= "bool"	-- 布尔型
V_POINT		= "point"	-- 坐标
V_ITEM		= "item"	-- 道具 {编号，类型，数量}
V_FLOAT	 	= "float" 	-- 浮点型
V_LIST 		= "list"	-- 列表 以","分割

V_VECTOR	= "vector"	-- 复合类型，以|分割

-- 分割字符串
function Split(szFullString, szSeparator) 
	if string.split then 
		return string.split(szFullString, szSeparator) 
	end
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}
	if szFullString or szFullString=="" then 
		return nSplitArray
	end
	while true do  
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
	   	if not nFindLastIndex then  
	    	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
	    	break  
	   	end  
	   	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
	   	nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
	   	nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end
function THandle(str,value)
	local tb={
		[V_INT] = _int,
		[V_STRING] = _string,
		[V_BOOL] = _bool,
		[V_POINT] = _point,
		[V_ITEM] = _item,
		[V_FLOAT] = _float,
		[V_LIST] = _list,
	}
	local func = tb[str]
	-- 单类型
	if func then 
		return func(value)
	end
	-- 复合类型
	local regex = "(%a+)<(%a+)>"
	local iter = string.gfind(str, regex)
	local vector ,vtype = iter()
	if vector==V_VECTOR then
		return _vector(vtype,value)
	end
	return ""
end
function _int(str)
	local n = tonumber(str)
	if not n then
		print("不是整数",str)
		return "0"
	end
	local mint = math.floor(n)
	return tostring(mint)
end
function _string(str)
	return string.format("'%s'",str)
end
function _bool(str)
	if str=="1" then 
		return "true"
	end
	return "false"
end
function _point(str)
	local list = Split(str,",")
	if #list<2 then
		print(#list)
		return "ccp(0,0)"
	end
	return string.format("ccp(%s,%s)",list[1],list[2])
end
function _item(str)
	local list=Split(str,",")
	if #list<3 then return "" end
	return string.format("{id=%s,type=%s,num=%s}",list[1],list[2],list[3])
end
function _float(str)
	return str
end
function _list(str)
	local list=Split(str,",")
	local s = ""
	for i=1,#list do
		s = s.."'"..list[i].."',"
	end
	s = string.sub(s,1,#s-1)
	return string.format("{%s}",s)
end

function _vector(t,str)
	local list=Split(str,"|")
	local s=""
	for i=1,#list do
		s=s..THandle(t,list[i])..","
	end
	s = string.sub(s,1,#s-1)
	return string.format("{%s}",s)
end


