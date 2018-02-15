    # t.string "trade_name"     #取引名
class TradeType < ApplicationRecord
  has_many :journals
  has_many :trade_account_dicts, dependent: :destroy
end