    # t.string "account_name"　科目名
    # t.integer "character_status"　科目正残　0借方正残　1貸方正残
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false

class Account < ApplicationRecord
  has_many  :details
  has_many :trade_account_dicts
end
