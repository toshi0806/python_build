#! /usr/bin/env ruby
# coding: utf-8

# 実行するコマンドで、再度 execute が出てくる場合があるので、メソッド化しておく
def get_execute_params line
# 以下の記述になっていることを想定
#   行頭が "execute"
#   セレクタ
#   x, y, z 座標
#   実行するコマンド
# 最短マッチさせるために .+ ではなく .+? を利用
  if /^execute (.+?) (.+?) (.+?) (.+?) ?(.*)/ =~ line
    # 返り値は [引数, x座標, y座標, z座標, 実行コマンド]　という配列
    return $1, $2, $3, $4, $5
  else
    # マッチしなかったら、標準エラー出力に警告を出力して終了
    STDERR.puts 'match fail'
    exit
  end
end

# 標準入力から１行づつ読み込み。入力行がなくなったらループを抜けて終了
while line=gets
  # 行末の改行文字を削除
  line.chomp!

  # 行頭が "execute" 以外の行は無視
  next unless line =~ /^execute/

  # execute の引数を取得
  selector, x, y, z, cmd = get_execute_params line

  # セレクタの中身の解析
  # まず "["と"]" の中身を切り出す
  /^@.+\[(.*)\]/ =~ selector
  # 切り出した内容を param に格納
  param = $1
  # param の解析を楽にするために、末尾に "," を追加
  param += ','

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

# デバッグ用プリント
#  p [0, line]
#  p [1, params, x, y, z, cmd]
end

  
