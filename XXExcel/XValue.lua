local XValue = class("XValue")

function XValue:ctor(key,type,value)
	-- print(key,type,value)
	self.key=key
	self.type=type
	self.value=value
end
function XValue:isKeyNil()
	return self.key==nil or self.key==""
end
function XValue:isValueNil()
	return self.value==nil or self.value==""
end
function XValue:toString()
	if self:isKeyNil() or self:isValueNil() then 
		return ""
	end
	
	local str = THandle(self.type,self.value)
	return string.format("%s=%s",self.key,str)
end

return XValue