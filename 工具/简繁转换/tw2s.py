import sys
import os
import opencc
import re

tw2sp = opencc.OpenCC('tw2sp.json') #台湾繁体转简体，并转换常用词条

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
file = open(fullpath, 'r', encoding='utf-8')
text = file.read()
file.close()

# 转换为简体
textzh = tw2sp.convert(text)

# 处理个别转换错误
textzh = textzh.replace('诀云势', '决云势')
textzh = textzh.replace('悬象着明', '悬象著明')
textzh = textzh.replace('征逐', '徵逐')
if (re.search(r'[\'\"]征[\'\"]', textzh)) or re.search(r'[\'\"]变征[\'\"]', textzh):
    textzh = textzh.replace('征', '徵')


# 保存到新文件
newfilepath = filedir + '\\' + filename + '_ZH.lua'
newfile = open(newfilepath, 'w', encoding='gb18030')
newfile.write(textzh)
newfile.close()

#os.system('pause')
