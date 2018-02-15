    # t.date "trade_date"            #取引日
    # t.integer "figure"             #金額
    # t.integer "trade_type_id"      #関連取引種類
    # t.integer "schedule_id"        #関連スケジュール

class Journal < ApplicationRecord
  belongs_to :trade_type
  belongs_to :schedule
  has_many :memos, as: :memoable
  has_and_belongs_to_many :details
end
