import sys
import os
import datetime
import re

#!dstPath出力パス,srcPath入力パス,srcDir入力ディレクトリ
suffix = '.mcfunction'
defaultdstPath = 'converted'

args = sys.argv
try:
    srcPath = args[1]
except:
    print("変換ファイルパスを入力")
    srcPath = input()

# ファイルパスが存在するかを検知
if os.path.exists(srcPath):
    print("ファイルパスを認識")
else:
    print("ファイルパスが無効です。")
    exit()

try:
    dstPath = args[2]
except:
    dstPath = 'converted.mcfunction'
finally:
    dstPath = dstPath + suffix
    if dstPath.count('.mcfunction') == 2:
        dstPath = dstPath.replace('.mcfunction{2}', '.mcfunction')

# ファイルのディレクトリ
srcDir = os.path.split(srcPath)[0]
dstPath = srcDir + "/" + dstPath
print("出力ファイルパス " + dstPath)
TestFind = os.path.exists(dstPath)
if TestFind:
    while True:
        print("既存ファイルを削除しますか？(Y/n)")
        cfmDelete = input()
        if cfmDelete.lower() == 'n':
            print("ファイル名を変更する等措置を行い、改めて実行してください。")
            exit()
        elif cfmDelete.lower() == 'y':
            print("ファイルを新規に作成します。")
            os.remove(dstPath)
            break
else:
    print("新規にファイルを作成します。\n" + dstPath)

inText = open(dstPath, 'a', encoding='UTF-8')
# タイムスタンプ取得用
dt_now = datetime.datetime.now()
dateText = dt_now.strftime("%Y/%m/%d %H:%M:%S")

inText.write("#NEKOYAMA Converter " + str(dateText) + " converted\n")
inText.close

outText = open(dstPath, 'a', encoding='UTF-8')

######################################
def argument_convert(lineArg,argCnt):
    lineArg = 'execute @e[type=armor_stand,r=3]'
    getArg = re.search(r'\@.\[(.+)\]',lineArg)
    getArg = getArg.group(0)
    argList = re.findall(r'|')
    #Untitled-1.py
    return getArg
######################################
def type_convert(cmdType,cmdConv):
    if cmdType is 1:


        result = cmdConv
    return result
######################################
def command_text_convert(cmdLine):
    #execute以外にも対応させる
    #startswithは標準ライブラリのメソッドなので
    if cmdLine.startswith("#"):
        print("コメント行です。")
        convType = 0
    elif cmdLine.startswith("\n"):
        print("空白行です。")
        convType = 0
    elif cmdLine.startswith("execute"):
        print("executeコマンドです。")
        convType = 1
    else:
        print("コマンド構文自体の変換は必要ありません。")
        convType = 0

    if cmdLine.startswith("#") == False and re.search('\@', cmdLine):
        cntSelector = cmdLine.count('@')
        if re.search('\[', cmdLine):
            print("このコマンドは引数付きセレクタがあります。")
            convTypeSlc = True
        else:
            print("このコマンドはセレクタがありますが変換は不要です。")
            convTypeSlc = False
        #引数はここで変換し、文字列全体を返す。
        if convTypeSlc:
            cmdLine = argument_convert(cmdLine,cntSelector)

    if convType >= 1:
        convResult = type_convert(convType,cmdLine)
    else:
        convResult = cmdLine

        #convTypeはこれからパターンが増える
    return convResult
######################################

#!変換の流れ
textRead = open(srcPath, "r", encoding="utf_8")
beforeText = textRead.readlines()
textRead.close()
print("変換テキストを読み込みました。")
for i in range(0, 10000):
    try:
        lineText = beforeText[i]
    except:
        lineText = ""

    print("\n\nINPUT-" + lineText)
    if lineText:
        print("変換処理を実行します")
        outText.write(command_text_convert(lineText))
    else:
        print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
        print("path : " + srcDir + "  filename : " + dstPath +
              "\nfullPath : " + srcDir + "/" + dstPath)
        exit()
