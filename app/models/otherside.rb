    # t.string "otherside_name"          #相手先名
    # t.integer "type"                   #相手種類 0:company 1:friend
    # t.integer "user_id"                #関連ユーザー

class Otherside < ApplicationRecord
  belongs_to :user
  has_many :schedules, inverse_of: :otherside
  has_many :journals
  has_many :details
  # , through: :journals
  has_one :memo, as: :memoable, inverse_of: :memoable

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :memo

  validates :otherside_name, presence: true

  # enum type: { none:0 ,cooporation: 1, friend: 2 }

end
