import sys
import os
import datetime

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

    print("INPUT-" + lineText)

    #ここに変換するための関数

    if lineText:
        print("変換処理を実行します")
    else:
        print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
        print("path : " + srcDir + "  filename : " + dstPath +
              "\nfullPath : " + srcDir + "/" + dstPath)
        exit()
