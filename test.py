import sys
import os
import datetime
import re
from typing import AsyncGenerator

cmdExeList = list()
cmdExeList.clear
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
            print("ファイル名を変更するか、移動させてから実行してください。")
            exit()
        elif cfmDelete.lower() == 'y':
            print("ファイルを削除し変換します。")
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
def argument_convert(lineArg):
    argChecker = re.search(r'\@.\[',lineArg)
    if argChecker is None:
        print("[引数変換]引数付きセレクタを判定出来ませんでした。無変換で続行します。")
        print("CMD:" + lineArg)
        return lineArg
    argCnt = lineArg.count(r'\@.\[')
    #セレクタの重複は分割してこの関数を実行してセレクタが一個の状態でのみ動作するものとする
    if argCnt >= 2:
        print("[引数変換]セレクタを二個以上判定しました。 Selector:" + str(argCnt))
        print("errorCMD:" + lineArg)
        exit()
        
    #lineArg = "execute @e[type=armor_stand]"
    getArg = re.search(r'\@.\[(.+)\]',lineArg).group(0)[:-1]
    lineArg = lineArg.replace(getArg,'SELECTOR_')
    print("IN:" + str(getArg))
    argListOld = list()
    argList = list()
    argListTemp = list()
    argListOld.clear()
    argList.clear()
    argListTemp.clear()
    selEntity = getArg[0:2]
    #selEntityはセレクタのタイプを保存し、後から構成するときに使用

    #引数を抜き取ってargListOldリストに追加していく
    #getArg<@e[type=!player,r=3 <--最後の,の文字数目を取得(posArg)し
    #posArg+1文字目から最後までの文字列を抜き取る
    argFlag = True
    posArg = getArg.rfind(',')
    #scores引数内コロンを区別するため、あらかじめargListOldに追加しDELETEDとして続行する

    if posArg is -1:
        argListOld.append(getArg[3:])
        argFlag = False
        print("[convArg]引数が一つのため、抜き取りました。 --> " + str(argListOld))
        
    while argFlag:
        #最初から引数がないとposArg=-1
        posArg = getArg.rfind(',')
        ArgCnt = getArg.count(',')
        argListOld.append(getArg[posArg+1:])
        getArg = getArg[:posArg]
        #print(getArg)
        if ArgCnt <= 1:
            endArg = getArg.rfind('[')
            #print(str(getArg) + " " + str(endArg))
            argListOld.append(getArg[endArg+1:])
            print("[convArg]複数の引数を抜き取りました。 --> " + str(argListOld))
            break
    
    argCnt = len(argListOld)

    #引数を変換するための一部特殊構成引数構築のためのフラグ
    distanceBuild = disMin = disMax = False
    levelBuild = levMin = levMax = False
    print("Oldの引数は" + str(len(argListOld)) + "個です。")
    try:
        argListTemp.append(re.search(r'scores=\{.\,*.*\}',getArg).group(0))
    except:
        print("[convArg]scores引数はありません。")
    else:
        print("[convArg]scores引数を取得しました。 --> " + argListTemp[0])
        getArg = re.sub(argListTemp[0],'DELETED',getArg)
    for i in range(0,len(argListOld)):
        selTemp = argListOld[i]
        print("selTemp --> " + selTemp)
        if selTemp.startswith(("type=","name=","x=","y=","z=","dx=","dy=","dz=","scores=","tag=")):
            print("[convArg]変換不要引数です --> " + selTemp)
            argListTemp.append(selTemp)
        elif selTemp.startswith("r="):
            #r,rm,l,lmはあとから構築
            distanceBuild = True
            disMax = selTemp[2:]
        elif selTemp.startswith("rm="):
            distanceBuild = True
            disMin = selTemp[3:]
        elif selTemp.startswith("l="):
            levelBuild = True
            levMax = selTemp[2:]
        elif selTemp.startswith("lm="):
            levelBuild = True
            levMin = selTemp[2:]
        elif selTemp.startswith("m="):
            print("[convArg]gamemode引数に変換します。 --> " + selTemp)
            selTemp = str(re.sub('m=','gamemode=',selTemp))
            if selTemp.endswith("a"):
                selTemp += "dventure"
            elif selTemp.endswith("c"):
                selTemp += "reative"
            elif selTemp.endswith("s"):
                selTemp += "urvival"
            argListTemp.append(selTemp)
        elif selTemp.startswith("c="):
            print("[convArg]limit引数に変換します。 --> " + selTemp)
            argListTemp.append(str(re.sub('c=','limit=',selTemp)))
        elif selTemp.startswith("DELETED"):
            selTemp = ""
        else:
            print("[convArg]例外エラー : " + selTemp)
            argListTemp.append(selTemp)

    if disMin is False:
        disMin = ""
    if disMax is False:
        disMax = ""
    if levMin is False:
        levMin = ""
    if levMax is False:
        levMax = ""

    #r,rm,l,lmの構築
    if distanceBuild:
        print("[convArg]distance引数を生成します。 ")
        print("min " + str(disMin) + "/ max" + str(disMax))
        disArg = "distance=" + disMin + ".." + disMax
        argListTemp.append(disArg)
    if levelBuild:
        print("[convArg]level引数を生成します。 ")
        levArg = "level" + levMin + ".." + levMax
        argListTemp.append(levArg)

    print("[convArg]現在の引数の数 --> " + str(len(argListTemp)) + "\n" + str(argListTemp))
    
    #めんどくさいので代入
    argList = argListTemp

    argCnt = len(argList)
    print("最終的な引数の数 <-- " + str(argCnt) + "\nArglist -->" + str(argList))
    #outLineArg = "@" + selEntity + "["
    outLineArg = selEntity + "["
    while argCnt >= 2:
        outLineArg = outLineArg + argList[argCnt-1] + ","
        argCnt -= 1
    outLineArg = outLineArg + argList[argCnt-1]
    lineArg = lineArg.replace('SELECTOR_',outLineArg)
    print("引数変換後出力 = " + lineArg)
    return lineArg
#####################################
def type_convert(cmdEnume):
    TCmode = False

    result = cmdEnume
    return result,TCmode
######################################
def list_in_execute_and_other_command(cmdLineWrite,exePos,TCmode):
    print("[other]通常コマンドを分離させます")
    #ALL_COMMANDと繰り返し比較し、分割したらcmdExeListへ
    ALL_COMMAND = list()
    ALL_COMMAND = ['clear ','clone ','difficulty ','effect ','enchant ','event ','xp ','fill ','fog ','function ','gamemode ','gamerule ','gametest ','getchunkdata ','getlocalplayername ','getspawnpoint ','give ','globalpause ','immutableworld ','kick ','kill ','list ','listd ','locate ','locatebiome ','me ','mobevent ','msg ','w ','music ','particle ','permission ','playanimation ','playsound ','querytarget ','reload ','replaceitem ','ride ','save ','say ','schedule ','scoreboard ','setblock ','setmaxplayers ','setworldspawn ','spawnpoint ','spreadplayers ','stop ','stopsound ','structure ','summon ','tag ','tp ','teleport ','tellraw ','testfor ','testforblock ','testforblocks ','tickingarea ','time ','title ','titleraw ','toggledownfall ','wb ','weather ','whitelist ','worldbuilder ','wsserver']
    ALL_COMMAND_CNT = len(ALL_COMMAND)
    while ALL_COMMAND_CNT is not 0:
        exePos = cmdLineWrite.rfind(ALL_COMMAND[ALL_COMMAND_CNT-1])
        ALL_COMMAND_CNT -= 1
        if exePos is not -1:
            print("[other]分離コマンド --> " + ALL_COMMAND[ALL_COMMAND_CNT])
            break
    cmdExeList.append(cmdLineWrite[exePos:])
    cmdLineWrite = cmdLineWrite[:exePos-1]
    #分離させた通常コマンドをListに入れてその分を削除
    
    print("[other]通常コマンド分離後 --> " + cmdExeList[0])
    exeCnt = cmdLineWrite.count('execute')
    while exeCnt >= 2:
        exePos = cmdLineWrite.rfind('execute')
        print("[other]execute重複抜き取り,exeCnt --> " + cmdLineWrite[exePos:] + " " + str(exeCnt))
        cmdExeList.append(cmdLineWrite[exePos:])
        cmdLineWrite = cmdLineWrite[:exePos-1]
        exeCnt -= 1
    cmdExeList.append(cmdLineWrite)
    print("[other]分離コマンドリスト --> " + str(cmdExeList))

    for i in range(0,len(cmdExeList)):
        cmdExeList[i] = argument_convert(cmdExeList[i])
        cmdExeList[i],TCmode = type_convert(cmdExeList[i])

    print("[other]通常コマンドを分離させて、変換しました。 --> " + str(cmdExeList))
    TCmode= False

    return cmdLineWrite,TCmode
######################################
def command_text_convert(cmdLine):
    multiCmd = False
    typeConvert = True
    #execute以外にも対応させる
    #startswithは標準ライブラリのメソッ
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
    print("command_text_convert <-- " + cmdLine)
    if cmdLine.startswith("#"):
        cntSelector = 0
    else:
        cntSelector = cmdLine.count('@')
        print("cntSelector = " + str(cntSelector))

    #セレクタの数に応じて処理分岐
    if cntSelector is 1:
        print("セレクタを検知しました。")
        cmdLine = argument_convert(cmdLine)
    elif cntSelector >= 2:
        print("複数のセレクタを検知しました。")
        #executeのeの部分の文字数目が入る。
        try:
            exePos = cmdLine.rfind('execute')
        except:
            print("tpコマンドか、scoreboard players operationによるセレクタ複数指定の可能性があります。")
        print("ループ前executeの位置:" + str(exePos) + "\n" + cmdLine)
        #複数のセレクタがある→分解しcmdExeTestに入る。
        exeConvMulti = True
        if exePos is 0:
            cmdLine,typeConvert = list_in_execute_and_other_command(cmdLine,exePos,typeConvert)
            print(str(cmdExeList))
            exeConvMulti = False
        while exePos >= 1 and exeConvMulti:
            cmdLine,typeConvert = list_in_execute_and_other_command(cmdLine,exePos,typeConvert)
            cmdLine = cmdLine[:exePos]
            exePos = cmdLine.rfind('execute')
            if exePos is 0:
                print("executeコマンドを二個以上検知しました。")
                multiCmd = True
                break
        #list_in_execute_and_other_command が引数変換、execute分解まで実行する
        print("List --> " + str(cmdExeList))
        multiCmd = True

    if convType is not 0 and re.search('\@', cmdLine) and multiCmd is None:
        if re.search(r'\@.\[', cmdLine):
            print("このコマンドは引数付きセレクタがあります。")
            cmdLine = argument_convert(cmdLine)
        else:
            print("このコマンドはセレクタがありますが変換は不要です。")
       
#    if convType is not 0 and multiCmd is False:
#        convResult,typeConvert = type_convert(convType)
#    #↓multiCmdフラグが立っているとき、配列のセレクタそれぞれ変換して最終的に構成する
#    elif multiCmd:
#        cmdLineExe = list()
#        exeListCnt = len(cmdExeList)
#        while exeListCnt is not 0:
#            cmdExeBuild = list()
#            cmdExe_cmdLine = cmdExeList.pop(0)
#            exeListCnt = len(cmdExeList)
#            cmdExe_cntSelector = cmdExe_cmdLine.count('@')
#            print("[cmdExe]cmdLine=" + cmdExe_cmdLine)
#            if re.search(r'\@.\[', cmdExe_cmdLine):
#                print("[cmdExe]セレクタを変換。")
#                buildConv = argument_convert(cmdExe_cmdLine)
#                cmdExeBuild.append(buildConv)
#                print("[cmdExe]セレクタ変換後 --> " + buildConv)
#            else:
#                print("[cmdExe]セレクタがありますが変換は不要です。")
#                cmdExeBuild.append(cmdExe_cmdLine)

#        print("[cmdExe]分割されたコマンドを構築します。 " + str(cmdExeBuild))
#        exeListCnt = len(cmdExeBuild)
#        exeListCntMax = exeListCnt
#        convResult = ""
#        for i in range(1,len(cmdExeBuild)):
#            convResult = convResult + cmdExeBuild.pop(0)[exeListCntMax-i]
#    else:
#        convResult = cmdLine
#        #convTypeはこれからパターンが増える
#        multiCmd = False
# ^^^ これらはlist_in_execute_and_other_commandが代理実行する

    if typeConvert:
        convResult,typeConvert = type_convert(cmdLine)
    
    return convResult
######################################

#!変換の流れ
textRead = open(srcPath, "r", encoding="utf_8")
beforeText = textRead.readlines()
textRead.close()

cnt = len(beforeText)
print("変換テキストを読み込みました。")
for i in range(0,cnt):
    lineText = beforeText[i]

    print("INPUT-" + lineText)
    if lineText:
        print("変換処理を実行します <-- " + lineText)
        cnv = str(command_text_convert(lineText))
        print("cnv = " + cnv)
        if re.search('\n', cnv) is None:
            cnv += "\n"
        outText.write(cnv)
    else:
        print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
        print("path : " + srcDir + "  filename : " + dstPath +
              "\nfullPath : " + srcDir + "/" + dstPath)
        exit()
