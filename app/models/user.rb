#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :products, dependent: :destroy
  has_many :bill_address, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :reviews, dependent: :destroy
  validates :first_name, presence: true
  # validates :second_name, presence: true
  # validates :address, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :zip, presence: true
end
