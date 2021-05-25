#! /usr/bin/env ruby
# coding: utf-8

def conv_execute line
  # execute の引数を取得
  # 以下の記述になっていることを想定
  #   行頭が "execute"
  #   セレクタ
  #   x, y, z 座標
  #   実行するコマンド
  # 最短マッチさせるために .+ ではなく .+? を利用
  /^execute (.+?) (.+?) (.+?) (.+?) ?(.*)/ =~ line
  selector, x, y, z, cmd = $1, $2, $3, $4, $5

  # セレクタの中身の解析
  # まず "["と"]" の中身を切り出す
  /^@.+\[(.*)\]/ =~ selector
  # 切り出した内容を param に格納
  #   解析を楽にするために、末尾に "," を追加
  param = $1 + ','

  # セレクタの中身を格納するための配列を生成
  params = []

  # セレクタの中身の文字列が空文字列でないということは、未解析のパラメータが残っているはず
  while param != ''
    # "変数名=値, " の組を切り出して [変数名, 値] の配列（タプル）を作って、params 配列に追加していく
    /(.+?)=(.+?),(.*)/.match param
    key, value = $1, $2
    left = $3

    # value が "{" で始まっていた場合、"}" より前に "," が来る可能性があるので、再判定
    if /^\{/ =~ value
      /(.+?)=\{(.+?)\},(.*)/.match param
      key, value = $1, $2
      left = $3
    end

    params.push [key, value]
    param = left
  end

  # 解析結果デバッグ用プリント
  # p [0, line]
  # p [1, params, x, y, z, cmd]

  # 出力用文字列を生成
  result = "execute as @e[#{params.to_s}] at @s run #{cmd}"

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
    java_line += conv_execute line
  else
    java_line += line
  end

  puts java_line

end

  
