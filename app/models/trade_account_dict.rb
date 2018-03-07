    # t.integer "position_status"        #貸借フラグ  0借方 1貸方
    # t.integer "trade_type_id"          #取引タイプ
    # t.integer "account_id"             #科目

class TradeAccountDict < ApplicationRecord
  belongs_to :trade_type
  belongs_to :account

  enum position_status: { debit: 0, credit: 1 }
end
