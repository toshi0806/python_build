#name:TNTrun
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#スコアボードsnを加算し、流れを進めます
execute @e[tag=select,scores={sn=0..150},type=armor_stand] ~ ~ ~ scoreboard players add @e[tag=select,type=armor_stand,c=1] sn 1
scoreboard players add @e[tag=select] sn 0

#通知
execute @e[tag=select,scores={sn=5},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§e1.ゲームシステムを起動します"}]}
execute @e[tag=select,scores={sn=5},type=armor_stand] ~ ~ ~ scoreboard objectives add eg dummy "§4TNT run"
execute @e[tag=select,scores={sn=5..},type=armor_stand] ~ ~ ~ scoreboard objectives setdisplay sidebar ttr

#ステージを構築
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§e2.ステージを構築します"}]}

#ステージを構築   ※外部
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 8 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 12 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 16 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 20 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 24 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ summon armor_stand -5 28 -98
execute @e[tag=select,scores={sn=7},type=armor_stand] -5 7 -98 execute @e[type=armor_stand,dy=30,c=6] ~ ~ ~ tag @s add stageedit
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ tp @s ~ ~ ~ ~2
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ fill ^ ^ ^ ^ ^ ^15 tnt
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~1 ~ fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ tp @s ~ ~ ~ ~2
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ fill ^ ^ ^ ^ ^ ^15 tnt
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~1 ~ fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ tp @s ~ ~ ~ ~2
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ fill ^ ^ ^ ^ ^ ^15 tnt
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~1 ~ fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ tp @s ~ ~ ~ ~2
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ fill ^ ^ ^ ^ ^ ^15 tnt
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~1 ~ fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ tp @s ~ ~ ~ ~2
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ fill ^ ^ ^ ^ ^ ^15 tnt
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~1 ~ fill ^ ^ ^ ^ ^ ^16 stone_pressure_plate
execute @e[tag=select,scores={sn=7..40},type=armor_stand] -5 7 -98 execute @e[tag=stageedit] ~ ~ ~ kill @e[type=item]
execute @e[tag=select,scores={sn=40},type=armor_stand] ~ ~ ~ kill @e[tag=stageedit]
#不要
#execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ execute @e[tag=clear] ~ ~ ~ fill ~ 4 ~ ~50 2 ~50 air 0 replace bedrock

#シュルカーボックスの配置
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ summon armor_stand -5 65 -98
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ execute @e[x=-5,y=65,z=-98,r=2,type=armor_stand] ~ ~ ~ tag @s add www.com
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ spreadplayers -5 -98 3 20 @e[tag=www.com]
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ function azi/randomchest.azistage_randomize
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ execute @e[tag=www.com,c=1] ~ ~ ~ clone -60 249 -114 -60 249 -114 ~ ~-1 ~ 
execute @e[tag=select,scores={sn=1010..1020},type=armor_stand] ~ ~ ~ kill @e[tag=www.com]
#####################################################################
#特殊効果設定
execute @e[tag=select,scores={sn=14},type=armor_stand] ~ ~ ~ scoreboard players set @s sp 0

execute @e[tag=select,scores={sn=14,sp=0},type=armor_stand] ~ ~ ~ scoreboard players random @s sp 1 80

execute @e[tag=select,scores={sn=14,sp=1..50},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e未設定§rです。"}]}

execute @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add web_bp
execute @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e1/3 §rです。"}]}
execute @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add lava_bp
execute @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e2/3 §rです。"}]}
execute @e[tag=select,scores={sn=14,sp=71..80},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add bomb_bp
execute @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e3/3 §rです。"}]}

#特殊効果別本処理

#####################################################################
execute @e[tag=select,scores={sn=15..},type=armor_stand] ~ ~ ~ function sys.sarchplayer.azi
execute @e[tag=select,scores={sn=15..},type=armor_stand] ~ ~ ~ scoreboard players operation @s players = sarchplayer sarchplayer

execute @e[tag=select,scores={sn=16,players=0},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§cエラーが発生しました。player count condition error"}]}
execute @e[tag=select,scores={sn=16,players=0},type=armor_stand] ~ ~ ~ function azi/new.gameend.sytem

#####################################################################

#開始までの通知
execute @e[tag=select,scores={sn=20},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"開始までのカウントダウンを開始します"}]}
execute @e[tag=select,scores={sn=40},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a5 seconds..."}]}
execute @e[tag=select,scores={sn=40},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=60},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a4 seconds..."}]}
execute @e[tag=select,scores={sn=60},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=80},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a3 seconds..."}]}
execute @e[tag=select,scores={sn=80},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=100},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a2 seconds..."}]}
execute @e[tag=select,scores={sn=100},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=120},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§c1 §asecond"}]}
execute @e[tag=select,scores={sn=120},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§eStart!!!"}]}
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ playsound random.levelup @a

#プレイヤーをテレポート
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ execute @a[x=-5,y=60,z=-98,r=2] ~ ~ ~ spreadplayers ~ ~ 3 7 @s

#ゲーム本回路を起動
execute @e[tag=select,scores={sn=140..150},type=armor_stand] ~ ~ ~ scoreboard players set @s sn 1000
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#


#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#####メイン本回路 流れ制御
execute @e[tag=select,scores={sn=1000..},type=armor_stand] ~ ~ ~ scoreboard players add @s sn 1
execute @e[tag=select,scores={sn=1000..},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=50,m=a]

execute @e[tag=select,scores={sn=1000..},type=armor_stand] ~ ~ ~ xp 10 @a[x=-30,y=6,z=-125,dx=50,dy=1000,dz=50]
execute @e[tag=select,scores={sn=0..},type=armor_stand] ~ ~ ~ scoreboard players add @e[type=tnt] sn 1
execute @e[tag=select,scores={sn=0..},type=armor_stand] ~ ~ ~ kill @e[type=tnt,scores={sn=5..}]
execute @e[tag=select,scores={sn=1200..,players=0},type=armor_stand] ~ ~ ~ function azi/new.gameend.sytem

#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#

execute @e[tag=select,scores={sn=0..},type=armor_stand] ~ ~ ~ scoreboard players operation @s sn2 = @s sn
execute @e[tag=select,scores={sn=0..},type=armor_stand] ~ ~ ~ scoreboard players operation @s sn2 -= s1000 s1000
execute @e[tag=select,scores={sn=0..},type=armor_stand] ~ ~ ~ scoreboard players operation @s sn2 %= s20 s20
scoreboard players operation "§e残り時間" ttr = @e[tag=select,type=armor_stand] sn2
scoreboard players operation "§c残りプレイヤー" ttr = @e[tag=select,type=armor_stand] players
scoreboard players set "---------------------" ttr -30
scoreboard players set "ごく一般的なTNTrunです。" ttr -31
scoreboard players set "感圧版を踏むとTNTが着火し床が消えます" ttr -32
scoreboard players set "岩盤の上に落ちないように生き延びてください" ttr -33
