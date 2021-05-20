import re

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
#print(outLineArg + str(argCnt))
while argCnt is not 2:
    outLineArg = outLineArg + argList[argCnt-1] + ","
    argCnt -= 1
outLineArg = outLineArg + argList[argCnt-1] + "]"
print("OUT:" + outLineArg)