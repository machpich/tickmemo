    # t.datetime "start_datetime"          #開始日時
    # t.datetime "end_datetime"            #終了日時
    # t.string "seat_type"                 #座席種類
    # t.boolean "fix"                      #確定予定 true:確定
    # t.boolean "check"                    #支払有無 true:支払済
    # t.integer "location_id"              #関連場所
    # t.integer "event_id"                 #関連イベント
    # t.integer "otherside_id"             #関連相手先
    # t.integer "user_id"                  #関連ユーザー

class Schedule < ApplicationRecord
  belongs_to :location
  belongs_to :event
  belongs_to :otherside
  belongs_to :user
  has_many :journal
  has_many :memos, as: :memoable
end
