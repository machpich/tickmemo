    # t.integer "position_status"            #貸借フラグ　0借方　1貸方
    # t.integer "account_id"                 #関連科目
    # t.integer "otherside_id"               #関連相手先
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false

class Detail < ApplicationRecord
  belongs_to :account
  belongs_to :otherside
  belongs_to :journal

  enum position_status: { debit: 0, credit: 1 }
end
