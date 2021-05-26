#! /usr/bin/env ruby
# coding: utf-8

# 標準入力から変換元ファイルを読み込んで、標準出力に変換結果を出力
# 以下のように実行
# $ /convert.rb < tntrun.game.mcfunction   > tntrun.game.mcfunction-toshi

def conv_execute line
  # execute の引数を取得
  # 以下の記述になっていることを想定
  #   行頭が "execute"
  #   セレクタ
  #   x, y, z 座標
  #   実行するコマンド
  # 最短マッチさせるために .+ ではなく .+? を利用
  if /^execute (.+?) (.+?) (.+?) (.+?) (.*)/ =~ line
    selector, x, y, z, cmd = $1, $2, $3, $4, $5
  else
    # x,y,z座標以降が存在しない場合
    /^execute (.+)/ =~ line
    selector = $1
    # positioned を付加するための判定に x を使っているので、ダミー値を代入
    x = "~"    
  end

  # セレクタの中身の解析
  # まず "["と"]" の中身を切り出す
  /^@.+\[(.*)\]/ =~ selector
  # 切り出した内容を param に格納
  #   解析を楽にするために、末尾に "," を追加
  param = $1 + ','

  # セレクタの中身を格納するためのハッシュを生成
  params = {}

  # セレクタの中身の文字列が空文字列でないということは、未解析のパラメータが残っているはず
  while param != ''
    # "変数名=値, " の組を切り出して [変数名, 値] の配列（タプル）を作って、params 配列に追加していく
    /(.+?)=(.+?),(.*)/.match param
    key, value, left = $1, $2, $3

    # value が "{" で始まっていた場合、"}" より前に "," が来る可能性があるので、再判定
    if /^\{/ =~ value
      /(.+?)=(\{.+?\}),(.*)/.match param
      key, value, left = $1, $2, $3
    end

    params[key] = value
    param = left
  end

  # 解析結果デバッグ用プリント
  # p [0, line]
  # p [1, params, x, y, z, cmd]

  # 出力用文字列を生成
  result = "execute as @e["
  
  # セレクタ内引数の変換
  #  r & rm
  if params.has_key?('r') && params.has_key?('rm')
    params['distance'] = "#{params['rm']}..#{params['r']}"
    params.delete 'r'
    params.delete 'rm'
  elsif params.has_key?('r')
    params['distance'] = "..#{params['r']}"
    params.delete 'r'
  elsif params.has_key?('rm')
    params['distance'] = "#{params['rm']}.."
    params.delete 'rm'
  end
  #  l & lm
  if params.has_key?('l') && params.has_key?('lm')
    params['level'] = "#{params['lm']}..#{params['l']}"
    params.delete 'l'
    params.delete 'lm'
  elsif params.has_key?('l')
    params['level'] = "..#{params['l']}"
    params.delete 'l'
  elsif params.has_key?('lm')
    params['level'] = "#{params['lm']}.."
    params.delete 'lm'
  end
  # c
  if params.has_key?('c')
    params['limit'] = params['c']
    params.delete 'c'
  end
#  pp [20, params]

  params.each do |key, value|
    result += "#{key}=#{value},"
  end
  # 最後の余計な "," を削除
  result.sub!(/,$/,'')
  result += "] "

  result += "positioned #{x} #{y} #{z} " if x != "~"
    
  result += "at @s "
  case cmd
  when /^execute/
    result += conv_execute cmd
  else
    result += "run #{cmd}"
  end

  return result
end

# main ルーチン
# 標準入力から１行づつ読み込み。入力行がなくなったらループを抜けて終了
while line=gets
  # 行末の改行文字を削除
  line.chomp!

  # 変換後文字列を初期化
  java_line = ''

  # 行頭が "execute" 以外の行はそのまま
  case line
  when /^execute/
    java_line += conv_execute(line)
  else
    java_line += line
  end

  puts java_line

end

  
