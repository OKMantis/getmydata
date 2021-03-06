class User < ApplicationRecord
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :messages, dependent: :destroy
  has_many :user_selections, dependent: :destroy
  has_many :companies, through: :messages

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true

  mount_uploader :identification, PhotoUploader
  mount_uploader :avatar, PhotoUploader
end
