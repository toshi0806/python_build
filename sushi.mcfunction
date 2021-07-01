#NEKOYAMA Converter 2021/06/30 00:38:37 converted
#統合版用にfunctionを作成し動作を確認する。
#コンバートスクリプトにかけても問題なく動作するかをチェックする。
#コンバート前をconvert_test.mcfunctionとし、コンバート後をconvert_after.mcfunctionとする。
#一文字目に「e」でexecuteコマンドを検知する。(コメント欄executeコマンドを変換しないようにする)
 
tp @s 0 4 0 0 0
fill ~3 ~3 ~3 ~-3 ~ ~-3 air
scoreboard objectives add test987j9uq34 dummy
scoreboard players set @a test987j9uq34 3
tag @a add test73482b3r2
xp add @a 5 levels 
#基本羅列変換1「execute as @a at @s run say 基本羅列変換1」に変換する。~ ~ ~であれば削除するが、値が入っている場合は別処理を行う。as 基本ｾﾚｸﾀ at @s
execute as @a at @s run say 基本羅列変換1
#基本羅列変換2「execute as @a at @s positioned ~ ~1 ~ run say 基本羅列変換2」に変換する。
execute as @a at @s run say 基本羅列変換2
#基礎羅列変換3「execute as @e[distance=..5,gamemode=creative,type=player] at @s positioned 0 7 0 run say 基本羅列変換3」に変換する。
execute as @e[distance=..5,gamemode=creative,type=player] at @s run say 基本羅列変換3
#基礎羅列変換4「execute as @a[distance=0..5] at @s run say 基本羅列変換4」
execute as @a[distance=0..5] at @s run say 基本羅列変換4
#基礎羅列変換5「execute as @a[x=0,y=4,z=0,dx=2,dy=10,dz=2] at @s run say 基本羅列変換5」
execute as @a[x=0,y=4,z=0,dx=2,dy=10,dz=2] at @s run say 基本羅列変換5
#基礎羅列変換6「execute as @a[x_rotation=-30..60,y_rotation=-87..87] at @s run say 基本羅列変換6」
execute as @a[y_rotation=-87..87,x_rotation=-30..60] at @s run say 基本羅列変換6
#基礎羅列変換7「execute as @a[limit=5,level=3..7000,scores={test987j9uq34=3..4},tag=test73482b3r2] at @s run say 基本羅列変換7」
execute as @a[level=3..7000,limit=5,scores={test987j9uq34=3..4},tag=test73482b3r2] at @s run say 基本羅列変換7
#基礎羅列変換8「execute as @a[name="Nekoyama 030330",tag=!sushi] at @s run say 基本羅列変換8」
execute as @a[name="Nekoyama 030330",tag=!sushi] at @s run say 基本羅列変換8
#基礎羅列変換9「execute as @a[gamemode=!adventure,scores={test987j9uq34=!7..23}] at @s run say 基本羅列変換9」
execute as @a[gamemode=!adventure,scores={test987j9uq34=!7..23}] at @s run say 基本羅列変換9
 
#追加分
tp @a[gamemode=!adventure,scores={test987j9uq34=!7..23}] 0 8 0
execute as @a[y_rotation=-180..180,level=3..7000,gamemode=!adventure,limit=5] ~ ~ ~ execute @p[level=0..99] ~ ~ ~ tell @a[distance=..10] at @s run  
scoreboard objectives remove test987j9uq34
tag @a remove test73482b3r2
execute as @e[tag=select,scores={bp_time2=..0},type=armor_stand] ~ ~ ~ clear @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50,gamemode=adventure] at @s run  
xp add @e[type=player] -20 points 
xp add @a[level=30000..32767] 32768 levels 
xp add @r -503 levels 
xp add @a[distance=..50,scores={test987j9uq34=3..4}] 8096 levels 
