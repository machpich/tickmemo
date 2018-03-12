# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 科目ファイルの初期値作成
    account0 = %w(現金 商品)
    account1 = %w(債務 立替)

    account0.each do |key|
      Account.create(account_name:key,character_status:0)
    end

    account1.each do |key|
      Account.create(account_name:key,character_status:1)
    end

    # 現金：1
    # チケット：2
    # 債務：3
    # 立替金：4

# 取引ファイルの初期設定
    trades = [
    %w([BUY]\ 現金購入(品＋金ー) 現金購入),
    %w([BUY]\ 未払購入(品＋債務＋) 未払購入),
    %w([PAY]\ 未払精算(債務ー金ー) 未払精算),
    %w([CXL]\ 購入取消(債権＋品ー) 購入取消),
    %w([RET]\ 取消清算(金＋債権ー) 取消清算),
    %w([:BUY]\ 債務立替(債務ー立替＋) 債務立替),
    %w([:PAY]\ 立替精算(立替ー金ー) 立替精算),
    %w([:XFER]\ 立替譲渡(立替ー品ー) 立替譲渡),
    %w([:RET]\ 譲渡精算(金＋立替＋) 譲渡精算),
    %w([:XCXN]\ 譲渡取消(立替ー債務＋) 譲渡取消),
    %w(メモ メモ),
     ]

     trades.each do |trade|
      TradeType.create(trade_name:trade[0],short_name:trade[1])
     end
# 取引辞書ファイルの初期設定
    dictionaries = []
    (1..10).each do |num|
      dictionaries << Array.new(1,num)
    end

    # 現金：1
    # チケット：2
    # 債：3
    # 立替金：4

    dictionaries[0]<<[2,1]#0[BUY]現金購入(品＋金ー)
    dictionaries[1]<<[2,3]#1[BUY]未払購入(品＋債務＋)
    dictionaries[2]<<[3,1]#2[PAY]未払精算(債務ー金ー)
    dictionaries[3]<<[3,2]#3[CXL]購入取消(債権＋品ー)
    dictionaries[4]<<[1,3]#4[RET]取消清算(金＋債権ー)
    dictionaries[5]<<[3,4]#5[:BUY]債務立替(債務ー立務＋)
    dictionaries[6]<<[4,1]#6[:PAY]立替精算(立務ー金ー)
    dictionaries[7]<<[4,2]#7[:XFER]譲渡(立権＋品ー)
    dictionaries[8]<<[1,4]#8[:RET]譲渡精算(金＋立権ー)
    dictionaries[9]<<[4,3]#9[:XCXN]譲渡取消（債権＋立務＋）

    dictionaries.each do |dict|#dict=[0,[2,1]]
      TradeAccountDict.create(position_status:0,trade_type_id:dict[0],account_id:dict[1][0])
      TradeAccountDict.create(position_status:1,trade_type_id:dict[0],account_id:dict[1][1])
    end