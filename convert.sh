#!/bin/bash
suffix='.mcfunction'
defaultdstPath='converted'
#スクリプト実行時に引数を設定する。引数の数によって処理を分岐 $#は引数の数
#先にsrcPath(fileName)を入力し、出力名dstPathを入れる
#destination...行き先、実行後出力後のファイルを意味する
if [ $# == 2 ]; then
	srcPath=$1
	dstPath=$2
elif [ $# == 1 ]; then
	srcPath=$1
	#引数がないならsrc,destPath入力を求めるがこの場合は24行目ifに引っ掛けてconverted.mcfunctionとする
	dstPath=''
else
	while true; do
		read -p "変換するファイルのパスを入力してください。(ファイルをシェルにドロップ)" srcPath
		if [ "$srcPath" != "" ]; then
			break
		fi
	done
	read -p "変換後ファイル名を入力してください。(.mcfunctionは不要、空白可)" dstPath
fi

if [ "$dstPath" != "" ]; then
	dstPath="${dstPath}${suffix}"
	# suffix が重複していた場合削除
	dstPath="${dstPath//${suffix}${suffix}/${suffix}}"
else
	dstPath='converted.mcfunction'
fi

srcDir="${srcPath%/*}"
#cd $srcDir
#touch "${dstPath}"
#ファイルパスから一部を取り出す特殊文字があるので、メモ
#https://qiita.com/ktr_type23/items/94747a4b27e8a630ce48

#関数エリア(呼び出しより前に宣言しておく必要がある)#########################
function pull_selector() {
	Selector=""
	#セレクター開始点(9文字目)
	selectorCnt=9
	emptyCheck="@"
	while (true); do
		if [ "$emptyCheck" = " " ]; then
			outCheck=$(echo $maintext | cut -c $((selectorCnt - 1)))
			atCheck=$(echo $maintext | cut -c $((selectorCnt - 2)))
			if [ "$outCheck" = "]" ]; then
				echo outcheck break.
				break
			elif [ "$atCheck" = "@" ]; then
				echo atcheck break.
				break
			fi
		fi
		Selector="$Selector$emptyCheck"
		selectorCnt=$((selectorCnt + 1))
		emptyCheck=$(echo $maintext | cut -c $selectorCnt)
	done
	echo [info]セレクター $Selector
	maintext=$(echo $maintext | cut -c $selectorCnt-)
	#echo セレクターを抜き取りました--$maintext
}
########################################################################
function pull_position() {
	posCnt=0 #PosCntは文字数カウント
	posCheck=""
	declare -a Pos3=("X" "Y" "Z")
	#echo 配列初期 ${Pos3[0]} / ${Pos3[1]} / ${Pos3[2]}
	while (true); do
		if [ "$posCheck" = " " ]; then
			#空白検知で座標をXから順にPos3[0]から入れる。
			posCheck=$(echo $maintext | cut -c 1-$posCnt)
			Pos3[$POS_arrayC]="$posCheck"
			POS_arrayC=$((POS_arrayC + 1)) #POS_arrayCは空白検知のたび+1し、3回の時点でbreak
			#echo アレイカウント$POS_arrayC
			if [ "$POS_arrayC" = "3" ]; then
				POS_arrayC=0
				break
			fi
			#echo 配列${Pos3[@]}
			maintext=$(echo $maintext | cut -c $((posCnt + 1))-)
			posCnt=0
		fi
		posCnt=$((posCnt + 1))
		posCheck=$(echo $maintext | cut -c $posCnt)
		#echo $posCnt $posCheck 0/ ${Pos3[0]} 1/ ${Pos3[1]} 2/ ${Pos3[2]}
	done
	maintext=$(echo $maintext | cut -c $posCnt-)
	echo [info]座標 ${Pos3[@]}
	Pos3s[0]=${Pos3[0]}
	Pos3s[1]=${Pos3[1]}
	Pos3s[2]=${Pos3[2]}
	#echo 座標を抜き取りました--$maintext
}
########################################################################
function pull_detect() {
	detect=1
	detect_posCnt=8 #PosCntは文字数カウント
	detect_posCheck=""
	#echo 配列初期 ${detect_Pos3[0]} / ${detect_Pos3[1]} / ${detect_Pos3[2]}
	while (true); do
		if [ "$detect_posCheck" = " " ]; then
			#空白検知で座標をXから順にdetect_Pos3[0]から入れる。
			detect_posCheck=$(echo $maintext | cut -c 1-$detect_posCnt)
			detect_Pos3[$detect_POS_arrayC]="$detect_posCheck"
			detect_POS_arrayC=$((detect_POS_arrayC + 1)) #detect_POS_arrayCは空白検知のたび+1し、3回の時点でbreak
			#echo アレイカウント$detect_POS_arrayC
			if [ "$detect_POS_arrayC" = "3" ]; then
				detect_POS_arrayC=0
				break
			fi
			#echo 配列${Pdetect_os3[@]}
			maintext=$(echo $maintext | cut -c $((detect_posCnt + 1))-)
			detect_posCnt=0
		fi
		detect_posCnt=$((detect_posCnt + 1))
		detect_posCheck=$(echo $maintext | cut -c $detect_posCnt)
		#echo $detect_posCnt $detect_posCheck 0/ ${detect_Pos3[0]} 1/ ${detect_Pos3[1]} 2/ ${detect_Pos3[2]}
	done
	maintext=$(echo $maintext | cut -c $detect_posCnt-)
	detect_Pos3[0]=$(echo ${detect_Pos3[0]} | cut -c 7-)
	echo [info]detect座標 ${detect_Pos3[@]}
	#echo detect座標を抜き取りました--$maintext
	#detectのブロックIDを抜き取る。ダメージ値は互換性がないため無視。
	while (true); do
		if [ "$emptyCheckdt" = " " ]; then
			detectBlock=$(echo $maintext | cut -c -$((detIDCnt - 1)))
			echo [info]detectブロックは$detectBlockです。
			maintext=$(echo $maintext | cut -c $((detIDCnt + 3))-)
			#echo detectブロックを抜き取りました--$maintext
			break
		fi
		detIDCnt=$((detIDCnt + 1))
		emptyCheckdt=$(echo $maintext | cut -c $detIDCnt)
	done
}
########################################################################
function argument_convert() {
	argCheck=$(echo $Selector | cut -c 3)
	#echo argCheck : $argCheck
	case "$argCheck" in
	" ") echo [notification]セレクターに引数はありません。 ;;
	"[")
		echo [notification]セレクターの引数を検証します。rx,rxm,ry,rymには対応していません。disctance,levelについても手動で設定してください。
		Seltemp=$Selector
		while true; do
			argCheck=$(echo $Seltemp | cut -c 4-5)
			Seltemp=$(echo $Seltemp | cut -c 2-)
			if [ "$Seltemp" = "]" ]; then
				break
			fi
			#echo argCheck : $argCheck
			case "$argCheck" in
			"r=") Selector=$(echo $Selector | sed -e s/r=/distance=../) ;;
			"rm") Selector=$(echo $Selector | sed -e s/rm=/最小範囲/) ;;
			"m=") Selector=$(echo $Selector | sed -e s/m=/gamemode=/) ;;
			"l=") Selector=$(echo $Selector | sed -e s/l=/level=../) ;;
			"lm") Selector=$(echo $Selector | sed -e s/lm=/最低レベル/) ;;
			#"rx" ) argCheck=`echo $Selector | cut -c 4-6`;;
			esac
		done
		echo [info]セレクターを変換しました。 $Selector
		;;
	esac
}
########################################################################
function convert() {
	echo convert関数in
	first=`echo $maintext | cut -c 1`
	echo この文字列の最初の文字は "${first:-"EMPTY"}"
	case "${first:-"EMPTY"}" in
	"#")
		echo -e "\e[34m[notification]$NUM行はコメントのため、変換せず出力します。 \e[m"
		maintextOUT="${maintext}"
		NOT_CONVERT=1
		;;
	"e")
		exeTest=$(echo $maintext | cut -c 1-7)
		NOT_CONVERT=0
		case "$exeTest" in
		"execute")
			echo [notification]executeコマンドを検出。
			pull_selector
			declare -a Pos3s=()
			pull_position
			argument_convert
			detTest=$(echo $maintext | cut -c 1-6)

			if [ "$detTest" == "detect" ] ;then
				echo [notification]detect処理を検出。
				declare -a detect_Pos3=()
				pull_detect
			else
				detect=0
				#break
			fi
			;;
		"*")
			maintextOUT="${maintext}"
			NOT_CONVERT=1
			#break
			;;
		esac
		;;
	"EMPTY")
		maintextOUT=" "
		NOT_CONVERT=1
		echo -e "\e[34m[notification]この行は空白です。 \e[m"
		;;
    * ) 
		maintextOUT="${maintext}"
		NOT_CONVERT=1
		echo -e "\e[34m[notification]非変換対応コマンドです。 \e[m"
		;;
	esac
}
########################################################################

#変換後ファイルの出力に使用
echo '#NEKOYAMA Converter '$(date -R)' converted' >|$srcDir/$dstPath
NUM=0
linecount=$(cat "${srcPath}" | wc -l)

while [ $NUM -le $linecount ]; do
	NUM=$((NUM + 1))
	echo -e "\e[36m[test]$NUM行目の変換を試みます。 \e[m"
	maintext=$(cat "${srcPath}" | awk NR==$NUM)

	#ここから変換
	convert

	#変換後に出力
	if [ "$NOT_CONVERT" = 0 ]; then
		maintextOUT="execute as $Selector at @s"
		echo IN-${maintext}
		if [ "$detect" = 1 ]; then
			iff='if'
			maintextOUT="${maintextOUT} positioned ${Pos3s[*]} $iff block $detectBlock ${detect_Pos3[*]} run $maintext"
		else
			maintextOUT="${maintextOUT} positioned ${Pos3s[*]} run $maintext"
		fi
		echo ${maintextOUT} >>${srcDir}/${dstPath}
		echo -e "\e[32m[success]$NUM行目を出力しました。 \e[m"
		echo -e "\e[32mOUT$NUM-${maintextOUT}\e[m"
	else
		echo ${maintextOUT} >>${srcDir}/${dstPath}
		echo OUT$NUM-${maintextOUT}
		echo -e "\e[32m[success]$NUM行目をコピーしました。 \e[m"
	fi
done
echo 変換が終了しました。UTF-8Nで再読込を行って保存してください。
echo path:$srcDir filename:$dstPath
echo fullPath:${srcDir}/${dstPath}
##################################################################
exit

#139引数変換関数を書き直す
#https://twitter.com/nk_cmd/status/1393611399281131521?s=20