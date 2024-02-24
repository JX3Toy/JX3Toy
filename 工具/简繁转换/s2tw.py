import sys
import os
import opencc

s2twp = opencc.OpenCC('s2twp.json') #简体转台湾繁体，并转换常用词条

# 判断参数
if len(sys.argv) < 2 :
    print('没有指定需要处理的文件')
    os.system('pause')
    exit()

fullpath = sys.argv[1]  # 完整路径

# 判断文件是否存在
if not os.path.exists(fullpath) :
    print('指定文件不存在')
    os.system('pause')
    exit()

# 路径处理
filename_ext = os.path.basename(fullpath)       #文件名, 带扩展名
filedir = os.path.dirname(fullpath)             #目录名, 结束不带斜杠
filename = os.path.splitext(filename_ext)[0]    #文件名, 不带扩展名

# 读取文件
file = open(fullpath, 'r', encoding='gb18030')
text = file.read()
file.close()

# 转换为繁体
texttw = s2twp.convert(text)

# 处理个别转换错误
texttw = texttw.replace('決雲勢', '訣雲勢')


# 保存到新文件
newfilepath = filedir + '\\' + filename + '_TW.lua'
newfile = open(newfilepath, 'w', encoding='utf-8')
newfile.write(texttw)
newfile.close()

#os.system('pause')
