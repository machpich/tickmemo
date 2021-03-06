    # t.string "program"             #演目
    # t.string "performer"           #演者
    # t.date "date_start"            #開始日付
    # t.date "date_end"              #終了日付
    # t.string "image"               #画像
    # t.integer "user_id"            #関連ユーザー
class Event < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :schedules, dependent: :destroy
  has_one :memo, as: :memoable, inverse_of: :memoable, dependent: :destroy
  has_and_belongs_to_many :locations

  accepts_nested_attributes_for :memo, reject_if: :all_blank

  # validation
  # validates :url, format: /\A#{URI::regexp(%w(http https))}\z/
end
