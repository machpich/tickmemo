    # t.string "otherside_name"          #相手先名
    # t.integer "user_id"                #関連ユーザー

class Otherside < ApplicationRecord
  belongs_to :user
  has_many :schedules, inverse_of: :otherside
  has_many :journals
  has_many :details
  has_one :memo, as: :memoable, inverse_of: :memoable

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :memo

# validations
  validates :otherside_name, presence: true
end
