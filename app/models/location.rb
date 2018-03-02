    # t.string "place_name"      #場所名
    # t.integer "event_id"       #関連イベント


class Location < ApplicationRecord
  belongs_to :user
  has_many :schedules
  has_and_belongs_to_many :events

  # accepts_nested_attributes_for :event
  # accepts_nested_attributes_for :schedules
end
