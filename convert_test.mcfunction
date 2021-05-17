#統合版用にfunctionを作成し動作を確認する。
#コンバートスクリプトにかけても問題なく動作するかをチェックする。
#コンバート前をconvert_test.mcfunctionとし、コンバート後をconvert_after.mcfunctionとする。
#一文字目に「e」でexecuteコマンドを検知する。(コメント欄executeコマンドを変換しないようにする)

tp @s 0 4 0 0 0
fill ~3 ~3 ~3 ~-3 ~ ~-3 air
scoreboard objectives add test987j9uq34 dummy
scoreboard players set @a test987j9uq34 3
tag @a add test73482b3r2
xp 5l @a
#基本羅列変換1「execute as @a at @s run say 基本羅列変換1」に変換する。~ ~ ~であれば削除するが、値が入っている場合は別処理を行う。as 基本ｾﾚｸﾀ at @s
execute @a ~ ~ ~ say 基本羅列変換1
#基本羅列変換2「execute as @a at @s positioned ~ ~1 ~ run say 基本羅列変換2」に変換する。
execute @a ~ ~1 ~ say 基本羅列変換2
#基礎羅列変換3「execute as @e[distance=..5,gamemode=creative,type=player] at @s positioned 0 7 0 run say 基本羅列変換3」に変換する。
execute @e[r=5,m=c,type=player] 0 7 0 say 基本羅列変換3
#基礎羅列変換4「execute as @a[distance=0..5] at @s run say 基本羅列変換4」
execute @a[r=5,rm=0] ~ ~ ~ say 基本羅列変換4
#基礎羅列変換5「execute as @a[x=0,y=4,z=0,dx=2,dy=10,dz=2] at @s run say 基本羅列変換5」
execute @a[x=0,y=4,z=0,dx=2,dy=10,dz=2] ~ ~ ~ say 基本羅列変換5
#基礎羅列変換6「execute as @a[x_rotation=-30..60,y_rotation=-87..87] at @s run say 基本羅列変換6」
execute @a[rx=60,rxm=-30,ry=87,rym=-87] ~ ~ ~ say 基本羅列変換6
#基礎羅列変換7「execute as @a[limit=5,level=3..7000,scores={test987j9uq34=3..4},tag=test73482b3r2] at @s run say 基本羅列変換7」
execute @a[c=5,l=7000,lm=3,scores={test987j9uq34=3..4},tag=test73482b3r2] ~ ~ ~ say 基本羅列変換7
#基礎羅列変換8「execute as @a[name="Nekoyama 030330",tag=!sushi] at @s run say 基本羅列変換8」
execute @a[name="Nekoyama 030330",tag=!sushi] ~ ~ ~ say 基本羅列変換8
#基礎羅列変換9「execute as @a[gamemode=!adventure,scores={test987j9uq34=!7..23}] at @s run say 基本羅列変換9」
execute @a[m=!adventure,scores={test987j9uq34=!7..23}] ~ ~ ~ say 基本羅列変換9

scoreboard objectives remove test987j9uq34
tag @a remove test73482b3r2
