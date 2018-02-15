    # t.string "email", default: "", null: false               #メール
    # t.string "encrypted_password", default: "", null: false  #パスワード

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events
  has_many :schedules
  has_many :othersides
end
