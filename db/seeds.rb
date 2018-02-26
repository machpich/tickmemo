# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 関係者ファイルの初期設定
    Otherside.create(otherside_name:"anonymous")

# 科目ファイルの初期値作成
    account0 = %w(現金 チケット)
    account1 = %w(債務 立替金)

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
     trades = %w(現金購入 [債務+]未精算購入 [債務-]未精算支払 [債務-]購入キャンセル [債務-]キャンセル分返金 [立替+]譲渡 [立替+]立替決済 [立替-]立替返金 [立替+]借金購入 [債務-/立替-]借金掛精算) #購入者の立場
     # trades1 = %w(譲渡) #売却者の立場

     trades.each do |key|
      TradeType.create(trade_name:key)
     end
# 取引辞書ファイルの初期設定
    dictionaries = []
    (1..10).each do |num|
      dictionaries << Array.new(1,num)
    end

    dictionaries[0]<<[2,1]#現金購入（支払済）：　　チケット／現金 キャンセルは購入自体削除想定
    dictionaries[1]<<[2,3]#掛精算（未払）：　チケット／債務
    dictionaries[2]<<[3,1]#支払（未払決済）： 　 債務／現金
    dictionaries[3]<<[3,2]#キャンセル：　債務／チケット
    dictionaries[4]<<[1,3]#返金： 現金／債務
    dictionaries[5]<<[4,2]#譲渡： 立替金／チケット キャンセルは譲渡自体削除想定
    dictionaries[6]<<[4,1]#立替決済：　立替金／現金
    dictionaries[7]<<[1,4]#立替返金：　現金／立替金
    dictionaries[8]<<[2,4]#借金購入：　チケット／立替金　キャンセル=予定自体削除想定
    dictionaries[9]<<[3,4]#借金掛精算： 債務／立替金

    dictionaries.each do |dict|#dict=[0,[2,1]]
      TradeAccountDict.create(position_status:0,trade_type_id:dict[0],account_id:dict[1][0])
      TradeAccountDict.create(position_status:1,trade_type_id:dict[0],account_id:dict[1][1])
    end