#name:TNTrun
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#スコアボードsnを加算し、流れを進めます
execute as @e[tag=select,scores={sn=0..150},type=armor_stand] at @s run scoreboard players add @e[tag=select,type=armor_stand,limit=1] sn 1
scoreboard players add @e[tag=select] sn 0

#通知
execute as @e[tag=select,scores={sn=5},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"§e1.ゲームシステムを起動します"}]}
execute as @e[tag=select,scores={sn=5},type=armor_stand] at @s run scoreboard objectives add eg dummy "§4TNT run"
execute as @e[tag=select,scores={sn=5..},type=armor_stand] at @s run scoreboard objectives setdisplay sidebar ttr

#ステージを構築
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"§e2.ステージを構築します"}]}

#ステージを構築   ※外部
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 8 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 12 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 16 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 20 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 24 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s run summon armor_stand -5 28 -98
execute as @e[tag=select,scores={sn=7},type=armor_stand] positioned -5 7 -98 as @e[type=armor_stand,dy=30,limit=6] at @s run tag @s add stageedit
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run tp @s ~ ~ ~ ~2 ~
#上記のコマンドではtp @s ~ ~ ~ ~2 が元の文で、統合版ならこれで動くがJavaでは tp @s 座標 x視点 y視点　もしくは tp @s 座標 でなければ実行できないためチルダを追加
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run fill ^ ^ ^ ^ ^ ^15 tnt
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s positioned ~ ~1 ~ run fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run tp @s ~ ~ ~ ~2 ~
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run fill ^ ^ ^ ^ ^ ^15 tnt
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s positioned ~ ~1 ~ run fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run tp @s ~ ~ ~ ~2 ~
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run fill ^ ^ ^ ^ ^ ^15 tnt
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s positioned ~ ~1 ~ run fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run tp @s ~ ~ ~ ~2 ~
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run fill ^ ^ ^ ^ ^ ^15 tnt
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s positioned ~ ~1 ~ run fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run tp @s ~ ~ ~ ~2 ~
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run fill ^ ^ ^ ^ ^ ^15 tnt
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s positioned ~ ~1 ~ run fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute as @e[tag=select,scores={sn=7..40},type=armor_stand] positioned -5 7 -98 as @e[tag=stageedit] at @s run kill @e[type=item]
execute as @e[tag=select,scores={sn=40},type=armor_stand] at @s run kill @e[tag=stageedit]
#不要
#execute as @e[tag=select,scores={sn=7},type=armor_stand] at @s as @e[tag=clear] at @s run fill ~ 4 ~ ~50 2 ~50 air 0 replace bedrock

#シュルカーボックスの配置
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s run summon armor_stand -5 65 -98
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s as @e[x=-5,y=65,z=-98,distance=..2,type=armor_stand] at @s run tag @s add www.com
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s run spreadplayers -5 -98 3 20 false @e[tag=www.com]
#上記コマンドspreadplayersコマンドでは、セレクタの前にtrue/falseの入力がJava版では必須になっているデフォルト値はfalse。
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s run function azi/randomchest.azistage_randomize
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s as @e[tag=www.com,limit=1] at @s run clone -60 249 -114 -60 249 -114 ~ ~-1 ~ 
execute as @e[tag=select,scores={sn=1010..1020},type=armor_stand] at @s run kill @e[tag=www.com]
#####################################################################
#特殊効果設定
execute as @e[tag=select,scores={sn=14},type=armor_stand] at @s run scoreboard players set @s sp 0

execute as @e[tag=select,scores={sn=14,sp=0},type=armor_stand] at @s run scoreboard players random @s sp 1 80
#scoreboardコマンドのramdomは実装されていない
#https://nekoyama030330.seesaa.net/article/475665051.html 現状ではこの方法しかない。

execute as @e[tag=select,scores={sn=14,sp=1..50},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e未設定§rです。"}]}

execute as @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] at @s run tag @e[tag=clear] add web_bp
execute as @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e1/3 §rです。"}]}
execute as @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] at @s run tag @e[tag=clear] add lava_bp
execute as @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e2/3 §rです。"}]}
execute as @e[tag=select,scores={sn=14,sp=71..80},type=armor_stand] at @s run tag @e[tag=clear] add bomb_bp
execute as @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e3/3 §rです。"}]}

#特殊効果別本処理

#####################################################################
execute as @e[tag=select,scores={sn=15..},type=armor_stand] at @s run function sys.sarchplayer.azi
execute as @e[tag=select,scores={sn=15..},type=armor_stand] at @s run scoreboard players operation @s players = sarchplayer sarchplayer

execute as @e[tag=select,scores={sn=16,players=0},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"§cエラーが発生しました。player count condition error"}]}
execute as @e[tag=select,scores={sn=16,players=0},type=armor_stand] at @s run function azi/new.gameend.sytem

#####################################################################

#開始までの通知
execute as @e[tag=select,scores={sn=20},type=armor_stand] at @s run tellraw @a {"rawtext":[{"text":"開始までのカウントダウンを開始します"}]}
execute as @e[tag=select,scores={sn=40},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§a5 seconds..."}]}
execute as @e[tag=select,scores={sn=40},type=armor_stand] at @s run playsound random.orb @a
#上記のコマンドはIDの互換性がほぼ完全にないので放置
execute as @e[tag=select,scores={sn=60},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§a4 seconds..."}]}
execute as @e[tag=select,scores={sn=60},type=armor_stand] at @s run playsound random.orb @a
execute as @e[tag=select,scores={sn=80},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§a3 seconds..."}]}
execute as @e[tag=select,scores={sn=80},type=armor_stand] at @s run playsound random.orb @a
execute as @e[tag=select,scores={sn=100},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§a2 seconds..."}]}
execute as @e[tag=select,scores={sn=100},type=armor_stand] at @s run playsound random.orb @a
execute as @e[tag=select,scores={sn=120},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§c1 §asecond"}]}
execute as @e[tag=select,scores={sn=120},type=armor_stand] at @s run playsound random.orb @a
execute as @e[tag=select,scores={sn=140},type=armor_stand] at @s run title @a title {"rawtext": [{"text":"§eStart!!!"}]}
execute as @e[tag=select,scores={sn=140},type=armor_stand] at @s run playsound random.levelup @a

#プレイヤーをテレポート
execute as @e[tag=select,scores={sn=140},type=armor_stand] at @s as @a[x=-5,y=60,z=-98,distance=..2] at @s run spreadplayers ~ ~ 3 7 false @s

#ゲーム本回路を起動
execute as @e[tag=select,scores={sn=140..150},type=armor_stand] at @s run scoreboard players set @s sn 1000
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#


#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#####メイン本回路 流れ制御
execute as @e[tag=select,scores={sn=1000..},type=armor_stand] at @s run scoreboard players add @s sn 1
#execute as @e[tag=select,scores={sn=1000..},type=armor_stand] at @s as @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=50,gamemode=adventure]

execute as @e[tag=select,scores={sn=1000..},type=armor_stand] at @s run xp add @a[x=-30,y=6,z=-125,dx=50,dy=1000,dz=50] 10 points
execute as @e[tag=select,scores={sn=0..},type=armor_stand] at @s run scoreboard players add @e[type=tnt] sn 1
execute as @e[tag=select,scores={sn=0..},type=armor_stand] at @s run kill @e[type=tnt,scores={sn=5..}]
execute as @e[tag=select,scores={sn=1200..,players=0},type=armor_stand] at @s run function azi/new.gameend.sytem

#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#

execute as @e[tag=select,scores={sn=0..},type=armor_stand] at @s run scoreboard players operation @s sn2 = @s sn
execute as @e[tag=select,scores={sn=0..},type=armor_stand] at @s run scoreboard players operation @s sn2 -= s1000 s1000
execute as @e[tag=select,scores={sn=0..},type=armor_stand] at @s run scoreboard players operation @s sn2 %= s20 s20
scoreboard players operation "§e残り時間" ttr = @e[tag=select,type=armor_stand] sn2
scoreboard players operation "§c残りプレイヤー" ttr = @e[tag=select,type=armor_stand] players
scoreboard players set "---------------------" ttr -30
scoreboard players set "ごく一般的なTNTrunです。" ttr -31
scoreboard players set "感圧版を踏むとTNTが着火し床が消えます" ttr -32
scoreboard players set "岩盤の上に落ちないように生き延びてください" ttr -33
