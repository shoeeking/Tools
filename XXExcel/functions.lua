print_ = print

function string.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(str, delimiter, pos) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

function print(...)
	local dbg = debug.getinfo(2)
    local path = string.split(dbg.source,"[/\\]")
	local detais = string.format("[%s#Line:%s]",path[#path],dbg.currentline)
    return print_(detais,...)
end
