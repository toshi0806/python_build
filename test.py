import sys
import os
from datetime import datetime
from pytz import timezone

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
        dstPath = dstPath.replace('.mcfunction.mcfunction', '.mcfunction')

# ファイルのディレクトリ
srcDir = os.path.split(srcPath)[0]
dstPath=srcDir + "\\" + dstPath
print("出力ファイルパス " + dstPath)
TestFind = os.path.exists(dstPath)
if TestFind is False:
    print("新規にファイルを作成します。\n" + dstPath)
else:
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

inText = open(dstPath, 'a', encoding='UTF-8')
# タイムスタンプ取得用
dateText = datetime.now(timezone('UTC')).astimezone(
    timezone('Asia/Tokyo')).strftime("%Y/%m/%d %H:%M:%S")

inText.write("#NEKOYAMA Converter " + str(dateText) + " converted\n")
inText.close

#!変換の流れ
#convContinueは「空文字列だったとき次の文字列を読み込み、それが文字列であったとき処理を続行する」判断を行う。
#これを実行することで空白の次の一行が未処理で続行されることを防ぐ=この場合再読み込みを行わない
beforeText = open(srcPath, "r", encoding="utf_8")
print("変換テキストを読み込みました。")
convContinue = False
lineText = list(beforeText)
while True:
    if convContinue is False:
        lineText = beforeText.readline()

    print("INPUT-" + lineText)
    if lineText:
        print("変換処理を実行します")
        convContinue = False
    else:
        lineText = beforeText.readline()
        if lineText is False:
            print("変換が終了しました。UTF-8Nで再読込を行って保存してください。")
            print("path:" + srcDir + "filename:" + dstPath + "\nfullPath:" + srcDir + "/" + dstPath)
            exit()
        else:
            print("空文字列を検知")
            convContinue = True
            #debug
            print(lineText)
            exit()
#readlineに難がありそう
