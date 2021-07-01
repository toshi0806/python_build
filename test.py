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


# タイムスタンプ取得用
dt_now = datetime.datetime.now()
dateText = dt_now.strftime("%Y/%m/%d %H:%M:%S")

inText = open(dstPath, 'a', encoding='UTF-8')
inText.write("#NEKOYAMA Converter " + str(dateText) + " converted\n")
inText.close

ALL_COMMAND = list()
ALL_COMMAND = ['clear ','clone ','difficulty ','effect ','enchant ','event ','xp ','fill ','fog ','function ','gamemode ','gamerule ','gametest ','getchunkdata ','getlocalplayername ','getspawnpoint ','give ','globalpause ','immutableworld ','kick ','kill ','list ','listd ','locate ','locatebiome ','me ','mobevent ','msg ','w ','music ','particle ','permission ','playanimation ','playsound ','querytarget ','reload ','replaceitem ','ride ','save ','say ','schedule ','scoreboard ','setblock ','setmaxplayers ','setworldspawn ','spawnpoint ','spreadplayers ','stop ','stopsound ','structure ','summon ','tag ','tp ','teleport ','tellraw ','tell ','testfor ','testforblock ','testforblocks ','tickingarea ','time ','title ','titleraw ','toggledownfall ','wb ','weather ','whitelist ','worldbuilder ','wsserver']
ALL_COMMAND_CNT = len(ALL_COMMAND)

######################################
def argument_convert(lineArg):
    argChecker = re.search(r'\@.\[',lineArg)
    if argChecker == None:
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

    if posArg == -1:
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
    xrotBuild = xrotMin = xrotMax = False
    yrotBuild = yrotMin = yrotMax = False
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
        elif selTemp.startswith("rx="):
            xrotBuild = True
            xrotMax = selTemp[3:]
        elif selTemp.startswith("rxm="):
            xrotBuild = True
            xrotMin = selTemp[4:]
        elif selTemp.startswith("ry="):
            yrotBuild = True
            yrotMax = selTemp[3:]
        elif selTemp.startswith("rym="):
            yrotBuild = True
            yrotMin = selTemp[4:]
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

    if disMin == False:
        disMin = ""
    if disMax == False:
        disMax = ""
    if levMin == False:
        levMin = ""
    if levMax == False:
        levMax = ""
    if xrotMin == False:
        xrotMin = ""
    if xrotMax == False:
        xrotMax = ""
    if yrotMin == False:
        yrotMin = ""
    if yrotMax == False:
        yrotMax = ""

    if distanceBuild:
        print("[convArg]distance引数を生成します。 ")
        disArg = "distance=" + disMin + ".." + disMax
        argListTemp.append(disArg)
    if levelBuild:
        print("[convArg]level引数を生成します。 ")
        levArg = "level" + levMin + ".." + levMax
        argListTemp.append(levArg)
    if xrotBuild:
        print("[convArg]x_rotation引数を生成します。 ")
        xrotArg = "x_rotation=" + xrotMin + ".." + xrotMax
        argListTemp.append(xrotArg)
    if yrotBuild:
        print("[convArg]y_rotation引数を生成します。 ")
        yrotArg = "y_rotation=" + yrotMin + ".." + yrotMax
        argListTemp.append(yrotArg)

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
def Normal_convert(cmdLine):
    print("通常コマンドの変換をおこないます。 --> " + cmdLine)
    #convTypeを廃止して、通常コマンドはこの関数で処理する。引数はcmdLineのみ。
    #executeコマンドの上にxpコマンドが乗っているとき変換できないためその改善策となる
    return cmdLine
#####################################
def type_convert(cmdEnume,convType):
    TCmode = False
    if convType <= 0:
        result = cmdEnume
        return result,TCmode
    #tcList配列をexecuteResultCmd変数に置き換えた executeコマンドの配列はseparateExecute配列
    separateExecute = list()
    separateExecute.clear()
    getSelList = list()
    getSelList.clear()
    tempSeparate = list()
    tempSeparate.clear()

    tcSelectorCnt = tcSelectorCnt_afterSeparate = cmdEnume.count('@')
    while tcSelectorCnt_afterSeparate >= 2:
        tempSeparate.append(cmdEnume[cmdEnume.rfind('@'):])
        cmdEnume = cmdEnume[:cmdEnume.rfind('@')]
        tcSelectorCnt_afterSeparate = cmdEnume.count('@')
        if tcSelectorCnt_afterSeparate == 1:
            tempSeparate.append(cmdEnume)
    tempSeparate = sorted(tempSeparate, reverse=True)
    if tcSelectorCnt < 2:
        tempSeparate.append(cmdEnume)
    cmdEnume = ""

    print("tempSeparate = " + str(tempSeparate))
    for i in range(0,tcSelectorCnt):
        try:
            getSelList.append(re.search(r'\@.\[(.+)\]',tempSeparate[i]).group(0))
        except:
            try:
                getSelList.append(re.search(r'\@.',tempSeparate[i]).group(0))
            except:
                print("セレクタの抽出をスルーしました。")
                break
            else:
                tempSeparate[i] = tempSeparate[i].replace(getSelList[i],'SELECTOR_')
        else:
            tempSeparate[i] = tempSeparate[i].replace(getSelList[i],'SELECTOR_')
        cmdEnume += tempSeparate[i]
    print("type_convert / getSelList = " + str(getSelList) + " tcSelectorCnt = " + str(tcSelectorCnt) + "\ncmdEnume = " + str(cmdEnume))

    #convType=1はexecuteコマンドに対応
    if convType == 1:
        print("[type_convert]execute 通常コマンドを分離させます")
        #ALL_COMMANDと繰り返し比較し、分割したらtcListへ
        for i in range(ALL_COMMAND_CNT,0,-1):
            separatePos = cmdEnume.rfind(ALL_COMMAND[i-1])
            if separatePos != -1:
                print("[type_convert]分離コマンド --> " + ALL_COMMAND[i-1] + "/ separatePos = " + str(separatePos))
                break
        executeResultCmd = cmdEnume[separatePos:]
        cmdEnume = cmdEnume[:separatePos-1]
        #分離させた通常コマンドをListに入れてその分を削除
        print("[type_convert]通常コマンド分離後 --> " + str(executeResultCmd))
        enumeExeCnt = cmdEnume.count('execute')
        while enumeExeCnt >= 2:
            separatePos = cmdEnume.rfind('execute')
            print("[type_convert]execute抜き取り --> " + cmdEnume[separatePos:])
            separateExecute.append(cmdEnume[separatePos:])
            cmdEnume = cmdEnume[:separatePos-1]
            enumeExeCnt -= 1
        separateExecute.append(cmdEnume)

        #execute以外も、SELECTOR_代入は最後実行する。
        result = "execute "
        for i in range(0,len(separateExecute)):
            result += "as " + getSelList[i] + " at @s "
        executeResultCmd = executeResultCmd.replace('SELECTOR_',getSelList[len(getSelList)-1])
        executeResultCmd = Normal_convert(executeResultCmd)
        result += "run " + executeResultCmd

    #convType=1はxpコマンドに対応
    #だったが廃止しすべてNormal_convertに受け渡して判別し変換処理をおこなう
    #セレクタを格納した配列をどう引き継ぐかを考える
    if convType <= 2:
        result = Normal_convert()
        result = 'xp add ' + getSelList[0]
        result += re.search(r'\s.?[0-9]+',cmdEnume).group(0)
        if cmdEnume.count('l ') == 1:
            cmdEnume.replace('l ',' ')
            result += ' levels '
        else:
            result += ' points '
    else:
        print("[type_convert]変換は必要ありません。")
    print("type_convert / result = " + result)
    return result,TCmode
######################################
def list_in_execute_and_other_command(cmdLineWrite,exePos,TCmode,convType):
    print("[other]通常コマンドを分離させます。")
    #ALL_COMMANDと繰り返し比較し、分割したらcmdExeListへ
    for i in range(ALL_COMMAND_CNT,0,-1):
        exePos = cmdLineWrite.rfind(ALL_COMMAND[i-1])
        if exePos != -1:
            print("[other]分離コマンド --> " + ALL_COMMAND[i-1] + "/ exePos = " + str(exePos))
            break
    cmdExeList.clear()
    cmdExeList.append(cmdLineWrite[exePos:])
    cmdLineWrite = cmdLineWrite[:exePos-1]
    #分離させた通常コマンドをListに入れてその分を削除
    
    print("[other]通常コマンド分離後 --> " + str(cmdExeList))
    exeCnt = cmdLineWrite.count('execute')
    while exeCnt >= 2:
        exePos = cmdLineWrite.rfind('execute')
        print("[other]execute重複抜き取り,exeCnt --> " + cmdLineWrite[exePos:] + " " + str(exeCnt))
        cmdExeList.append(cmdLineWrite[exePos:])
        cmdLineWrite = cmdLineWrite[:exePos-1]
        exeCnt -= 1
    cmdExeList.append(cmdLineWrite)
    print("[other]分離コマンドリスト --> " + str(cmdLineWrite))

    cmdLineWrite = ""
    for i in range(len(cmdExeList),0,-1):
        cmdLineWrite += argument_convert(cmdExeList[i-1])
        if i >= 1:
            cmdLineWrite += " "

    print("[other]通常コマンドを分離させて、変換しました。 --> " + str(cmdLineWrite))
    
    cmdLineWrite,TCmode = type_convert(cmdLineWrite,convType)
    TCmode= False

    return cmdLineWrite,TCmode
######################################
def command_text_convert(cmdLine):
    multiCmd = False
    typeConvert = True
    #startswithは標準ライブラリのメソッド
    if cmdLine.startswith("#"):
        print("コメント行です。")
        convType = 0
    elif cmdLine.startswith("\n"):
        print("空白行です。")
        convType = 0
    elif cmdLine.startswith("execute"):
        print("executeコマンドです。")
        convType = 1
    elif cmdLine.startswith("experience") or cmdLine.startswith("xp"):
        print("xpコマンドもしくはexperienceコマンドです。")
        convType = 2
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
    if cntSelector == 1:
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
        if exePos == 0:
            cmdLine,typeConvert = list_in_execute_and_other_command(cmdLine,exePos,typeConvert,convType)
            exeConvMulti = False
            print("executeコマンドを検知しませんでした。")
        if exePos >= 1 and exeConvMulti:
            cmdLine,typeConvert = list_in_execute_and_other_command(cmdLine,exePos,typeConvert,convType)
            print("executeコマンドを1個以上検知しました。")
            multiCmd = True

        #list_in_execute_and_other_command が引数変換、execute分解まで実行する
        multiCmd = True

    if convType != 0 and re.search('\@', cmdLine) and multiCmd == None:
        if re.search(r'\@.\[', cmdLine):
            print("このコマンドは引数付きセレクタがあります。")
            cmdLine = argument_convert(cmdLine)
        else:
            print("このコマンドはセレクタがありますが変換は不要です。")

    if typeConvert:
        convResult,typeConvert = type_convert(cmdLine,convType)
    else:
        convResult = cmdLine
    
    return convResult
######################################

#!変換の流れ
textRead = open(srcPath, "r", encoding="utf_8")
beforeText = textRead.readlines()
textRead.close()

cnt = len(beforeText)
print("変換テキストを読み込みました。")
for i in range(0,cnt):
    beforeText[i] = re.sub('\n','',beforeText[i])
    beforeText[i] = re.sub('\ufeff','',beforeText[i])
    if beforeText[i] == '':
        beforeText[i] = ' '

for i in range(0,cnt):
    lineText = re.sub('\n','',beforeText[i])
    print("変換処理を実行します <-- " + lineText)
    if lineText != '':
        beforeText[i] = str(command_text_convert(lineText) + "\n")
    else:
        beforeText[i] = " \n"
    #空白行があると処理が終了してしまう問題があるので修正する
    print("result = " + beforeText[i])

outText = open(dstPath, 'a', encoding='UTF-8')
outText.writelines(beforeText)
outText.close

print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
print("path : " + srcDir + "  filename : " + dstPath +
      "\nfullPath : " + srcDir + "/" + dstPath)
exit()
