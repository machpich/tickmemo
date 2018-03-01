    # t.string "email", default: "", null: false               #メール
    # t.string "encrypted_password", default: "", null: false  #パスワード

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, dependent: :delete_all
  has_many :schedules, dependent: :delete_all
  has_many :othersides, dependent: :delete_all
  has_many :journals, dependent: :delete_all
end
