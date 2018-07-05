 # -- coding: UTF-8
import os
import os.path

#遍历根目录
rootdir = r"E:\CreatorSpace\BeeWar\build\wechatgame\res"
# 导出文件路径
destdir=r"resource1.lua"


# 对齐字符
def TStr(n,width):
	bit=4
	if n>width*bit:
		return ""
	else:
		nwidth = n//bit
		left=width-nwidth
		tstr=""
		for i in range(left):
			tstr=tstr+"\t"
		return tstr

def main():
	# 文件数量
	total_num = 0;
	# 文件列表
	file_map={}
	# 写入文件
	output = open(destdir ,"w")
	output.write("local resource = {\n")
	# 遍历文件
	for parent,dirnames,filenames in os.walk(rootdir):
		for filename in filenames:
			(_f,fileext) = os.path.splitext(filename)
			if fileext==".json":
				total_num+=1
				# 写入文件
				full_path =  os.path.join(parent,filename)
				full_path = full_path.replace("\\","/")
				output.write("\t\""+full_path+"\",\n")

	output.write("}\n")
	output.write("return resource")
	output.close()

	print "%d files"%(total_num)
	print "complete "

if __name__ == "__main__":
	main()
