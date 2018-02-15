    # t.string "otherside_name"          #相手先名
    # t.integer "type"                   #相手種類 0:company 1:friend
    # t.integer "user_id"                #関連ユーザー

class Otherside < ApplicationRecord
  belongs_to :user
  has_many :schedules
  has_many :accounts
  has_many :memos, as: :memoable
end
