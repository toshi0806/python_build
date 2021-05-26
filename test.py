import sys
import os
import datetime
import re

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
    argListOld = argList = argListTemp = list()
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
    try:
        argListOld.append(re.search(r'scores=\{.*\,.*\}',getArg).group(0))
    except:
        print("[convArg]scores引数はありません。")
    else:
        print("[convArg]scores引数を取得しました。 --> " + argListOld[0])
        getArg = re.sub(argListOld[0],'DELETED',getArg)

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
        print(getArg)
        if ArgCnt <= 1:
            endArg = getArg.rfind('[')
            print(str(getArg) + " " + str(endArg))
            argListOld.append(getArg[endArg+1:])
            print("[convArg]複数の引数を抜き取りました。 --> " + str(argListOld))
            break
    argCnt = len(argListOld)

    #引数を変換するための一部特殊構成引数構築のためのフラグ
    distanceBuild = disMin = disMax = False
    levelBuild = levMin = levMax = False
    selTempLoop = len(argListOld)
    convArg = "DELETED"
    for i in range(0,selTempLoop):
        selTemp = getArg
        print(selTemp + " by " + str(argListOld) + "\nargList=" + str(argListTemp))
        if selTemp.startswith(("type=","name=","x=","y=","z=","dx=","dy=","dz=","scores=","tag=")):
            convArg = selTemp
        elif selTemp.startswith("r="):
            #r,rm,l,lmはあとから構築
            distanceBuild = True
            disMax = selTemp[2:]
        elif selTemp.startswith("rm="):
            distanceBuild = True
            disMin = selTemp[2:]
        elif selTemp.startswith("l="):
            levelBuild = True
            levMax = selTemp[2:]
        elif selTemp.startswith("lm="):
            levelBuild = True
            levMin = selTemp[2:]
        elif selTemp.startswith("m="):
            gmTemp = "gamemode="
            if (re.search('!',selTemp)):
                gmTemp += "!"
            if selTemp.endswith("a"):
                gmTemp += "adventure"
            elif selTemp.endswith("c"):
                gmTemp += "creative"
            elif selTemp.endswith("s"):
                gmTemp += "survival"
            selTemp = gmTemp
            print("gamemode=" + selTemp)
        elif selTemp.startswith("c="):
            argListTemp.append(str(re.sub('c=','limit=',selTemp)))
        try:
            argListTemp.append(convArg)
        except:
            print("Failed append " + selTemp)
        convArg = "DELETED"
        if len(argListOld) >= 20:
            print("argList error")
            exit()
        selTempLoop -= 1
        if selTempLoop == 0:
            print("[convArg]現在の引数の数 --> " + str(len(argListTemp)) + "\n" + str(argListOld))
            break

    if disMin is None:
        disMin = ""
    if disMax is None:
        disMax = ""
    if levMin is None:
        levMin = ""
    if levMax is None:
        levMax = ""

    #r,rm,l,lmの構築
    if distanceBuild:
        disArg = "distance" + disMin + ".." + disMax
        argListTemp.append(disArg)
    if levelBuild:
        levArg = "level" + levMin + ".." + levMax
        argListTemp.append(levArg)

    argCnt = len(argListTemp)
    print("[convArg]現在の引数の数 --> " + str(len(argListTemp)) + "\n" + str(argListTemp))
    
    if argList.count('DELETED') > 0:
        print(str(argList.count('DELETED')) + "個の要素をargListから削除")
        for i in range(0,argList.count('DELETED')):
            argList.remove('DELETED')
    argCnt -= 1
    print("[convArg]argListの数 --> " + str(len(argList)) + "\n" + str(argList))

    argCnt = len(argList)
    print("最終的な引数の数 <-- " + str(argCnt) + "\nArglist -->" + str(argList))
    #outLineArg = "@" + selEntity + "["
    outLineArg = selEntity + "["
    while argCnt > 2:
        outLineArg = outLineArg + argList[argCnt-1] + ","
        argCnt -= 1
    outLineArg = outLineArg + argList[argCnt-1]
    print("OUT:" + outLineArg)
    lineArg = lineArg.replace('SELECTOR_',getArg)
    print("argconv=" + lineArg)
    return lineArg
#####################################
def type_convert(cmdType,cmdConv):
    if cmdType is 1:


        result = cmdConv
    return result
######################################
def list_in_execute_and_other_command(cmdLineWrite,exePos):
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

    #この関数を実行したときは引数をすでに変換した状態にして
    #フラグを立てて引数変換を実行しないようにする
    loopCnt = len(cmdExeList)
    while loopCnt is not 0:
        cmdExeList[loopCnt-1] = argument_convert(cmdExeList[loopCnt-1])
        loopCnt -= 1
    return cmdLineWrite
######################################
def command_text_convert(cmdLine):
    multiCmd = False
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

    cntSelector = cmdLine.count('@')
    if cntSelector >= 2:
        print("複数のセレクタを検知しました。")
        #executeのeの部分の文字数目が入る。
        exePos = cmdLine.rfind('execute')
        print("ループ前executeの位置:" + str(exePos) + "\n" + cmdLine)
        #複数のセレクタがある→分解しcmdExeTestに入る。
        exeConvMulti = True
        if exePos is 0:
            cmdLine = list_in_execute_and_other_command(cmdLine,exePos)
            print(str(cmdExeList))
            exeConvMulti = False
        #↑セレクタ二個以上、execute一個の時executeの位置を検知し分離させる
        #コマンドを分離させるには
        while exePos > 0 and exeConvMulti:
            cmdLine = list_in_execute_and_other_command(cmdLine,exePos)
            cmdExeList.append(cmdLine[exePos:])
            cmdLine = cmdLine[:exePos]
            exePos = cmdLine.rfind('execute')
            print("ループ中executeの位置:" + str(exePos) + "\n" + cmdLine)
            if exePos is 0:
                cmdExeList.append(cmdLine)
                print("executeコマンドを二個以上検知しました。")
                multiCmd = True
                break
        #↑セレクタが二個以上、execute2個以上の時cmdExeListにコマンドを分割する。
        print("List --> " + str(cmdExeList))
        multiCmd = True


    if cmdLine.startswith("#") == False and re.search('\@', cmdLine) and multiCmd is None:
        if re.search(r'\@.\[', cmdLine):
            print("このコマンドは引数付きセレクタがあります。")
            cmdLine = argument_convert(cmdLine)
        else:
            print("このコマンドはセレクタがありますが変換は不要です。")
            
    if convType >= 1 and multiCmd is False:
        convResult = type_convert(convType,cmdLine)
    #↓multiCmdフラグが立っているとき、配列のセレクタそれぞれ変換して最終的に構成する
    elif multiCmd:
        cmdLineExe = list()
        exeListCnt = len(cmdExeList)
        while exeListCnt is not 0:
            cmdExeBuild = list()
            #cmdExe_cmdLine...分割したコマンドを代入する
            #cmdExeList...分割したコマンドを格納するリスト
            #exeListCnt...分割したコマンドの数
            #cmdExe_cntSelector...分割コマンドからセレクタを検知するだけ、2個以上検知したらバグとして強制終了する、その判別を行うのみ
            #cmdExeBuild...変換後の分割したコマンドを補完し、後から構築する
            cmdExe_cmdLine = cmdExeList.pop(0)
            exeListCnt = len(cmdExeList)
            cmdExe_cntSelector = cmdExe_cmdLine.count('@')
            print("[cmdExe]cmdLine=" + cmdExe_cmdLine)
            if re.search(r'\@.\[', cmdExe_cmdLine):
                print("[cmdExe]セレクタを変換。")
                buildConv = argument_convert(cmdExe_cmdLine)
                cmdExeBuild.append(buildConv)
                print("[cmdExe]セレクタ変換後 --> " + buildConv)
            else:
                print("[cmdExe]セレクタがありますが変換は不要です。")
                cmdExeBuild.append(cmdExe_cmdLine)

        print("[cmdExe]分割されたコマンドを構築します。 " + str(cmdExeBuild))
        exeListCnt = len(cmdExeBuild)
        exeListCntMax = exeListCnt
        convResult = ""
        while exeListCnt is not 0:
            print(str(exeListCntMax-exeListCnt) + "|||" + convResult)
            convResult = convResult + cmdExeBuild.pop(0)[exeListCntMax-exeListCnt]
            exeListCnt = len(cmdExeBuild)
        print(convResult)
    else:
        convResult = cmdLine
        #convTypeはこれからパターンが増える
        multiCmd = False
    return convResult
######################################

#!変換の流れ
textRead = open(srcPath, "r", encoding="utf_8")
beforeText = textRead.readlines()
textRead.close()

cnt = len(beforeText)
print("変換テキストを読み込みました。")
for i in range(0,cnt+1):
    lineText = beforeText[i]

    print("INPUT-" + lineText)
    if lineText:
        print("変換処理を実行します <-- " + lineText)
        outText.write(command_text_convert(lineText))
    else:
        print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
        print("path : " + srcDir + "  filename : " + dstPath +
              "\nfullPath : " + srcDir + "/" + dstPath)
        exit()
