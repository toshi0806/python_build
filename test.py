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
    #セレクタの重複は分割してこの関数を実行してセレクタが一個の状態でのみ動作するものとする
    #if ArgCnt >= 2
    #    print("変換処理でエラーが発生しました。")
    #    exit()
    lineArg = 'execute @e[type=armor_stand,r=2222,rm=12,m=a,type=!player,name="example 1",l=10,lm=4,dx=6,dy=3,dz=7,scores={example=7},x=7,y=4,z=-636] ~ ~ ~ summon zombie'
    getArg = re.search(r'\@.\[(.+)\]',lineArg)
    getArg = getArg.group(0)[:-1]
    lineArg = lineArg.replace(getArg,'SELECTOR_')
    print("IN:" + str(getArg))
    argCnt = getArg.count(",")
    argListOld = list()
    argList = list()
    argListTemp = list()
    argList.append("SELTYPE=" + getArg[0:2])
    while argCnt:
        posArg = getArg.rfind(',')
        argListOld.append(getArg[posArg+1:])
        getArg = getArg[:posArg]
        if argCnt is 1:
            argListOld.append(getArg[3:])
        argCnt -= 1
    argCnt = len(argListOld)

    #引数を変換するための一部特殊構成引数構築のためのフラグ
    distanceBuild = disMin = disMax = False
    levelBuild = levMin = levMax = False

    while argCnt:
        if argListOld[argCnt-1].startswith(("type=","name=","x=","y=","z=","dx=","dy=","dz=","scores=")):
            convArg = argListOld[argCnt-1]
        elif argListOld[argCnt-1].startswith("r="):
            distanceBuild = True
            disMax = argListOld[argCnt-1][2:]
        elif argListOld[argCnt-1].startswith("rm="):
            distanceBuild = True
            disMin = argListOld[argCnt-1][2:]
        elif argListOld[argCnt-1].startswith("l="):
            levelBuild = True
            levMax = argListOld[argCnt-1][2:]
        elif argListOld[argCnt-1].startswith("lm="):
            levelBuild = True
            levMin = argListOld[argCnt-1][2:]
        elif argListOld[argCnt-1].startswith("m="):
            modeTemp = argListOld[argCnt-1]
            if modeTemp.endswith("a"):
                modeTemp = "gamemode=adventure"
            elif modeTemp.endswith("c"):
                modeTemp = "gamemode=creative"
            elif modeTemp.endswith("s"):
                modeTemp = "gamemode=survival"
            convArg = modeTemp
        try:
            argListTemp.append(convArg)
        except:
            print("Failed append" + argListOld[argCnt-1])
        convArg = "DELETED"
        argCnt -= 1
    if disMin is None:
        disMin = ""
    if disMax is None:
        disMax = ""
    if levMin is None:
        levMin = ""
    if levMax is None:
        levMax = ""

    if distanceBuild:
        disArg = "distance" + disMin + ".." + disMax
        argListTemp.append(disArg)
    if levelBuild:
        levArg = "level" + levMin + ".." + levMax
        argListTemp.append(levArg)

    argCnt = len(argListTemp)
    while argCnt:
        if argListTemp[argCnt-1] is not "DELETED":
            argList.append(argListTemp[argCnt-1])
        argCnt -= 1
    #print(str(argList))

    argCnt = len(argList)
    outLineArg = argList[0][-2:] + "["
    while argCnt is not 2:
        outLineArg = outLineArg + argList[argCnt-1] + ","
        argCnt -= 1
    outLineArg = outLineArg + argList[argCnt-1]
    print("OUT:" + outLineArg)
    lineArg = lineArg.replace('SELECTOR_',getArg)
    return lineArg
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
