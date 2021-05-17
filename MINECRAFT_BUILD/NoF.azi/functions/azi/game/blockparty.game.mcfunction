w#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#スコアボードsnを加算し、流れを進めます
execute @e[tag=select,scores={sn=0..300},type=armor_stand] ~ ~ ~ scoreboard players add @e[tag=select,type=armor_stand,c=1] sn 1
scoreboard players add @e[tag=select] sn 0

#通知
execute @e[tag=select,scores={sn=5},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§e1.ゲームシステムを起動します"}]}
execute @e[tag=select,scores={sn=5},type=armor_stand] ~ ~ ~ scoreboard objectives add blockparty dummy "§bBlock Party"
execute @e[tag=select,scores={sn=5},type=armor_stand] ~ ~ ~ scoreboard objectives setdisplay sidebar blockparty

#ステージをランダムで選択します パターン1/2/3
execute @e[tag=select,scores={sn=7},type=armor_stand] ~ ~ ~ scoreboard players random @s random 1 9

#ステージ構築アーマースタンドを各パターンごとの場所へテレポートさせます
execute @e[tag=select,scores={sn=10,random=1..2},type=armor_stand] ~ ~ ~ execute @e[tag=clone,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 35 ~
execute @e[tag=select,scores={sn=10,random=3..4},type=armor_stand] ~ ~ ~ execute @e[tag=clone,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 36 ~
execute @e[tag=select,scores={sn=10,random=5..6},type=armor_stand] ~ ~ ~ execute @e[tag=clone,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 37 ~
execute @e[tag=select,scores={sn=10,random=7},type=armor_stand] ~ ~ ~ execute @e[tag=clone2,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 64 ~
execute @e[tag=select,scores={sn=10,random=8},type=armor_stand] ~ ~ ~ execute @e[tag=clone2,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 65 ~
execute @e[tag=select,scores={sn=10,random=9},type=armor_stand] ~ ~ ~ execute @e[tag=clone2,c=1,type=armor_stand] ~ ~ ~ tp @s ~ 66 ~
execute @e[tag=select,scores={sn=10,random=1..6},type=armor_stand] ~ ~ ~ tag @s add bpcl1
execute @e[tag=select,scores={sn=10,random=7..9},type=armor_stand] ~ ~ ~ tag @s add bpcl2

#ステージを構築
execute @e[tag=select,scores={sn=12},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§e2.ステージを構築します"}]}

execute @e[tag=select,scores={sn=12},type=armor_stand] ~ ~ ~ execute @s[tag=bpcl1] ~ ~ ~ execute @e[tag=clone,c=1,type=armor_stand] ~ ~ ~ clone ~50 ~ ~50 ~ ~ ~ -30 14 -125
execute @e[tag=select,scores={sn=12},type=armor_stand] ~ ~ ~ execute @s[tag=bpcl2] ~ ~ ~ execute @e[tag=clone2,c=1,type=armor_stand] ~ ~ ~ clone ~50 ~ ~50 ~ ~ ~ -30 14 -125

#####################################################################
#特殊効果設定
execute @e[tag=select,scores={sn=14},type=armor_stand] ~ ~ ~ scoreboard players set @s sp 0

execute @e[tag=select,scores={sn=14,sp=0},type=armor_stand] ~ ~ ~ scoreboard players random @s sp 1 100
#デバッグ用
#execute @e[tag=select,scores={sn=14},type=armor_stand] ~ ~ ~ scoreboard players set @s sp 81

execute @e[tag=select,scores={sn=14,sp=1..50},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e未設定§rです。"}]}
execute @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add tnt_bp
execute @e[tag=select,scores={sn=14,sp=51..60},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e1/5 TNT設置§rです。"}]}
execute @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add lava_bp
execute @e[tag=select,scores={sn=14,sp=61..70},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e2/5 頭上溶岩設置§rです。"}]}
execute @e[tag=select,scores={sn=14,sp=71..80},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add bomb_bp
execute @e[tag=select,scores={sn=14,sp=71..80},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e3/5 フェーズ毎爆弾投下§rです。"}]}
execute @e[tag=select,scores={sn=14,sp=81..90},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add stone_bp
execute @e[tag=select,scores={sn=14,sp=81..90},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e4/5 柱設置§rです。"}]}
execute @e[tag=select,scores={sn=14,sp=91..100},type=armor_stand] ~ ~ ~ tag @e[tag=clear] add random_bp
execute @e[tag=select,scores={sn=14,sp=91..100},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"今回の特殊モードは§e5/5 ランダム底抜け§rです。"}]}

#特殊効果別本処理  @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=50,m=a] 
#tnt_bp
execute @e[tag=tnt_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=44,dy=1000,dz=50,m=a] ~ ~ ~ setblock ~5 ~1 ~ tnt
execute @e[tag=tnt_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-24,y=4,z=-125,dx=44,dy=1000,dz=50,m=a] ~ ~ ~ setblock ~-5 ~1 ~ tnt
execute @e[tag=tnt_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=44,m=a] ~ ~ ~ setblock ~ ~1 ~5 tnt
execute @e[tag=tnt_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-119,dx=50,dy=1000,dz=44,m=a] ~ ~ ~ setblock ~ ~1 ~-5 tnt
execute @a[x=-30,y=4,z=-119,dx=50,dy=1000,dz=44,m=a] ~ ~ ~ detect ~ ~-1 ~ tnt summon creeper ~ ~5 ~
execute @a[x=-30,y=4,z=-119,dx=50,dy=1000,dz=44,m=a] ~ ~ ~ detect ~ ~-1 ~ tnt tp @s ~ ~-1 ~

#lava_bp
execute @e[tag=lava_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=50,m=a] ~ ~ ~ setblock ~ ~5 ~ flowing_lava
execute @e[tag=lava_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=48,dy=1000,dz=50,m=a] ~ ~ ~ setblock ~1 ~5 ~ flowing_lava
execute @e[tag=lava_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-28,y=4,z=-125,dx=48,dy=1000,dz=50,m=a] ~ ~ ~ setblock ~-1 ~5 ~ flowing_lava
execute @e[tag=lava_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=48,m=a] ~ ~ ~ setblock ~ ~5 ~1 flowing_lava
execute @e[tag=lava_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-123,dx=50,dy=1000,dz=48,m=a] ~ ~ ~ setblock ~ ~5 ~-1 flowing_lava
 
#bomb_bp-フェーズ開始時
execute @e[tag=bomb_bp] ~ ~ ~ execute @e[scores={bp_time2=-20}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=50,m=a] ~ ~ ~ summon ~ ~15 ~ tnt
execute @e[tag=bomb_bp] ~ ~ ~ execute @e[scores={bp_time2=-15}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=47,dy=1000,dz=50,m=a] ~ ~ ~ summon ~2 ~15 ~ tnt
execute @e[tag=bomb_bp] ~ ~ ~ execute @e[scores={bp_time2=-15}] ~ ~ ~ execute @a[x=-27,y=4,z=-125,dx=47,dy=1000,dz=50,m=a] ~ ~ ~ summon ~-2 ~15 ~ tnt
execute @e[tag=bomb_bp] ~ ~ ~ execute @e[scores={bp_time2=-15}] ~ ~ ~ execute @a[x=-30,y=4,z=-125,dx=50,dy=1000,dz=47,m=a] ~ ~ ~ summon ~ ~15 ~2 tnt
execute @e[tag=bomb_bp] ~ ~ ~ execute @e[scores={bp_time2=-15}] ~ ~ ~ execute @a[x=-30,y=4,z=-122,dx=50,dy=1000,dz=47,m=a] ~ ~ ~ summon ~ ~15 ~-2 tnt

#stone_bp-石柱を設置する
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ execute @e[tag=stone_bp] ~ ~ ~ summon armor_stand -48 248 -122
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ execute @e[tag=stone_bp] -48 248 -122 tag @e[c=1,type=armor_stand] add sbp
scoreboard players add @e[tag=sbp] sp 1
scoreboard players set @e[tag=sbp,scores={sp=6..}] sp 1
execute @e[tag=sbp,scores={sp=1}] ~ ~ ~ fill ~ 15 ~ ~ 20 ~ obsidian
spreadplayers -4.5 -99.5 0 25 @e[tag=sbp,scores={sp=1}]
execute @e[tag=sbp,scores={sp=1}] ~ ~ ~ tp @s ~ 255 ~
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ tag @e remove stone_bp

#random_bp-ランダムで穴をあける
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ execute @e[tag=random_bp] ~ ~ ~ summon armor_stand -48 248 -122
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ execute @e[tag=random_bp] ~ ~ ~ summon armor_stand -48 248 -122
execute @e[tag=random_bp] -48 248 -122 tag @e[c=2,type=armor_stand] add ran
execute @e[tag=random_bp] ~ ~ ~ scoreboard players set @e[tag=ran] sp 1
execute @e[tag=ran,scores={sp=1}] ~ ~ ~ fill ~ 5 ~ ~ 20 ~ air
spreadplayers -4.5 -99.5 0 25 @e[tag=ran,scores={sp=1}]
execute @e[tag=ran,scores={sp=1}] ~ ~ ~ tp @s ~ 255 ~
execute @e[tag=select,scores={sn=140},type=armor_stand] ~ ~ ~ tag @e remove random_bp
#####################################################################

#開始までの通知
execute @e[tag=select,scores={sn=30},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§e<<BlockParty>>\n§eこのゲームは、様々な色のテラコッタの上のステージで\n一定時間ごとに色が指定されプレイヤーに手渡されます。\nその色「以外」のステージ上のブロックが制限時間後消滅します。\n\nステージ上から落ちずに長い時間生き残った人が勝利です。\n特殊効果や、時間経過での制限時間短縮、妨害などがあるので注意。"}]}

execute @e[tag=select,scores={sn=150},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"開始までのカウントダウンを開始します"}]}
execute @e[tag=select,scores={sn=200},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a5 seconds..."}]}
execute @e[tag=select,scores={sn=200},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=220},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a4 seconds..."}]}
execute @e[tag=select,scores={sn=220},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=240},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a3 seconds..."}]}
execute @e[tag=select,scores={sn=240},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=260},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§a2 seconds..."}]}
execute @e[tag=select,scores={sn=260},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=280},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§c1 §asecond"}]}
execute @e[tag=select,scores={sn=280},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={sn=300},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§eStart!!!"}]}
execute @e[tag=select,scores={sn=300},type=armor_stand] ~ ~ ~ playsound random.levelup @a

#プレイヤーをテレポート
execute @e[tag=select,scores={sn=300},type=armor_stand] ~ ~ ~ execute @a[x=-5,y=60,z=-98,r=2] ~ ~ ~ tp @s ~ 15 ~

#ゲーム本回路を起動
execute @e[tag=select,scores={sn=300..310},type=armor_stand] ~ ~ ~ scoreboard players set @s sn 1000
#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#

scoreboard objectives add game.management dummy manage

#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
#ゲーム本回路流れを構築
execute @e[tag=select,scores={sn=1000..},type=armor_stand] ~ ~ ~ scoreboard players add @s sn 1
execute @e[tag=select,scores={sn=1000..},type=armor_stand] ~ ~ ~ scoreboard players add @s game.management 1

#次回の色を指定する
execute @e[tag=select,scores={sn=1010},type=armor_stand] ~ ~ ~ scoreboard players random @s random 1 9

##############色識別ブロック配布#########################################
execute @e[tag=select,scores={sn=1015,random=1}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] white_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=2}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] brown_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=3}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] lime_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=4}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] yellow_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=5}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] green_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=6}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] red_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=7}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] light_blue_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=8}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] blue_glazed_terracotta
execute @e[tag=select,scores={sn=1015,random=9}] ~ ~ ~ give @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] purple_glazed_terracotta
#########################################################################

#次の実行コマンドの前提としての実行
execute @e[tag=select,scores={sn=1015},type=armor_stand] ~ ~ ~ scoreboard players add @s bp_time 0

#フェーズ毎減算のためのベーススコア-40は最低値を指しこれを下回ると140へリセットする
execute @e[tag=select,scores={sn=1015,bp_time=!41..140},type=armor_stand] ~ ~ ~ scoreboard players set @s bp_time 140

#フェーズ毎減算 (フェーズ2で135 フェーズ3で130　フェーズ4で125 など)
execute @e[tag=select,scores={sn=1015,bp_time=45..140},type=armor_stand] ~ ~ ~ scoreboard players add @s bp_time -5

#フェーズ毎減算した後のスコアbp_timeをリアルタイム減算スコアbp_time2へ代入します
execute @e[tag=select,scores={sn=1015,bp_time=40..140},type=armor_stand] ~ ~ ~ scoreboard players operation @s bp_time2 = @s bp_time

#リアルタイム減算スコアbp_time2が-21になるとリセットするので-20までリアルタイム減算し続けます
execute @e[tag=select,scores={bp_time2=-20..},type=armor_stand] ~ ~ ~ scoreboard players add @s bp_time2 -1

#効果音
execute @e[tag=select,scores={bp_time2=60},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=40},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=30},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=20},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=10},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=5},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=3},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=1},type=armor_stand] ~ ~ ~ playsound random.orb @a
execute @e[tag=select,scores={bp_time2=0},type=armor_stand] ~ ~ ~ playsound random.levelup @a
execute @e[tag=select,scores={bp_time2=-20},type=armor_stand] ~ ~ ~ playsound random.totem @a
#アマスタの保険
execute @e[tag=select,scores={sn=1015..,bp_time2=0},type=armor_stand] ~ ~ ~ execute @e[tag=clear] ~ ~ ~ tp @s ~ 14 ~

##############色識別ブロック削除#########################################
execute @e[tag=select,scores={bp_time2=0,random=1},type=armor_stand] ~ ~ ~ function bp/white
execute @e[tag=select,scores={bp_time2=0,random=2},type=armor_stand] ~ ~ ~ function bp/brown
execute @e[tag=select,scores={bp_time2=0,random=3},type=armor_stand] ~ ~ ~ function bp/kimidori
execute @e[tag=select,scores={bp_time2=0,random=4},type=armor_stand] ~ ~ ~ function bp/yellow
execute @e[tag=select,scores={bp_time2=0,random=5},type=armor_stand] ~ ~ ~ function bp/green
execute @e[tag=select,scores={bp_time2=0,random=6},type=armor_stand] ~ ~ ~ function bp/red
execute @e[tag=select,scores={bp_time2=0,random=7},type=armor_stand] ~ ~ ~ function bp/mizu
execute @e[tag=select,scores={bp_time2=0,random=8},type=armor_stand] ~ ~ ~ function bp/blue
execute @e[tag=select,scores={bp_time2=0,random=9},type=armor_stand] ~ ~ ~ function bp/purple
#########################################################################

#ゲームの流れをリセットさせます
execute @e[tag=select,scores={bp_time2=-10},type=armor_stand] ~ ~ ~ scoreboard players set @s sn 1000

#ステージの再構築
execute @e[tag=select,scores={bp_time2=-15},type=armor_stand] ~ ~ ~ execute @s[tag=bpcl1] ~ ~ ~ execute @e[tag=clone,c=1,type=armor_stand] ~ ~ ~ clone ~50 ~ ~50 ~ ~ ~ -30 14 -125
execute @e[tag=select,scores={bp_time2=-15},type=armor_stand] ~ ~ ~ execute @s[tag=bpcl2] ~ ~ ~ execute @e[tag=clone2,c=1,type=armor_stand] ~ ~ ~ clone ~50 ~ ~50 ~ ~ ~ -30 14 -125

#通知アイテムの削除
execute @e[tag=select,scores={bp_time2=..0},type=armor_stand] ~ ~ ~ clear @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50,m=a]
execute @e[tag=select,scores={bp_time2=..0},type=armor_stand] ~ ~ ~ kill @e[x=-30,y=0,z=-125,dx=50,dy=10,dz=50,type=item]

#ゲームループ特別ルール
execute @e[tag=select,scores={game.management=2260},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§cサドンデスモード突入\n§aゲームがループしました。爆弾が召喚されるようになります。"}]}
execute @e[tag=select,scores={game.management=2260},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§cWarning!!!"}]}
execute @e[tag=select,scores={game.management=2255},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=2260},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=2265},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=2260..,bp_time2=-20..-15},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~20 ~

execute @e[tag=select,scores={game.management=2260..},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ effect @s resistance 1 3 true

#ゲームループ特別ルール2
execute @e[tag=select,scores={game.management=4500},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§cエクストラモード突入\n§aゲームが三週目に突入しました。爆弾が変形召喚するようになります。"}]}
execute @e[tag=select,scores={game.management=4500},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§cWarning!!!"}]}
execute @e[tag=select,scores={game.management=4495},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=4500},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=4505},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=4500..,bp_time2=-20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~2 ~ ~
execute @e[tag=select,scores={game.management=4500..,bp_time2=-20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~-2 ~ ~
execute @e[tag=select,scores={game.management=4500..,bp_time2=-20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~2
execute @e[tag=select,scores={game.management=4500..,bp_time2=-20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~-2

#ゲームループ特別ルール3
execute @e[tag=select,scores={game.management=6750},type=armor_stand] ~ ~ ~ tellraw @a {"rawtext":[{"text":"§c蛍の光モード突入\n§aゲームが4週目に突入しました。閉店のお時間です。"}]}
execute @e[tag=select,scores={game.management=6750},type=armor_stand] ~ ~ ~ titleraw @a title {"rawtext": [{"text":"§cWarning!!!"}]}
execute @e[tag=select,scores={game.management=6745},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=6750},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=6755},type=armor_stand] ~ ~ ~ playsound random.totem @a
execute @e[tag=select,scores={game.management=6750..,bp_time2=80},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=40},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~-5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~5
execute @e[tag=select,scores={game.management=6750..,bp_time2=10},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~-5
execute @e[tag=select,scores={game.management=6750..,bp_time2=80},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~-5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=40},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~-5
execute @e[tag=select,scores={game.management=6750..,bp_time2=10},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~5
execute @e[tag=select,scores={game.management=6750..,bp_time2=80},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~5
execute @e[tag=select,scores={game.management=6750..,bp_time2=40},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~-5
execute @e[tag=select,scores={game.management=6750..,bp_time2=20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=10},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~-5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=80},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~-5
execute @e[tag=select,scores={game.management=6750..,bp_time2=40},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~ ~ ~5
execute @e[tag=select,scores={game.management=6750..,bp_time2=20},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~-5 ~ ~
execute @e[tag=select,scores={game.management=6750..,bp_time2=10},type=armor_stand] ~ ~ ~ execute @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50] ~ ~ ~ summon tnt ~5 ~ ~

execute @e[tag=select,scores={game.management=2260..},type=armor_stand] ~ ~ ~ execute @e[type=tnt] ~ ~ ~ detect ~ 0 ~ bedrock 0 kill @s

execute @e[tag=select,scores={game.management=0..},type=armor_stand] ~ ~ ~ xp 10 @a[x=-30,y=6,z=-125,dx=50,dy=10,dz=50]

#####################################################################################################
####終了処理

#人数計測function-見返りとしてsarchplayerのsarchplayerに人数を出力します
execute @e[tag=select,scores={game.management=100..},type=armor_stand] ~ ~ ~ function sys.sarchplayer.azi
execute @e[tag=select,scores={game.management=100..},type=armor_stand] ~ ~ ~ scoreboard players operation @s players = sarchplayer sarchplayer

#人数が0になったらゲームを終了します
execute @e[tag=select,scores={game.management=100..,players=0},type=armor_stand] ~ ~ ~ function azi/new.gameend.sytem



scoreboard players operation "§eブロック消滅まで..." blockparty = @e[tag=select,type=armor_stand] bp_time2
scoreboard players operation "§d今回フェーズ時間" blockparty = @e[tag=select,type=armor_stand] bp_time

#scoreboard players operation "デバッガー-phase" blockparty = @e[tag=select,type=armor_stand] sn
scoreboard players reset "デバッガー-phase" blockparty
#scoreboard players operation "デバッガー-general" blockparty = @e[tag=select,type=armor_stand] game.management
scoreboard players reset "デバッガー-general" blockparty

scoreboard players operation "§bプレイヤー人数" blockparty = @e[tag=select,type=armor_stand] players
execute @e[tag=select,type=armor_stand] ~ ~ ~ scoreboard objectives setdisplay sidebar blockparty
scoreboard players set "---------------------" blockparty -30
scoreboard players set "毎フェーズ開始時にテラコッタが一個配布されます" blockparty -31
scoreboard players set "その色以外のテラコッタがフェーズ終了時に消えます" blockparty -32
scoreboard players set "その色のテラコッタの上で待機し落ちないように避けてください" blockparty -33
