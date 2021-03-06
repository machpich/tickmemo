    # t.string "otherside_name"          #相手先名
    # t.integer "user_id"                #関連ユーザー

class Otherside < ApplicationRecord
  belongs_to :user
  has_many :schedules, inverse_of: :otherside, dependent: :destroy
  has_many :journals, dependent: :destroy
  has_many :details
  has_one :memo, as: :memoable, inverse_of: :memoable, dependent: :destroy

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :memo

# validations
  # validates :url, format: /\A#{URI::regexp(%w(http https))}\z/
end
