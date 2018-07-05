# coding=utf-8
import xlrd
import sys
import os.path

reload(sys)
# 需要加上，否则会报UnicodeEncodeError: 'ascii' codec can't encode characters in position 0-1: ordinal not in range(128)
sys.setdefaultencoding('utf-8')

excel_root = u"E:\\..xx\\project"
ceche_root = u"_ceche"

class ExcelAction:
    '''
    只支持xls格式
    '''
    def transCode(self, filename, sheetname):
        filename = filename.decode('utf-8')
        sheetname = sheetname.decode('utf-8')
        return filename, sheetname

    def read_excel(self, filename, sheetname):
        print(filename+"，"+sheetname)
    	'''
    	写文件
    	'''
        filename, sheetname = self.transCode(filename, sheetname)
        tempfilename = os.path.basename(filename)
        (file_name,extension)=os.path.splitext(tempfilename)
        file_object = open(ceche_root+"./"+file_name+'.lua','w+')
        file_object.write("return {\n")
        '''
        读取excel
        '''

        workbook = xlrd.open_workbook(filename)  # 获得工作薄
        sheet = workbook.sheet_by_name(sheetname)  # 获得sheet
        rows = sheet.nrows  # 文件总行数
        list = []
        line0 = sheet.row_values(1)  # 获得一行的值，返回列表
        # list.append(line)
        # 避免打印包含中文的列表时变成unicode
        file_object.write('\t{' + ','.join("'" + str(element) + "'" for element in line0) + '},\n')
        for i in range(2, rows):
            line = sheet.row_values(i)  # 获得一行的值，返回列表
            list.append(line)
            row_content = []
            for k in range(len(line)):
                ctype = sheet.cell(i,k).ctype  # 表格的数据类型
                cell = line[k]
                if ctype == 2 and cell % 1 == 0:  # 如果是整形
                    cell = int(cell)
                elif ctype == 4:
                    cell = True if cell == 1 else False
                row_content.append(cell)
            # 避免打印包含中文的列表时变成unicode
            file_object.write('\t{' + ','.join("'" + str(element) + "'" for element in row_content) + '},\n')
            # file_object.write('\t{' + ','.join(line0[j] + "=" + "'" + str(row_content[j]) + "'" for j in range(len(row_content))) + '},\n')
        file_object.write("}")
        file_object.close()
        return list

if __name__ == '__main__':
    print(sys.argv)
    if len(sys.argv)>=2:
        excel_root = sys.argv[1]
    path = os.path.expanduser(excel_root)
    num=0
    total=0
    for (dirname, subdir, subfile) in os.walk(path):
        for fullname in subfile:
            total=total+1
            fullpath = os.path.join(dirname, fullname)
            (filename,fileext) = os.path.splitext(fullname)
            if ".xlsx"==fileext:
                num=num+1
                print('导出'+fullpath)
                ea = ExcelAction()
                list = ea.read_excel(fullpath, filename)
    print("检测到"+str(total)+"个文件，导出"+str(num)+"个文件")