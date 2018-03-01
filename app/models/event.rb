    # t.string "program"             #演目
    # t.string "performer"           #演者
    # t.date "date_start"            #開始日付
    # t.date "date_end"              #終了日付
    # t.string "image"               #画像
    # t.integer "user_id"            #関連ユーザー
class Event < ApplicationRecord
  belongs_to :user
  has_many :schedules, dependent: :destroy
  # has_many :schedules, inverse_of: :event
  has_many :locations
  has_one :memo, as: :memoable, inverse_of: :memoable, dependent: :destroy

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :memo, reject_if: :all_blank
end
