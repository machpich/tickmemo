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
  has_many :locations, dependent: :delete_all

  attachment :profile_image

# validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }#必須項目
  validates :encrypted_password, presence: true #必須項目
end
