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
    if argCnt >= 2:
        print("変換処理でエラーが発生しました。")
        exit()
    #lineArg = "execute @e[type=armor_stand]"
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
        selTemp = argListOld[argCnt-1]
        if selTemp.startswith(("type=","name=","x=","y=","z=","dx=","dy=","dz=","scores=")):
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
            modeTemp = selTemp
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
            print("Failed append " + selTemp)
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

    #r,rm,l,lmの構築
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
    while argCnt > 2:
        outLineArg = outLineArg + argList[argCnt-1] + ","
        argCnt -= 1
    outLineArg = outLineArg + argList[argCnt-1]
    print("OUT:" + outLineArg)
    lineArg = lineArg.replace('SELECTOR_',getArg)
    return lineArg
#####################################
def type_convert(cmdType,cmdConv):
    if cmdType is 1:


        result = cmdConv
    return result
######################################
def command_text_convert(cmdLine):
    multiCmd = False
    cmdExeList = list()
    cmdExeList.clear
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

    cntSelector = cmdLine.count('@')
    if cntSelector >= 2:
        print("複数のセレクタを検知しました。")
        #executeのeの部分の文字数目が入る。
        exePos = cmdLine.rfind('execute')
        #複数のセレクタがある→分解しcmdExeTestに入る。
        while exePos is not 0:
            cmdExeList.append(cmdLine[exePos:])
            cmdLine = cmdLine[:exePos]
            exePos = cmdLine.rfind('execute')
            if exePos is 0:
                cmdExeList.append(cmdLine)
                multiCmd = True
        #↑セレクタが二個以上、execute2個以上の時cmdExeListにコマンドを分割する。
        if exePos is 0:
            ALL_COMMAND = list()
            ALL_COMMAND = ['clear ','clone ','difficulty ','effect ','enchant ','event ','xp ','fill ','fog ','function ','gamemode ','gamerule ','gametest ','getchunkdata ','getlocalplayername ','getspawnpoint ','give ','globalpause ','immutableworld ','kick ','kill ','list ','listd ','locate ','locatebiome ','me ','mobevent ','msg ','w ','music ','particle ','permission ','playanimation ','playsound ','querytarget ','reload ','replaceitem ','ride ','save ','say ','schedule ','scoreboard ','setblock ','setmaxplayers ','setworldspawn ','spawnpoint ','spreadplayers ','stop ','stopsound ','structure ','summon ','tag ','tp ','teleport ','tellraw ','testfor ','testforblock ','testforblocks ','tickingarea ','time ','title ','titleraw ','toggledownfall ','wb ','weather ','whitelist ','worldbuilder ','wsserver']
            ALL_COMMAND_COUNT = len(ALL_COMMAND)
            while ALL_COMMAND_COUNT is not 0:
                exePos = cmdLine.rfind(ALL_COMMAND[ALL_COMMAND_COUNT-1])
                ALL_COMMAND_COUNT -= 1
                if exePos is not -1:
                    print(ALL_COMMAND[ALL_COMMAND_COUNT])
                    break
            cmdExeList.append(cmdLine[:exePos-1])
            cmdLine = cmdLine[exePos:]
            cmdExeList.append(cmdLine)
        #↑セレクタ二個以上、execute一個の時空白三個を検知しコマンドを分離させる
        print(str(cmdExeList))
        multiCmd = True


    if cmdLine.startswith("#") == False and re.search('\@', cmdLine) and multiCmd is None:
        if re.search(r'\@.\[', cmdLine):
            print("このコマンドは引数付きセレクタがあります。")
            cmdLine = argument_convert(cmdLine,cntSelector)
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
            if re.search(r'\@.\[', cmdExe_cmdLine):
                print("[cmdExe]セレクタを変換。")
                cmdExeBuild.append(argument_convert(cmdExe_cmdLine,cmdExe_cntSelector))
            else:
                print("[cmdExe]セレクタがありますが変換は不要です。")
                cmdExeBuild.append(cmdExe_cmdLine)
        print("[cmdExe]分割されたコマンドを構築します。")
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
